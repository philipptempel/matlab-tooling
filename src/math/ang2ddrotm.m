function ddR = ang2ddrotm(a, da, dda)%#codegen
%% ANG2DDROTM Calculate change of rotation matrix
%
% DR = ANG2DDROTM(A) calculates a planar/2D rotation matrix's second derivative
% for angular positions A given in radians.
%
% DR = ANG2DDROTM(___, DA) uses, in addition, angular velocities DA for
% calculation of rotation matrix's second derivative.
%
% DR = ANG2DDROTM(___, DDA) uses in addition, angular accelerations DDA for
% calculation of rotation matrix's second derivative.
%
% Inputs:
%
%   A                   1xN array of angular positions.
%
%   DA                  1xN array of angular velocities. Defaults to 1.
%
%   DDA                 1xN array of angular accelerations. Defaults to 0.
%
% Outputs:
%
%   R                   2x2xN array of second derivatives of rotation matrices.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-06-21
% Changelog:
%   2021-06-21
%       * Change default value for `DDA` to be all zeros so that a call to
%       `ANG2DDROTM(A)` returns only the second derivative of planar rotation
%       matrix R wrt the rotation parametrization evaluated at A.
%       * Add H1 documentation for defaults of `DA` and `DDA`
%   2021-05-03
%       * Initial release



%% Parse arguments

% ANG2DDROTM()
% ANG2DDROTM(A)
% ANG2DDROTM(A, DA)
% ANG2DDROTM(A, DA, DDA)
narginchk(0, 3);
% ANG2DDROTM(...)
% R = ANG2DDROTM(...)
nargoutchk(0, 1);

% Quickly bail out for no argument 
if nargin < 1 || isempty(a)
  ddR = zeros(2);
  
  return

end

% No angular rate given => just calculate the rotation matrices
if nargin < 2 || isempty(da)
  da = 1;
end
if numel(da) == 1
  da = da .* ones(size(a), 'like', a);
end

% No angular rate given => just calculate the rotation matrices
if nargin < 3 || isempty(dda)
  dda = 0;
end
if numel(dda) == 1
  dda = dda .* zeros(size(a), 'like', a);
end



%% Create rotation matrix

% Obtain first and second partial derivative of the rotation matrix
dD = ang2drotm(a);
ddD = ang2rotm(a);

% Count angular values
na = numel(a);

% Turn angles into 3D array
dap = reshape(da, [1, 1, na]);
ddap = reshape(dda, [1, 1, na]);

% Simple math
ddR = -ddD .* dap .* dap + dD .* ddap;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
