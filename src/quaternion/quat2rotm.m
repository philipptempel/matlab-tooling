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
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Use new syntax of `quatvalid` also returning number of quaternions N
%   2022-02-07
%     * Change code back from Euler-Rodrigues formula to explicit formula so
%     that it is compatible with `QUAT2ROTMJAC`
%   2021-10-21
%     * Make Euler-Rodrigues formula codegen-compatible
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

% Parse quaternions
[qv, nq] = quatvalid(q, 'quat2rotm');



%% Algorithm

% Reshape the quaternions in the depth dimension
qq = reshape(qv, [4, 1, nq]);

% Access individual quaternion entries
q1 = qq(1,1,:);
q2 = qq(2,1,:);
q3 = qq(3,1,:);
q4 = qq(4,1,:);

% Pre-calculate common products
q1q1 = q1 .^ 2;
q2q2 = q2 .^ 2;
q3q3 = q3 .^ 2;
q4q4 = q4 .^ 2;
q1q2 = q1 .* q2;
q1q3 = q1 .* q3;
q2q3 = q2 .* q3;
q1q4 = q1 .* q4;
q2q4 = q2 .* q4;
q3q4 = q3 .* q4;

% Explicitly define concatenation dimension for codegen
tempR = cat(1 ...
  , q1q1 + q2q2 - q3q3 - q4q4,  2 * ( q2q3 - q1q4 ),       2 * ( q2q4 + q1q3 )...
  , 2 * ( q2q3 + q1q4 ),       q1q1 - q2q2 + q3q3 - q4q4,  2 * ( q3q4 - q1q2 ) ...
  , 2 * ( q2q4 - q1q3 ),       2 * ( q3q4 + q1q2 ),       q1q1 - q2q2 - q3q3 + q4q4...
);
% Original code before speed up optimization
% tempR = cat(1 ...
%   , 1 - 2*(q3.^2 + q4.^2),  2*(q2*q3 - q1*q4),    2*(q2*q4 + q1*q3) ...
%   , 2*(q2*q3 + q1*q4),    1 - 2*(q2.^2 + q4.^2),  2*(q3*q4 - q1*q2) ...
%   , 2*(q2*q4 - q1*q3),    2*(q3*q4 + q1*q2),    1 - 2*(q2.^2 + q3.^2) ...
% );

% Reshape to 3x3xN and then transpose each page  (due to MATLAB's column major)
R = permute(reshape(tempR, [3, 3, nq]), [2, 1, 3]);

% Vanish singular values
singular = abs(R) < 10 * eps(class(qv)) & R ~= 0;
R(singular) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
