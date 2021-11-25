function D = chebdiffmtx(n, ab)
%% CHEBDIFFMTX Calculate the Chebyshev Differentiation Matrix
%
% D = CHEBDIFFMTX(N) calculates the Chebyshev differentiation matrix D for a
% Chebyshev polynomial of degree N on the unit interval [ -1.0 , + 1.0 ].
%
% D = CHEBDIFFMTX(N, AB) uses interval boundaries AB where AB is an increasing
% 2-element vector of an arbitrary interval. An affine transformation is applied
% to calculate the Chebyshev nodes of the shifted Chebyshev polynomial of degree
% N.
%
% Inputs:
%
%   N                   Polynomial degree of the discrete Chebyshev
%                       differentiation matrix D.
%
%   AB                  Interval for which to determine the Chebyshev nodes.
%                       Default: [-1, 1];
%
% Outputs:
%
%   D                   Sparse (N+1)x(N+1) Chebyshev differentiation matrix.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-23
% Changelog:
%   2021-11-23
%       * Make `D` matrix sparse
%   2021-11-19
%       * Initial release



%% Parse arguments

% CHEBDIFFMTX(N)
% CHEBDIFFMTX(N, AB)
narginchk(1, 2);
% CHEBDIFFMTX(___)
% D = CHEBDIFFMTX(___)
nargoutchk(0, 1);

% Default interval boundary
if nargin < 2 || isempty(ab)
  ab = [ -1.0 , +1.0 ];
end



%% Algorithm

% Get Chebyshev-Lobatto points for the given degree
x = transpose(chebpts2(n, ab));

% Row index
r = transpose(0:n);

% Coefficients for every row
c = [ ...
  2 ; ...
  ones(n - 1, 1) ; ...
  2 ; ...
] .* (-1) .^ r;

% Repeat nodes for all columns
X = repmat(x, 1, n + 1);

% Calculate total differentiation matrix
D = ( c * transpose(1 ./ c) ) ./ ( ( X - transpose(X) ) + eye(n + 1, n + 1));

% Sum over the columns and diagonalize, to remove diagonal offsets in
% differentiation matrix
D = sparse(D - diag(sum(D, 2)));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
