function a = rotm2ang(R)%#codegen
%% ROTM2ANG Convert planar rotation matrix to angles
%
% A = ROTM2ANG(R) calculates the angular rotation for rotation matrices R.
%
% Inputs:
%
%   R                   2x2xN array of rotation matrices.
%
% Outputs:
%
%   A                   1xN array of angular positions.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-05-30
% Changelog:
%   2021-05-30
%       * Initial release



%% Parse arguments

% ROTM2ANG()
% ROTM2ANG(ROT)
narginchk(0, 1);
% ROTM2ANG(___)
% ROTM2ANG(___)
nargoutchk(0, 1);

% Quickly bail out for no argument 
if nargin < 1 || isempty(R)
  a = 0;
  
  return

end



%% Do your code magic here

% Switch pages and columns
rp = permute(R, [1, 3, 2]);

% Calculate angle using ATAN2
a = atan2(rp(2,:,1), rp(1,:,1));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
