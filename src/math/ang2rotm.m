function R = ang2rotm(a)%#codegen
%% ANG2ROTM2
%
% Inputs:
%
%   A                   Description of argument A
%
% Outputs:
%
%   R                   Description of argument R



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-02-04
% Changelog:
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

% Turn angles into 3D array
ap = reshape(a, [1, 1, numel(a)]);

% Pre-calculate the sine and cosine of the arguments
st = sin(ap);
ct = cos(ap);

% Initialize matrix
R = zeros(2, 2, numel(a), 'like', a);

R(1,1,:) = ct;
R(1,2,:) = -st;
R(2,1,:) = st;
R(2,2,:) = ct;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
