function varargout = quat2dirn(q)%#codegen
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
% Date: 2022-02-07
% Changelog:
%   2022-02-07
%       * Add `codegen` directive
%       * Simplify code and use `QUAT2ROTM` internally to calculate the rotation
%       matrix, then populate outputs from that
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



%% Algorithm

% Calculate rotation matrix from quaternion(s)
R = quat2rotm(qv);

% [D1, D2, D3] = QUAT2DIRN(___)
if nargout > 1
  R = permute(R, [1, 3, 2]);
  varargout = { R(:,:,1) , R(:,:,2) , R(:,:,3) };

% DM = QUAT2DIRN(___)
else
  varargout = {R};

end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
