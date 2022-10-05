function f = quatisclose(c, g, atol, rtol)%#codegen
%% QUATISCLOSE Check if two quaternions are close to each other
%
% F = QUATISCLOSE(C, G) checks if candidate quaternion(s) C are close to ground
% truth quaternion G.
%
% F = QUATISCLOSE(C, G, ATOL) uses absolute tolerance ATOL in comparison of
% quaternions.
%
% F = QUATISCLOSE(C, G, ATOL, RTOL) uses relative tolerance RTOL in comparison
% of quaternions.
%
% Inputs:
%
%   C                   4xN array of candidate values.
%
%   G                   4x1 array of ground truth quaternion.
% 
%   ATOL                Absolute tolerance in comparing values. Defaults to
%                       `1e4 * eps(class(G))`.
%
%   RTOL                Relative tolerance in comparing values. Defaults to
%                       `1e-8`.
%
% Outputs:
%
%   F                   1xN array of flags which quaternions are close to each
%                       other.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-03
% Changelog:
%   2022-03-03
%     * Change order of arguments from `GROUND, CANDIDATE` to `CANDIDATE,
%       GROUND`
%   2022-02-08
%     * Initial release



%% Parse arguments

% QUATISCLOSE(C, G)
% QUATISCLOSE(C, G, ATOL)
% QUATISCLOSE(C, G, ATOL, RTOL)
narginchk(2, 4);

% QUATISCLOSE(___)
% F = QUATISCLOSE(___)
nargoutchk(0, 1);

% QUATISCLOSE(C, G, ATOL)
if nargin < 3
  atol = [];
end

% QUATISCLOSE(C, G, ATOL, RTOL)
if nargin < 4
  rtol = [];
end



%% Algorithm

nc = size(c, 2);

% Check if the angle of rotation between the ground truth and the candidate
% quaternions is close to 0 (zero)
f = isclose(0, acos(2 .* dot(repmat(g, 1, nc), c, 1) .^ 2 - ones(1, nc)), atol, rtol);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.

