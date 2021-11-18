function R = rot2(ang)%#codegen
%% ROT2 creates the 2D rotation matrix of angles A
%
% Inputs:
%
%   ANG                 Nx1 vector of angles in radian to turn into rotation
%                       matrices.
%
% Outputs:
%
%   R                   2x2xN rotation matrix for each agle.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2020-12-19
%       * Copy from personal MATLAB package
%   2017-03-06
%       * Fix use of degree to radian
%   2017-03-05
%       * Add support for multiple angles in A. Now returns a 2x2xN matrix for
%       Nx1 vector A
%   2017-01-03
%       * Initial release



%% Parse arguments

% ROT2()
% ROT2(ANG)
narginchk(0, 1);
% ROT2(...)
% R = ROT2(...)
nargoutchk(0, 1);

% Quickly bail out for no argument 
if nargin < 1 || isempty(ang)
  R = eye(2);
  
  return
end



%% Create rotation matrix

% Turn angles into 3D array
ap = reshape(ang, [1, 1, numel(ang)]);

% Pre-calculate the sine and cosine of the arguments
st = sin(ap);
ct = cos(ap);

% Initialize matrix
R = zeros(2, 2, numel(ang), 'like', ang);

R(1,1,:) = ct;
R(1,2,:) = -st;
R(2,1,:) = st;
R(2,2,:) = ct;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
