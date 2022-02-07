function jR = quat2rotmjac(q)
%% QUAT2ROTMJAC Calculate Jacobian of rotation matrix wrt quaternions
%
% JR = quat2rotmjac(Q)
%
% Inputs:
%
%   Q                   4xN vector of quaternions.
%
% Outputs:
%
%   JR                  3x3x4xN array of rotation matrix Jacobians where the
%                       third dimension is the derivative with respect to the
%                       K-th quaternion.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-07
% Changelog:
%   2022-02-07
%       * Initial release as copy of `quat2rotmdiff`
% Todo:
%   * Change algorithm to directly build Jacobian based on quaternions rather
%   than the directors



%% Parse arguments

% QUAT2ROTMJAC(Q)
narginchk(1, 1)
% QUAT2ROTMJAC(Q)
% DMD = QUAT2ROTMJAC(Q)
% [D1D, D2D, D3D] = QUAT2ROTMJAC(Q)
nargoutchk(0, 3);

% Parse quaternions
qv = quatvalid(q, 'quat2rotmjac');



%% Algorithm

% Count quaternions for correct reshaping
nq = size(qv, 2);

% Reshape the quaternions in the depth dimension
qq = reshape(qv, [4, 1, 1, nq]);

% Access individual quaternion entries
q1 = qq(1,1,1,:);
q2 = qq(2,1,1,:);
q3 = qq(3,1,1,:);
q4 = qq(4,1,1,:);

% Deriative of first director R(:,1)
d1 = 2 * [ ...
   q1,  q2, -q3, -q4 ; ...
   q4,  q3,  q2,  q1 ; ...
  -q3,  q4, -q1,  q2 ; ...
];

% Deriative of second director R(:,2)
d2 = 2 * [ ...
  -q4,  q3,  q2, -q1 ; ...
   q1, -q2,  q3, -q4 ; ...
   q2,  q1,  q4,  q3 ; ...
];

% Deriative of third director R(:,3)
d3 = 2 * [ ...
   q3,  q4,  q1,  q2 ; ...
  -q2, -q1,  q4,  q3 ; ...
   q1, -q2, -q3,  q4 ; ...
];

% Build rotation matrix Jacobian
jR = permute(cat(3, d1, d2, d3), [1, 3, 2]);

% Vanish singular values
jR(issingular(jR)) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.

