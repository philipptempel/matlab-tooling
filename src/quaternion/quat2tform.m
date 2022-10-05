function T = quat2tform(q)%#codegen
%% QUAT2TFORM Convert quaternion to homogeneous transformation
%
% T = QUAT2TFORM(Q) converts Quaternion(s) Q into homogeneous transformation
% matrices T.
%
% Inputs:
%
%   Q                       4xN array of unit quaternions with the first element
%                           being the scalar/real part
%
% Outputs:
%
%   T                       4x4xN array of homogeneous transformations.
%
% See also:
%   TFORM2QUAT



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-05
% Changelog:
%   2022-10-05
%     * Initial release



%% Parse arguments

% QUAT2TFORM(Q)
narginchk(1, 1);

% QUAT2TFORM(___)
% T =QUAT2TFORM(___)
nargoutchk(0, 1);



%% Algorithm

% This becomes very simple
T = rotm2tform(quat2rotm(q));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
