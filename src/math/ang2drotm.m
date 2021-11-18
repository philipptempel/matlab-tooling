function dR = ang2drotm(a, da)%#codegen
%% ANG2DROTM Calculate change of rotation matrix
%
% DR = ANG2DROTM(A) calculates the derivative of the rotation matrix for angular
% position(s) A.
%
% DR = ANG2DROTM(A, DA) calculates the rotational velocity of the rotation
% matrix for angular velocities DA.
%
% Inputs:
%
%   A                   Nx1 array of angular positions.
%
%   DA                  Nx1 array of angular velocities.
%
% Outputs:
%
%   R                   2x2xN array of derivatives of rotation matrices.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-05-03
% Changelog:
%   2021-05-03
%       * Fix wrong default value if no angular position is given.
%       * Fix wrong function name in inline comments
%   2021-04-21
%       * Fix bug in calculation of rotation matrix derivative
%       * Update code to use `cat` and `reshape` (should be faster now)
%       * Add default value for `DA` allowing to calculate only the derivative
%       of the rotation matrix
%   2021-02-04
%       * Initial release



%% Parse arguments

% ANG2DROTM()
% ANG2DROTM(A)
% ANG2DROTM(A, DA)
narginchk(0, 2);
% ANG2DROTM(...)
% R = ANG2DROTM(...)
nargoutchk(0, 1);

% Quickly bail out for no argument 
if nargin < 1 || isempty(a)
  dR = zeros(2);
  
  return

end

% No angular rate given => just calculate the rotation matrices
if nargin < 2 || isempty(da)
  da = ones(size(a), 'like', a);
end



%% Create rotation matrix

% Count angular values
na = numel(a);

% Turn angles into 3D array
ap = reshape(a, [1, 1, na]);
dap = repmat(reshape(da, [1, 1, na]), [2, 2, 1]);

% Pre-calculate the sine and cosine of the arguments
st = sin(ap);
ct = cos(ap);

% Concate components with row major
tempR = cat(1, -st, ct, -ct, -st);

% And reshape into 2x2xN, then multiply each page with the angular velocity
dR = reshape(tempR, 2, 2, na) .* dap;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
