function skew = vec2skew(vec)%#codegen
%% VEC2SKEW Turn the input into its skew-symmetrix matrix form
% 
% S = VEC2SKEW(V) turns vec into its skew-symmetric matrix. Vector V can be
% either a 2D or 3D vector.
%
% In case of 2D vectors i.e., size(V, 1) == 2, S is
%   [-V(2), V(1)]
%
% In case of 3D vectors i.e., size(V, 1) == 3, S is
%   [     0, -V(3), V(2) ]
%   [  V(3),    0, -V(1) ]
%   [ -V(2), V(1),    0 ]
%   
% Inputs:
%   
%   V                   2xN or 3xN array.
%
% Outputs:
%
%   SKEW                1x2xN or 3x3xN array of skew-symmetric matrices of
%                       vector V.
%
% See also:
%   CROSS



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-03-01
% Changelog:
%   2021-03-01
%       * Update to also support case of `V` in R2.
%       * Enforce arguemnt to vec2skew to be a 2xN or 3xN column-major array.
%       * Remove `validateattributes` as it is incompatibel with `codegen`
%   2020-11-25
%       * Use `validateattributes` to validate arguments
%       * Require vec to be 3xN
%   2020-11-17
%       * Copy from my own personal MATLAB package to `functions` package
%       * Change author's email domain to `ls2n.fr`
%   2016-04-13
%       * Allow vec2skew to work on matrices thanks to help from quat2rot.m
%       * Update help doc
%       * Add block "File information"
%   2015-04-24
%       * Initial release



%% Input parsing

% VEC2SKEW(V)
narginchk(1, 1);
% VEC2SKEW(V)
% S = VEC2SKEW(V)
nargoutchk(0, 1);



%% Process inputs

% Dimensionality of vector
ndim = size(vec, 1);

% Number of vectors == columns of aVectors
nv = size(vec, 2);

% Reshape the vector in the depth dimension
vec3 = reshape(vec, [ndim, 1, nv]);

% Vector in R3
if ndim == 3
  % Quicker access to important parts
  s = zeros(1, 1, nv);
  x = vec3(1,1,:);
  y = vec3(2,1,:);
  z = vec3(3,1,:);

  % Explicitly define concatenation dimension for codegen
  tempS = cat(1, s, -z, y, z, s, -x, -y, x, s);
  skew = permute(reshape(tempS, [3, 3, nv]), [2, 1, 3]);

% Vector in R2
else
  x = vec3(1,1,:);
  y = vec3(2,1,:);
  
  % Explicitly define concatenation dimension for codegen
  tempS = cat(1, -y, x);
  skew = reshape(tempS, [1, 2, nv]);
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
