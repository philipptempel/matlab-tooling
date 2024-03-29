function q = quatrand(n)%#codegen
%% QUATRAND Create a set of random quaternions
%
% QUATRAD() creates one random quaternion.
%
% QUATRAD(N) creates N random quaternions.
%
% Inputs:
%
%   N                   Number of random quaternions to create.
%
% Outputs:
%
%   Q                   4xN array of N quaternions. Each quaternion represents
%                       a 3D rotation in form q = [w, x, y, z], with the scalar
%                       given as the first value w.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-10
% Changelog:
%   2022-03-10
%     * Update H1 documentation clarifying format of output quaternions Q
%   2022-02-13
%     * Enforce quaternion scalar components positive.
%   2022-02-08
%     * Add `codegen` directive
%     * Remove validation of argument `N`
%   2020-11-19
%     * Use `quatnormalized` instead of `quatnorm`
%   2020-11-15
%     * Initial release



%% Parse arguments

% QUATRAND()
% QUATRAND(N)
narginchk(0, 1);
% QUATRAND(...)
% Q = QUATRAND(...)
nargoutchk(0, 1);

% QUATRAND()
if nargin < 1 || isempty(n)
  n = 1;
end



%% Create random quaternions

% We will first create random vectors in the range from [-1, 1] and then
% normalize all these
q = quatnormalized(2 * (rand(4, n) - 0.5));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
