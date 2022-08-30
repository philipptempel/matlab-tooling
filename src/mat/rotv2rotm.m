function R = rotv2rotm(v, tol)%#codegen
%% ROTV2ROTM 
%
% R = ROTV2ROTM(V)
%
% R = ROTV2ROTM(V, TOL)
%
% Inputs:
%
%   V                   4xN axis-angle where the angle is the first component
%                       and the axis is in V([2,3,4],:).
%
%   TOL                 Tolerance threshold used as upper limit for determining
%                       if a value is singular (close to zero) or not.
%
% Outputs:
%
%   R                   3x3 rotation matrix.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-08-30
% Changelog:
%   2022-08-30
%       * Add support for multiple rotation vectors
%   2020-12-23
%       * Rename to `rotv2rotm`
%   2020-12-11
%       * Initial release



%% Parse arguments

% ROTV2ROTM(V)
% ROTV2ROTM(V, TOL)
narginchk(1, 2);

% ROTV2ROTM(___)
% R = ROTV2ROTM(___)
nargoutchk(0, 1);

% ROTV2ROTM(V)
if nargin < 2 || isempty(tol)
  tol = 1e-12;
end



%% Algorithm

% Number of rotation vectors
nv = size(v, 2);

% Shift each column into its own page
vp = reshape(v, [4, 1, nv]);

% Get sine and cosine of rotations
s = sin(vp(1,:,:));
c = cos(vp(1,:,:));
t = 1 - c;

% Get rotation vectors and normalize
n = vp([2,3,4],:,:);
n = n ./ repmat(sqrt(sum(n .^ 2, 1)), [3, 1, 1]);

% Remove singular values
n(issingular(n, tol)) = 0;

% Extract components
x = n(1,:,:);
y = n(2,:,:);
z = n(3,:,:);

% Compose rotation matrix
r = cat(1 ...
  , t .* x .* x + c      , t .* x .* y - s .* z , t .* x .* z + s .* y ...
  , t .* x .* y + s .* z , t .* y .* y + c      , t .* y .* z - s .* x ...
  , t .* x .* z - s .* y , t .* y .* z + s .* x , t .* z .* z + c ...
);

% Reshape to 3x3xN and then transpose each page  (due to MATLAB's column major)
R = permute(reshape(r, [3, 3, nv]), [2, 1, 3]);

% Remove more singular values
R(issingular(R)) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
