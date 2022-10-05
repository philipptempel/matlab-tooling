function q = quatrandn(n)%#codegen
%% QUATRANDN Create normally distributed random quaternions
%
% QUATRANDN() creates 1 normally distributed random quaternion.
%
% QUATRANDN(N) creates N normally distributed random quaternions.
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
% Date: 2022-10-05
% Changelog:
%   2022-10-05
%     * Initial release



%% Parse arguments

% QUATRANDN()
% QUATRANDN(N)
narginchk(0, 1);
% QUATRANDN(...)
% Q = QUATRANDN(...)
nargoutchk(0, 1);

% QUATRANDN()
if nargin < 1 || isempty(n)
  n = 1;
end



%% Create random quaternions

% We will first create random vectors in the range from [-1, 1] and then
% normalize all these
q = quatnormalized(2 * (randn(4, n) - 0.5));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
