function x = chebpts2(n, ab)%#codegen
%% CHEBPTS2 Calculate the Chebyshev points of degree N
%
% X = CHEBPTS2(N) calculates the Chebyshev points of the second kind, or
% Chebyshev extreme points, or Chebyshev–Lobatto points for a Chebyshev
% polynomial of degree N.
%
% The points are given by
%
%   $$x_{k} = cos( \frac{ k \pi }{ N } ), k = 0, \dots, N$$
%
% X = CHEBPTS2(N, AB) uses interval boundaries AB where AB is an increasing
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
%   X                   1x(N+1) vector of Chebyshev points of the second kind.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-19
% Changelog:
%   2021-11-19
%       * Initial release



%% Parse arguments

% CHEBPTS2(N)
% CHEBPTS2(N, AB)
narginchk(1, 2);

% CHEBPTS2(___)
% X = CHEBPTS2(___)
nargoutchk(0, 1);

% Default interval boundary
if nargin < 2 || isempty(ab)
  ab = [ -1.0 , +1.0 ];
end



%% Algorithm

% Get interval boundaries
a = ab(1);
b = ab(2);

% Calculate Chebyshev extremas over arbitrary interval [a, b]
x = 0.5 * (a + b) + 0.5 * (b - a) .* cos( (0:n) .* (pi / n) );
% Set singular values to zero
x(issingular(x)) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
