function q = rotm2quat(R)%#codegen
%% ROTM2QUAT Convert rotation matrix/matrices to quaternion(s)
%
% Inputs:
%
%   R                   3x3xN rotation matrix.
%
% Outputs:
%
%   Q                   4xN vector of quaternions



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Syntax updates
%   2020-11-11
%     * Initial release



%% Parse arguments

% ROTM2QUAT(R)
narginchk(1, 1);

% ROTM2QUAT(R)
% Q = ROTM2QUAT(R);
nargoutchk(0, 1);

validateattributes(R, {'numeric'}, {'nonempty', 'real', '3d', 'size', [3, 3, NaN], 'finite', 'nonnan', 'nonsparse', '<=', +1 + 100 * eps(class(R)), '>=', -1 - 100 * eps(class(R))}, 'rotm2quat', 'R');



%% Algorithm

% Count number of rotation matrices equal the number of resulting quaternions
nq = size(R, 3);

% Initialize quaternions
q = zeros(4, nq);

% Calculate all elements of symmetric K matrix
K11 = R(1,1,:) - R(2,2,:) - R(3,3,:);
K12 = R(1,2,:) + R(2,1,:);
K13 = R(1,3,:) + R(3,1,:);
K14 = R(3,2,:) - R(2,3,:);

K22 = R(2,2,:) - R(1,1,:) - R(3,3,:);
K23 = R(2,3,:) + R(3,2,:);
K24 = R(1,3,:) - R(3,1,:);

K33 = R(3,3,:) - R(1,1,:) - R(2,2,:);
K34 = R(2,1,:) - R(1,2,:);

K44 = R(1,1,:) + R(2,2,:) + R(3,3,:);

% Construct K matrix according to paper
K = [...
    K11,    K12,    K13,    K14;
    K12,    K22,    K23,    K24;
    K13,    K23,    K33,    K34;
    K14,    K24,    K34,    K44];

K = K ./ 3;

% For each input rotation matrix, calculate the corresponding eigenvalues and
% eigenvectors. The eigenvector corresponding to the largest eigenvalue is the
% unit quaternion representing the same rotation.
for iq = 1:nq
    [eigVec, eigVal] = eig(K(:,:,iq), 'vector');
    
    [~, maxIdx] = max(real(eigVal));
    
    q(:,iq) = real([eigVec(4, maxIdx), eigVec(1, maxIdx), eigVec(2, maxIdx), eigVec(3, maxIdx)]);
    
    % By convention, always keep scalar quaternion element positive. Note that
    % this does not change the rotation that is represented by the unit
    % quaternion, since q and -q denote the same rotation.
    if q(1,iq) < 0
        q(:,iq) = -q(:,iq);
    end
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
