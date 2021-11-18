function vec = skew2vec(skew)%#codegen
%% SKEW2VEC Convert skew-symmetric matrix into skew-symmetric vector
%
% VEC = SKEW2VEC(SKEW) converts skew-symmetric matrix S into its skew-symmetric
% vector form such.
%
% Inputs:
%
%   S                   3x3xN matrix of skew-symmetric matrices.
%
% Outputs:
%
%   V                   3xN array of skew-symmetric vectors.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-02
% Changelog:
%   2021-11-02
%       * Use mean value of skew-symmetric matrix to obtain mean off-diagonal
%       values
%   2020-11-25
%       * Change to return a 3xN array
%   2020-11-17
%       * Copy from my own personal MATLAB package to `functions` package
%       * Change author's email domain to `ls2n.fr`
%   2019-01-09
%       * Initial release



%% Validate arguments

narginchk(1, 1);
nargoutchk(0, 1);

validateattributes(skew, {'numeric'}, {'nonempty', '3d', 'nrows', 3, 'ncols', 3}, 'skew2vec', 's');



%% Process

% Number of vectors to create
nvec = size(skew, 3);

% Mean value to avoid for numerical issues in matrix's non-symmetry
skew = ( 0.5 * ones(3, 3, nvec) ) .* ( skew - permute(skew, [2, 1, 3]) );

% Shift into the right dimension
skew = permute(skew, [3, 1, 2]);

% Simple concatenation
vec = permute(reshape(cat(1, skew(:,3,2), skew(:,1,3), skew(:,2,1)), [nvec, 3]), [2, 1]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
