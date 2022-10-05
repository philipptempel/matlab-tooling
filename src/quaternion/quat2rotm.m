function R = quat2rotm(q)%#codegen
%% QUAT2ROTM Convert Quaternion to rotation matrix
%
% R = QUAT2ROTM(Q) converts quaternion Q to rotation matrix R.
%
% Inputs:
%
%   Q                       4xN array of unit quaternions with the first element
%                           being the scalar/real part
%
% Outputs:
%
%   R                       3x3xN array of orthonormal rotation matrices.
%
% See also
%     ROTM2QUAT



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-05
% Changelog:
%   2022-10-05
%     * Initial release



%% Parse arguments

% QUAT2ROTM(Q)
narginchk(1, 1);

% QUAT2ROTM(___)
% R = QUAT2ROTM(___)
nargoutchk(0, 1);



%% Algorithm

% Normalize quaternions
q = quatnormalized(q);

% Number of quaternions
nq = size(q, 2);

% Reshape the quaternions in the depth dimension
qp = reshape(q, [4, 1, nq]);

% Get parts
w = qp(1,1,:);
x = qp(2,1,:);
y = qp(3,1,:);
z = qp(4,1,:);

% Explicitly define concatenation dimension for codegen
tempR = cat( ...
    1 ...
  , 1 - 2 .* ( y .^ 2 + z .^ 2 ),     2 .* ( x .* y - w .* z ),     2 .* ( x .* z + w .* y ) ...
  ,     2 .* ( x .* y + w .* z ), 1 - 2 .* ( x .^ 2 + z .^ 2 ),     2 .* ( y .* z - w .* x ) ...
  ,     2 .* ( x .* z - w .* y ),     2 .* ( y .* z + w .* x ), 1 - 2 .* ( x .^ 2 + y .^ 2 )  ...
);

% Reshape to 3x3xN and then transpose each page  (due to MATLAB's column major)
R = permute(reshape(tempR, [3, 3, nq]), [2, 1, 3]);

% Vanish singular values
R(issingular(R, 10 * eps(class(q)))) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
