function R = quat2rotm(q)%#codegen
%% QUAT2ROTM converts quaternions to rotation matrices
%
% R = QUAT2ROTM(Q) converts a unit quaternion, Q, into an orthonormal rotation
% matrix, R. The input, Q, is an N-by-4 matrix containing N quaternions. Each
% quaternion represents a 3D rotation and is of the form q = [w, x, y, z], with
% scalar number w as the first value. Each element of Q must be a real number.
% The output, R, is an 3-by-3-by-N matrix containing N rotation matrices.
%
% Inputs:
%
%   Q                   4xN matrix of N quaternions. Each quaternion represents
%                       a 3D rotation in form q = [w, x, y, z], with the scalar
%                       given as the first value w.
%
% Outputs:
%
%   R                   3x3xN matrix containing N rotation matrices



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-10-07
% Changelog:
%   2021-10-07
%     * Change algorithm to use Euler-Rodrigues formula for calculation of
%     rotation matrix
%   2020-11-24
%     * Rename variables `s`, `x`, `y`, `z` to `q1`, `q2`, `q3`, `q4`
%     * Speed up code by pre-calculating common products
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-10
%     * Revert change "Change to support scalar value as last entry"
%   2020-11-09
%     * Copy from my own MATLAB functions
%     * Change to support scalar value as last entry
%   2019-01-18
%     * Add support for passing symbolic variables, too
%   2017-04-14
%     * Change assertion from ```assert``` to ```validateattributes```
%   2016-10-23
%     * Initial release



%% Assert arguments

% QUAT2ROTM(Q)
narginchk(1, 1);

% QUAT2ROTM(Q)
% R = QUAT2ROTM(Q)
nargoutchk(0, 1);

qv = quatvalid(q, 'quat2rotm');



%% Calculate rotation matrix

nq = size(qv, 2);

% Reshape the quaternions in the depth dimension
qq = reshape(qv, [4, 1, nq]);

% Access individual quaternion entries
qs = qq(1,1,:);
qv = qq([2,3,4],1,:);

% Angle of rotation of each quaternion
theta = 2 * acos(qs);

% Non-zero rotations
nonzero_theta = ~isclose(theta, 0);

% Calculate axis of rotation of each quaternion
omega = zeros(3, nq);
omega(:,nonzero_theta) = qv(:,:,nonzero_theta) ./ (sin(theta(:,:,nonzero_theta) / 2));

% Build skew-symmetric matrix of each rotation axis
omega_hat = vec2skew(omega);

% Build rotation matrices based on Euler-Rodgrigues formula
R = repmat(eye(3, 3), 1, 1, nq) + ...
  + omega_hat .* sin(theta) + ...
  + pagemtimes( ...
    pagemtimes(omega_hat, omega_hat) ...
    , 1 - cos(theta) ...
  );

% Vanish singular values
singular = abs(R) < 10 * eps(class(qv)) & R ~= 0;
R(singular) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
