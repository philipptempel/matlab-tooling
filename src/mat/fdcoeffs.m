function c = fdcoeffs(d, x, xi)%#codegen
%% FDCOEFFS Calculate finite differences coefficients of arbitrary direction
%
% C = FDCOEFFS(D, X) calculates the finite differences coefficients for a given
% derivative degree D and given a vector of stencil points X.
%
% C = FDCOEFFS(___, XI) centers the finite differences points around XI.
% Defaults to 0.
%
% This algorithm is an implementation of B. Fornberg, “Generation of finite
% difference formulas on arbitrarily spaced grids,” Math. Comp., vol. 51, no.
% 184, pp. 699–699, 1988, doi: 10.1090/s0025-5718-1988-0935077-0. [Online].
% Available: http://dx.doi.org/10.1090/S0025-5718-1988-0935077-0
%
% Inputs:
%
%   D                   Derivative order, must be greater than or equal to 1.
%
%   X                   1xK vector of stencil points.
%
%   XI                  Center points of stencils. Defaults to 0.
%
% Outputs:
%
%   C                   1xK vector of coefficients for finite differences.
%
% See also:
%   BFDCOEFFS CFDCOEFFS FFDCOEFFS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-05-31
% Changelog:
%   2021-05-31
%       * Initial release



%% Parse arguments

% FDCOEFFS(D, X)
% FDCOEFFS(D, X, XI)
narginchk(2, 3);

% FDCOEFFS(___)
% C = FDCOEFFS(___)
nargoutchk(0, 1);

if nargin < 3 || isempty(xi)
  xi = 0;
end



%% Algorithm

N = numel(x) - 1;

delta = nan(d, d, d);

idx = @(v) v + 1;

delta(idx(0), idx(0), idx(0)) = 1;
c1 = 1;

for n = 1:N
  c2 = 1;
  
  for nu = 0:(n-1)
    c3 = x(idx(n)) - x(idx(nu));
    c2 = c2 * c3;
    
    if n <= d
      delta(idx(n), idx(n-1), idx(nu)) = 0;
    end
    
    for m = 0:min(n, d)
      if m == 0
        delta(idx(m), idx(n), idx(nu)) = ( (x(idx(n)) - xi) * delta(idx(m), idx(n - 1), idx(nu)) ) / c3;
        
      else
        delta(idx(m), idx(n), idx(nu)) = ( (x(idx(n)) - xi) * delta(idx(m), idx(n - 1), idx(nu)) - m * delta(idx(m - 1), idx(n - 1), idx(nu)) ) / c3;
        
      end
      
    end
    
  end
  
  for m = 0:min(n, d)
    if m == 0
      delta(idx(m), idx(n), idx(n)) = c1 / c2 * ( - ( x(idx(n-1)) - xi ) * delta(idx(m), idx(n - 1), idx(n - 1)) );
      
    else
      delta(idx(m), idx(n), idx(n)) = c1 / c2 * ( m * delta(idx(m - 1), idx(n - 1), idx(n - 1)) - ( x(idx(n-1)) - xi ) * delta(idx(m), idx(n - 1), idx(n - 1)) );
      
    end
    
  end
  
  c1 = c2;
  
end

c = transpose(squeeze(delta(idx(d), idx(N), :)));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
