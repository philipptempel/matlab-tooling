function R = ang2rotm(a)%#codegen
%% ANG2ROTM
%
% R = ANG2ROTM(A) calculates the rotation matrix for angular positions A.
%
% Inputs:
%
%   A                   1xN array of angular positions.
%
% Outputs:
%
%   R                   2x2xN array of rotation matrices.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-04-21
% Changelog:
%   2021-04-21
%       * Update code to use `cat` and `reshape` (should be faster now)
%   2021-02-04
%       * Initial release



%% Parse arguments

% ANG2ROTM()
% ANG2ROTM(ANG)
narginchk(0, 1);
% ANG2ROTM(...)
% R = ANG2ROTM(...)
nargoutchk(0, 1);

% Quickly bail out for no argument 
if nargin < 1 || isempty(a)
  R = eye(2);
  
  return

end



%% Create rotation matrix

% Count of angles
na = numel(a);

% Turn angles into 3D array
ap = reshape(a, [1, 1, na]);

% Pre-calculate the sine and cosine of the arguments
st = sin(ap);
ct = cos(ap);

% Concate components with row major
tempR = cat(1, ct, st, -st, ct);

% And reshape into 2x2xN
R = reshape(tempR, [2, 2, na]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
