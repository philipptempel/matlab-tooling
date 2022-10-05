function q = quatones(n)%#codegen
%% QUATONES Create array of one-quaternions
%
% Q = QUATONES() creates one one-quaternion i.e., a quaternion of 1 unit of
% rotation (pi) about the normalized axis of [ 1 ; 1 ; 1 ].
%
% Q = QUATONES(N) creates N such unit quaternions.
%
% Outputs:
%
%   Q                   4xN unit quaternion(s) where each column reads
%                       Q(:,i) = [ 0.0 ; 1/sqrt(3) ; 1/sqrt(3) ; 1/sqrt(3) ].



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Inliune code fixes
%   2021-12-06
%       * Update H1 documentation
%       * Add parameter N
%   2020-11-12
%       * Initial release



%% Parse arguments

% QUATONES()
% QUATONES(N)
narginchk(0, 1);

% QUATONES()
% Q = QUATONES()
nargoutchk(0, 1);

% QUATONES()
if nargin < 1 || isempty(n)
  n = 1;
end



%% Algorithm

s = sqrt(1 / 3);

q = repmat([ 0.0 ; s ; s ; s ], 1, fix(abs(n)));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
