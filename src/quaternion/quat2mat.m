function Qm = quat2mat(q)%#codegen
%% QUAT2MAT Calculate quaternion matrix
%
% QM = QUAT2MAT(Q) calculates the so-called quaternion matrix QM for quaternion
% Q.
%
% Inputs:
%
%   Q                       4xN quaternion(s) with scalar element in first row.
%
% Outputs:
%
%   QM                      4x4xN quaternion matrix.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-05
% Changelog:
%   2022-10-05
%     * Initial release



%% Parse arguments

% QUAT2MAT(Q);
narginchk(1, 1);

% QUAT2MAT(Q)
% QM = QUAT2MAT(Q);
nargoutchk(0, 1);



%% Algorithm

nd = size(q, 2);
d = permute(q, [1, 3, 2]);
s = d(1,:,:);
x = d(2,:,:);
y = d(3,:,:);
z = d(4,:,:);

tempM = cat( ....
  1 ...
  , +s, -x, -y, -z ...
  , +x, +s, -z, +y ...
  , +y, +z, +s, -x ...
  , +z, -y, +x, +s ...
);

Qm = permute(reshape(tempM, 4, 4, nd), [2, 1, 3]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
