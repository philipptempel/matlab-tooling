function R = roty(ang)%#codegen
%% ROTY Create rotation matrix from rotation about Y-Axis
%
% Inputs:
%
%   ANG                 Nx1 array of radian angles to create rotation matrices
%                       for.
%
% Outputs:
%
%   R                   3x3xN matrix of rotation matrices per angle.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-19
% Changelog:
%   2020-12-19
%       * Remove dependency on `rot` and make standalone functio
%   2020-11-15
%       * Initial release



%% Parse arguments

% ROTY(ANG)
narginchk(1, 1);
% ROTY(ANG)
% R = ROTY(ANG)
nargoutchk(0, 1);



%% Create rotation matrix

% Number of angles
nang = numel(ang);

% Turn the vector into a 3d matrix
ang = reshape(ang, [1, 1, nang]);

% Pre-calculate sine and cosines
sa = sin(ang);
ca = cos(ang);
z = zeros(1, 1, nang);
o = ones(1, 1, nang);

% Different rotation matrices
tempR = cat(2 ...
  ,  ca, z, -sa ...
  ,   z, o,   z ...
  ,  sa, z,  ca ...
);

% Turn our current 1x9xNA array into a 3x3xNA array
R = reshape(tempR, [3, 3, nang]);

% Vanish singular values
R(issingular(R)) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
