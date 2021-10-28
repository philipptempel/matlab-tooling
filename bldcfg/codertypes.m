function t = codertypes()
%% CODERTYPES 
%
% Outputs:
%
%   T                   Description of argument T



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-28
% Changelog:
%   2020-12-28
%       * Add two dimensional entities
%   2020-12-11
%       * Add type `tolerance`, `rotvector`
%   2020-11-16
%       * Initial release



%% Parse arguments

% CODERTYPES()
narginchk(0, 0);
% T = CODERTYPES()
nargoutchk(1, 1);



%% Create types

col = coder.newtype('double', [Inf, 1], [1, 0]);

quaternion_row = coder.newtype('double', [1 4], [0, 0]);

quaternions = coder.newtype('double', [4 Inf], [0, 1]);

quaternion_col = coder.newtype('double', [4 1], [0, 0]);

n = coder.newtype('double', [1, 1], [0, 0]);

rotmat2 = coder.newtype('double', [2, 2], [0, 0]);

rotmat3 = coder.newtype('double', [3, 3], [0, 0]);

rotmats2 = coder.newtype('double', [2, 2, Inf], [0, 0, 1]);

rotmats3 = coder.newtype('double', [3, 3, Inf], [0, 0, 1]);

rotvec = coder.newtype('double', [4, 1], [0, 0]);

row = coder.newtype('double', [1, Inf], [0, 1]);

scalar = coder.newtype('double', [1, 1], [0, 0]);

vec3d = coder.newtype('double', [3, 1], [0, 0]);

vecs3d = coder.newtype('double', [3, Inf], [0, 1]);

vec2d = coder.newtype('double', [2, 1], [0, 0]);

vecs2d = coder.newtype('double', [2, Inf], [0, 1]);

t = struct( ...
    'col', col ...
  , 'quaternion_row', quaternion_row ...
  , 'quaternions', quaternions ...
  , 'quaternion_col', quaternion_col ...
  , 'n', n ...
  , 'rotmat3', rotmat3 ...
  , 'rotmats3', rotmats3 ...
  , 'rotmat2', rotmat2 ...
  , 'rotmats2', rotmats2 ...
  , 'rotvector', rotvec ...
  , 'row', row ...
  , 'scalar', scalar ...
  , 'vec3d', vec3d ...
  , 'vecs3d', vecs3d ...
  , 'vec2d', vec2d ...
  , 'vecs2d', vecs2d ...
);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
