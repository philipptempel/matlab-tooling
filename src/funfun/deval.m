function varargout = deval(sol, xint, idx)
%% DEVAL
%
% Inputs:
%
%   SOL                     Description of argument SOL
% 
%   XINT                    Description of argument XINT
% 
%   IDX                     Description of argument IDX
%
% Outputs:
%
%   SXINT                   Description of argument SXINT
% 
%   SPXINT                  Description of argument SPXINT



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-04-25
% Changelog:
%   2022-04-25
%       * Use `SWAP` to flip inputs if SOL and XINT are permuted
%   2022-01-18
%       * Initial release



%% Parse arguments

% DEVAL(SOL, X)
% DEVAL(X, SOL)
% DEVAL(___, iDX)
narginchk(2, 3);

% DEVAL(...)
% Y = DEVAL(...)
% [Y, YP] = DEVAL(...)
nargoutchk(0, 2);

% DEVAL(XINT, SOL)
if ~isa(sol, 'struct')
  % Flip first two arguments
  [sol, xint] = swap(xint, sol);
  
end

try
  t = sol.x;
  y = sol.y;
  
catch
  error(message('MATLAB:deval:SolNotFromDiffEqSolver', inputname(1)));
  
end

% DEVAL(SOL, X)
% DEVAL(X, SOL)
if nargin < 3
  % Return all solution components
  idx = 1:size(y, 1);

% Return only some solution components
elseif any(idx < 0) || any(idx > size(y, 1))
  error(message('MATLAB:deval:IDXInvalidSolComp', inputname(3)));
  
end



%% Algorithm

% Indices to extract from solution
idx = idx(:);

% Get solver from solution
if isfield(sol, 'solver')
  solver = sol.solver;
  
% No solver in solution structure found
else
  error(message('MATLAB:deval:NoSolverInStruct', inputname(1)));
  
end

% Adding a custom ODE solver to the `deval` store
switch solver
  case 'odespec'
    % Interpolation for spectral integration is based on Lagrange interpolation
    tint = transpose(xint(:));
    tdir = sign(t(end) - t(1));
    had2sort = any(tdir * diff(tint) < 0);
    if had2sort
      [ tint, tint_order ] = sort(tdir * tint);
      tint = tdir * tint;
    end
    
    % Using the sorted version of tint, test for illegal values.
    if any(isnan(tint)) || ( tdir * ( tint(1) - t(1) ) < 0 ) || ( tdir * ( tint(end) - t(end) ) > 0 )
      error(message('MATLAB:deval:SolOutsideInterval', sprintf('%e', t(1)), sprintf('%e', t(end))));
    end
    
    % Get data from spectral result array
    y_ = permute(y(idx,:), [2, 1]);
    ny = size(y_, 2);
    
    % Lagrange interpolation for result of spectral integration
    yint = laginterp(t, y_, tint);
    % Make sure that YINT is an NxT array
    if ny > 1
      yint = permute(yint, [2, 1]);
    end
    
    % Restore the order of tint in the output
    if had2sort
      yint(:,tint_order) = yint;
    end
    varargout{1} = yint;
  
  % Fallback to default `DEVAL`
  otherwise
    % Call MATLAB's `DEVAL` function using the shadowed version of `DEVAL`
    [varargout{1:nargout}] = feval(shadowed('deval'), sol, xint, idx);
    
end



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.

