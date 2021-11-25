function x = chebpts1(n, ab)%#codegen
%% CHEBPTS1 Calculate the Chebyshev nodes of degree K
%
% X = CHEBPTS1(N) calculates the Chebyshev points of the first kind, or
% Chebyshev nodes, or, more formally, Chebyshev-Gauss points for a Chebyshev
% polynomial of degree N.
%
% The points are given by
%
%   $$x_{k} = cos( \frac{ ( 2k + 1 ) \pi }{ 2 N } ), k = 0, \dots, N$$
%
% X = CHEBPTS1(N, AB) uses interval boundaries AB where AB is an increasing
% 2-element vector of an arbitrary interval. An affine transformation is applied
% to calculate the Chebyshev nodes of the shifted Chebyshev polynomial of degree
% N.
%
% Inputs:
%
%   N                   Degree of chebyshev polynomial.
%
%   AB                  Interval for which to determine the Chebyshev nodes.
%                       Default: [-1, 1];
%
% Outputs:
%
%   X                   Nx1 vector of Chebyshev nodes on the interval T.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-18
% Changelog:
%   2021-11-18
%       * Initial release



%% Parse arguments

% CHEBPTS1(N)
% CHEBPTS1(N, AB)
narginchk(1, 2);

% CHEBPTS1(___)
% X = CHEBPTS1(___)
nargoutchk(0, 1);

% Default interval boundary
if nargin < 2 || isempty(ab)
  ab = [ -1.0 , +1.0 ];
end



%% Algorithm

% Get interval boundaries
a = ab(1);
b = ab(2);

% Calculate Chebyshev nodes over arbitrary interval [a, b]
x = 0.5 * (a + b) + 0.5 * (b - a) .* cos( ( 2 * (1:n) - 1 ) .* pi ./ 2 ./ n );
% Set singular values to zero
x(issingular(x)) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
