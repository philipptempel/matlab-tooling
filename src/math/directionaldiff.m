function [dd, err, finaldelta] = directionaldiff(fun, x0, vec)
%% DIRECTIONALDIFF estimate directional derivative of a function of n variables
% 
% [DD ERR, FINDELTA] = DIRECTIONALDIFF(FUN, X0, VEC) uses DERIVEST provide both
% a directional derivative estimates plus an error estimates. FUN needs not be
% vectorized.
% 
% Inputs:
%
%   FUN                 Analytical function to differentiate. FUN must be a
%                       function of the vector or array X0. FUN needs not be
%                       vectorized.
% 
%   X0                  Vector location at which to differentiate FUN. If X0 is
%                       an NxM array, then FUN is assumed to be a function of
%                       N*M variables.
%
%   VEC                 Vector defining the line along which to take the
%                       derivative. VEC should be the same size as X0. It need
%                       not be a vector of unit length.
%
% Outputs:
% 
%   DD                  Scalar estimate of the first derivative of FUN in the
%                       direction specified by VEC.
%
%   ERR                 Error estimate of the directional derivative.
%
%   FINDELTA            Vector of final step sizes chosen for each partial
%                       derivative.
%
% Examples:
% 
% At the global minimizer (1,1) of the Rosenbrock function, compute the
% directional derivative in the direction [1, 2]. It should be 0.
%
%   rosen = @(x) (1-x(1)).^2 + 105*(x(2)-x(1).^2).^2;
%   [dd,err] = directionaldiff(rosen,[1 1])
%   dd =
%       0
%   err =
%       0
%
% See also
%   DERIVEST GRADEST GRADIENT



%% File information
% Author: John D'Errico <woodchips@rochester.rr.com>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2007-03-05
%       * Initial release

% get the size of x0 so we can make sure vec is
% the same shape.
sx = size(x0);

if numel(x0) ~= numel(vec)
  error('vec and x0 must be the same sizes.');
end

vec = vec(:);
vec = reshape(vec ./ norm(vec), sx);

[dd, err, finaldelta] = derivest( ...
    @(t) fun(x0 + t .* vec) ...
  , 0 ...
  , 'deriv', 1 ...
  , 'vectorized', 'no' ...
);

end
