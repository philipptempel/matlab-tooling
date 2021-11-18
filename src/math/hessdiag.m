function [hd, err, finaldelta] = hessdiag(fun, x0)
%% HESSDIAG Diagonal elements of the Hessian matrix of a function
%
% When all that you want are the diagonal elements of the hessian matrix, it
% will be more efficient to call HESSDIAG than HESSIAN. HESSDIAG uses DERIVEST
% to provide both second derivative estimates and error estimates. fun needs not
% be vectorized.
%
% HESSDIAG = HESSEST(FUN, XO) calculates diagonal elements of the Hessian matrix
% (vector of second partials)
%
% [HESSDIAG, ERR] = HESSEST(FUN, XO) also returns error estimates ERR of each
% Hessian diagonal element.
%
% [HESSDIAG, ERR, FINALDELTA] = HESSEST(FUN, XO) also returns final step sizes
% for each second partial derivative.
% 
% Inputs:
%
%   FUN                 SCALAR analytical function to differentiate. FUN must be
%                       a function of the vector or array X0.
% 
%   X0                  Vector location at which to differentiate FUN. If X0 is
%                       an NxM array, then FUN is assumed to be a function of
%                       N*M variables.
%
% Outputs:
% 
%   HD                  Vector of second partial derivatives of FUN. These are
%                       the diagonal elements of the Hessian matrix, evaluated
%                       at X0. HD will be a row vector of size of X0.
%
%  	ERR                 Vector of error estimates corresponding to each second
%                       partial derivative in HD.
%
%  FINDELTA             Vector of final step sizes chosen for each second
%                       partial derivative.
%
% Examples:
%
%   [HD, err] = hessdiag(@(x) x(1) + x(2)^2 + x(3)^3, [1, 2, 3])
%   HD =
%     0     2    18
%
%   err =
%     0     0     0
%
% See also
%   DERIVEST GRADIENT GRADEST




%% File information
% Author: John D'Errico <woodchips@rochester.rr.com>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-07-16
%         * Initial release



%% Parse inputs

% get the size of x0 so we can reshape later.
sx = size(x0);

% total number of derivatives we will need to take
nx = numel(x0);

% Init variables
hd = zeros(nx, 1);
err = hd;
finaldelta = hd;

% Loop over each second derivative
for ind = 1:nx
  [hd(ind), err(ind), finaldelta(ind)] = derivest( ...
      @(xi) fun(swapelement(x0,ind,xi)) ...
    , x0(ind) ...
    , 'deriv', 2 ...
    ,'vectorized', 'no' ...
  );

end

% Adjust size
hd = reshape(hd, sx);
err = reshape(err, sx);
finaldelta = reshape(finaldelta, sx);


end


% =======================================
%      sub-functions
% =======================================
function vec = swapelement(vec,ind,val)
% swaps val as element ind, into the vector vec
vec(ind) = val;

end % sub-function end
