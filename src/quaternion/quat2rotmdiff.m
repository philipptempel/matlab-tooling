function dR = quat2rotmdiff(q, dq)%#codegen
%% QUAT2ROTMDIFF Calculate rotation matrix derivative
%
% DR = QUAT2ROTMDIFF(Q, DQ)
%
% Inputs:
%
%   Q                   4xN vector of quaternions.
%
%   DQ                  4xN vector of quaternion rates.
%
% Outputs:
%
%   DR                  3x3xN matrix of derivatives of rotation matrix with
%                       respect to quaternion and quaternion rates.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-24
% Changelog:
%   2020-11-24
%       * Initial release



%% Parse arguments

% QUAT2ROTMDIFF(Q)
% QUAT2ROTMDIFF(Q, DQ)
narginchk(1, 2)
% QUAT2ROTMDIFF(Q, DQ)
% DR = QUAT2ROTMDIFF(Q, DQ)
nargoutchk(0, 1);

% Default quaternion rate: ones so that `quat2rotmdiff(q)` returns the 3x4x3
% matrix of director derivatives
if nargin < 2 || isempty(dq)
  dq = ones(4, 1);
end

% Parse quaternions
qv = quatvalid(q, 'quat2rotmdiff');
dqv = quatvalid(dq, 'quat2rotmdiff');



%% Determine rotation matrix derivative

% How many quaterions
nq = size(qv, 2);

% Reshape the quaternions in the depth dimension
qq = reshape(qv, [4, 1, nq]);
dqv = repmat(permute(dqv, [3, 1, 2]), [9, 1, 1]);

% Access individual quaternion entries
q1 = qq(1,1,:);
q2 = qq(2,1,:);
q3 = qq(3,1,:);
q4 = qq(4,1,:);

% First director's derivative wrt Q
% d d_1 / d q
tempD = 2 * cat(1 ...
  ,  q1,  q2, -q3, -q4 ...
  ,  q4,  q3,  q2,  q1 ...
  , -q3,  q4, -q1,  q2 ...
);
D1 = permute(reshape(tempD, [4, 3, nq]), [2, 1, 3]);

% Second director's derivative wrt Q
% d d_2 / d q
tempD = 2 * cat(1 ...
  , -q4,  q3,  q2, -q1 ...
  ,  q1, -q2,  q3, -q4 ...
  ,  q2,  q1,  q4,  q3 ...
);
D2 = permute(reshape(tempD, [4, 3, nq]), [2, 1, 3]);

% Third director's derivative wrt Q
% d d_3 / d q
tempD = 2 * cat(1 ...
  ,  q3,  q4,  q1,  q2 ...
  , -q2, -q1,  q4,  q3 ...
  ,  q1, -q2, -q3,  q4 ...
);
D3 = permute(reshape(tempD, [4, 3, nq]), [2, 1, 3]);

% Build rotation matrix derivative
tempDr = sum(cat(1 ...
  , D1, D2, D3 ...
) .* dqv, 2);

% Reshape to 3x3xN and then transpose each page (due to MATLAB's column major)
dR = reshape(tempDr, [3, 3, nq]);

% Vanish singular values
singular = abs(dR) < 10 * eps(class(qv)) & dR ~= 0;
dR(singular) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
