function axang = quat2axang(q)%#codegen
%% QUAT2AXANG Convert quaternion to axis-angle rotation representation
%
% AXANG = QUAT2AXANG(Q) converts quaternion into an equivalent axis-angle
% representation.
%
% Inputs:
%
%   Q                       4xN array of unit quaternions with the first element
%                           being the scalar/real part
%
% Outputs:
%
%   AXANG                   4xN array of axis angles where the first three
%                           elements are the axis of rotation and the last
%                           element defines the amount of rotation (in radians).
%
% See also:
%   AXANG2QUAT



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-05
% Changelog:
%   2022-10-05
%     * Initial release



%% Parse arguments

% QUAT2AXANG(Q)
narginchk(1, 1);

% QUAT2AXANG(___)
% AXANG = QUAT2AXANG(___)
nargoutchk(0, 1);



%% Algorithm

% Normalize quaternions
q = quatnormalized(q);

% Normalize and generate the rotation vector and angle sequence
% For a single quaternion q = [w ; x ; y ; z], the formulas are as follows:
% (axis) v = [x ; y ; z] / norm([x ; y ; z]);
% (angle) theta = 2 * acos(w)
v  = mnormcol(q(2:4,:));
th = wraptopi(2 * acos(q(1,:)));

% Handle the zero rotation degenerate case
% Can return an arbitrary axis, but fix on z-axis rotation
singind  = issingular(th, 10 * eps(class(q)));
nsingind = sum(singind);
v(:,singind) = repmat([0;0;1], 1, nsingind);
th(singind)  = zeros(0, nsingind);

% Concatenate axis and angles
axang = cat(1, v, th);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
