function varargout = quat2dirndiff(q)
%% QUAT2DIRNDIFF Calculate director derivative matrix for a given quaternion
%
% DMD = quat2dirndiff(Q)
%
% [D1D, D2D, D3D] = quat2dirndiff(Q)
%
% Inputs:
%
%   Q                   4xN vector of quaternions.
%
% Outputs:
%
%   DMD                 3x4x3xN array of directors where the third dimension
%                       represents the respective director.
%
%   D1                  3x4xN array of derivatives of the first director.
%
%   D2                  3x4xN array of derivatives of the second director.
%
%   D3                  3x4xN array of derivatives of the third director.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-01
% Changelog:
%   2020-12-01
%       * Initial release



%% Parse arguments

% QUAT2DIRNDIFF(Q)
narginchk(1, 1)
% QUAT2DIRNDIFF(Q)
% DMD = QUAT2DIRNDIFF(Q)
% [D1D, D2D, D3D] = QUAT2DIRNDIFF(Q)
nargoutchk(0, 3);

% Parse quaternions
qv = quatvalid(q, 'quat2dirndiff');



%% Do your code magic here

nq = size(qv, 2);

% Reshape the quaternions in the depth dimension
qq = reshape(qv, [4, 1, 1, nq]);

% Access individual quaternion entries
q1 = qq(1,1,1,:);
q2 = qq(2,1,1,:);
q3 = qq(3,1,1,:);
q4 = qq(4,1,1,:);

d1 = 2 * [ ...
   q1,  q2, -q3, -q4 ; ...
   q4,  q3,  q2,  q1 ; ...
  -q3,  q4, -q1,  q2 ; ...
];

d2 = 2 * [ ...
  -q4,  q3,  q2, -q1 ; ...
   q1, -q2,  q3, -q4 ; ...
   q2,  q1,  q4,  q3 ; ...
];

d3 = 2 * [ ...
   q3,  q4,  q1,  q2 ; ...
  -q2, -q1,  q4,  q3 ; ...
   q1, -q2, -q3,  q4 ; ...
];

dmd = cat(3, d1, d2, d3);

% Vanish singular values
dmd(issingular(dmd)) = 0;

% [D1D, D2D, D3D] = QUAT2DIRNDIFF(Q)
if nargout > 1
  dmd = permute(dmd, [1, 2, 4, 3]);
  varargout{1} = dmd(:,:,:,1);
  varargout{2} = dmd(:,:,:,2);
  varargout{3} = dmd(:,:,:,3);
% QUAT2DIRNDIFF(Q)
% DMD = QUAT2DIRNDIFF(Q)
else
  varargout{1} = dmd;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
