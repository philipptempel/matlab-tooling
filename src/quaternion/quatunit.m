function q = quatunit(n)%#codegen
%% QUATUNIT Create a unit quaternion
%
% Q = QUATUNIT() creates one unit quaternion.
%
% Q = QUATUNIT(N) creates N unit quaternions.
%
% Outputs:
%
%   Q                   4xN unit quaternion(s) where each column reads
%                       Q(:,i) = [ 1.0 , 0.0 , 0.0 , 0.0 ].



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

% QUATUNIT()
% QUATUNIT(N)
narginchk(0, 1);

% QUATUNIT()
% Q = QUATUNIT()
nargoutchk(0, 1);

% QUATUNIT()
if nargin < 1 || isempty(n)
  n = 1;
end



%% Algorithm

q = repmat([ 1.0 ; 0.0 ; 0.0 ; 0.0 ], 1, n);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
