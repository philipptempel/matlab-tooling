function q = quatzeros(n)%#codegen
%% QUATZEROS Create an array of zero-quaternions
%
% Q = QUATZEROS() creates one zero quaternion i.e., a quaternion that does not
% create a rotation as [ 1 ; 0 ; 0 ; 0 ]
%
% Q = QUATZEROS(N) creates N such zero quaternions.
%
% Outputs:
%
%   Q                   4xN zero quaternion(s) where each column reads
%                       Q(:,i) = [ 1.0 ; 0.0 ; 0.0 ; 0.0 ].



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-05
% Changelog:
%   2022-10-05
%     * Initial release



%% Parse arguments

% QUATZEROS()
% QUATZEROS(N)
narginchk(0, 1);

% QUATZEROS()
% Q = QUATZEROS()
nargoutchk(0, 1);

% QUATZEROS()
if nargin < 1 || isempty(n)
  n = 1;
end



%% Algorithm

q = repmat([ 1.0 ; 0.0 ; 0.0 ; 0.0 ], 1, fix(abs(n)));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
