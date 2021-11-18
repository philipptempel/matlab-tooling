function [grad, err, finaldelta] = gradest(fun, x0, varargin)
%% GRADEST estimate gradient vector of an analytical function of n variables
%
% [GRAD, ERR, FINDELTA] = GRADEST(FUN, X0) uses DERIVEST to provide both
% derivative estimates and error estimates. FUN needs not be vectorized.
%
% Inputs:
%
%   FUN                 Analytical function to differentiate. FUN must be a
%                       function of the vector or array X0.
% 
%   X0                  Vector location at which to differentiate FUN. If X0 is
%                       an NxM array, then FUN is assumed to be a function of
%                       N*M variables.
%
% Outputs:
%
%   GRAD                Vector of first partial derivatives of FUN. GRAD will be
%                       a vector of size of X0.
%
%   ERR                 Vector of error estimates corresponding to each partial
%                       derivative in GRAD.
%
%   FINDELTA            Vector of final step sizes chosen for each partial
%                       derivative.
%
% Examples:
%
%   [grad,err] = gradest(@(x) sum(x.^2), [1, 2, 3])
%   grad =
%       2     4     6
%   err =
%       5.8899e-15    1.178e-14            0
%
% At [x,y] = [1,1], compute the numerical gradient of the function
% sin(x-y) + y*exp(x)
%
%   z = @(xy) sin(diff(xy)) + xy(2)*exp(xy(1))
%
%   [grad,err ] = gradest(z,[1 1])
%   grad =
%       1.7183       3.7183
%   err =
%       7.537e-14   1.1846e-13
%
% At the global minimizer (1, 1) of the Rosenbrock function, compute the
% gradient. It should be essentially zero.
%
%   rosen = @(x) (1 - x(1)).^2 + 105*(x(2) - x(1).^2).^2;
%   [g,err] = gradest(rosen, [1, 1])
%   g =
%     1.0843e-20            0
%   err =
%     1.9075e-18            0
%
% See also
%   DERIVEST GRADIENT



%% File information
% Author: John D'Errico <woodchips@rochester.rr.com>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2007-02-09
%       * Initial release



% get the size of x0 so we can reshape
% later.
sx = size(x0);

% total number of derivatives we will need to take
nx = numel(x0);

grad = zeros(1, nx);
err = grad;
finaldelta = grad;

for ind = 1:nx
  [ grad(ind), err(ind), finaldelta(ind) ] = derivest( ...
    @(xi) fun(swapelement(x0, ind, xi)) ...
    , x0(ind) ...
    , 'Deriv', 1 ...
    , 'Vectorized', 'no' ...
    , 'MethodOrder', 2 ...
    , varargin{:} ...
  );
end


grad = reshape(grad, sx);


end


% =======================================
%      sub-functions
% =======================================
function vec = swapelement(vec, ind,val)

% swaps val as element ind, into the vector vec
vec(ind) = val;

end
