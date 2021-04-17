function varargout = quat2dirn(q)
%% QUAT2DIRN Turn quaternion into directors
%
% DM = QUAT2DIRN(Q)
%
% [D1, D2, D3] = QUAT2DIRN(Q)
%
% Inputs:
%
%   Q                   4xN vector of quaternions.
%
% Outputs:
%
%   DM                  3x3xN array of directors where the second dimension is
%                       the respective director.
%
%   D1                  3xN array representing the first directors (per column).
%
%   D2                  3xN array representing the second directors (per
%                       column).
%
%   D3                  3xN array representing the third directors (per column).



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-01
% Changelog:
%   2020-12-01
%       * Initial release



%% Parse arguments

% QUAT2DIRN(Q)
narginchk(1, 1)
% QUAT2DIRN(Q)
% DM = QUAT2DIRN(Q)
% [D1, D2, D3] = QUAT2DIRN(Q)
nargoutchk(0, 3);

% Parse quaternions
qv = quatvalid(q, 'quat2dirn');



%% Calculate directors

nq = size(qv, 2);

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

% Reshape to 3x3xN and then transpose each page  (due to MATLAB's column major)
dm = permute(reshape(tempR, [3, 3, nq]), [2, 1, 3]);

% Vanish singular values
singular = abs(dm) < 10 * eps(class(qv)) & dm ~= 0;
dm(singular) = 0;

% [D1, D2, D3] = QUAT2DIRN(Q)
if nargout > 1
  dm = permute(dm, [1, 3, 2]);
  varargout{1} = dm(:,:,1);
  varargout{2} = dm(:,:,2);
  varargout{3} = dm(:,:,3);
% QUAT2DIRN(Q)
% DM = QUAT2DIRN(Q)
else
  varargout{1} = dm;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
