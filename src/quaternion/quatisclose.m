function f = quatisclose(g, c, atol, rtol)
%% QUATISCLOSE Check if two quaternions are close to each other
%
% F = QUATISCLOSE(G, C) checks if candidate quaternion(s) C are close to ground
% truth quaternion G.
%
% F = QUATISCLOSE(G, C, ATOL) uses absolute tolerance ATOL in comparison of
% quaternions.
%
% F = QUATISCLOSE(G, C, ATOL, RTOL) uses relative tolerance RTOL in comparison
% of quaternions.
%
% Inputs:
%
%   G                   4x1 array of ground truth quaternion.
% 
%   C                   4xN array of candidate values.
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
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%       * Initial release



%% Parse arguments

% QUATISCLOSE(G, C)
% QUATISCLOSE(G, C, ATOL)
% QUATISCLOSE(G, C, ATOL, RTOL)
narginchk(2, 4);

% QUATISCLOSE(___)
% F = QUATISCLOSE(___)
nargoutchk(0, 1);

% QUATISCLOSE(G, C, ATOL)
if nargin < 3
  atol = [];
end

% QUATISCLOSE(G, C, ATOL, RTOL)
if nargin < 4
  rtol = [];
end

% Parse quaternions
gv = quatvalid(g, 'quatisclose');
[cv, nc] = quatvalid(c, 'quatisclose');



%% Algorithm

% Check if the angle of rotation between the ground truth and the candidate
% quaternions is close to 0 (zero)
f = isclose(0, acos(2 .* dot(repmat(gv, 1, nc), cv, 1) .^ 2 - ones(1, nc)), atol, rtol);



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.

