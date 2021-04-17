function r = rotv2rotm(v, tol)%#codegen
%% ROTV2ROTM 
%
% R = ROTV2ROTM(V)
%
% R = ROTV2ROTM(V, TOL)
%
% Inputs:
%
%   V                   4x1 axis-angle where the angle is the first component
%                       and the axis is in R([2,3,4]).
%
%   TOL                 Tolerance threshold used as upper limit for determining
%                       if a value is singular (close to zero) or not.
%
% Outputs:
%
%   R                   3x3 rotation matrix.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-23
% Changelog:
%   2020-12-23
%       * Rename to `rotv2rotm`
%   2020-12-11
%       * Initial release



%% Parse arguments

narginchk(1, 2);
nargoutchk(0, 1);

if nargin < 2 || isempty(tol)
  tol = 1e-12;
end



%% Do your code magic here


% build the rotation matrix
s = sin(v(1));
c = cos(v(1));
t = 1 - c;

n = v([2,3,4]);

n = n ./ repmat(sqrt(sum(n .^ 2, 1)), [3, 1]);

% Remove singular values
n(issingular(n, tol)) = 0;

x = n(1);
y = n(2);
z = n(3);

% Compose rotation matrix
r = [ ...
  t * x * x + c,     t * x * y - s * z,  t * x * z + s * y ; ...
  t * x * y + s * z, t * y * y + c,      t * y * z - s * x ; ...
  t * x * z - s * y, t * y * z + s * x,  t * z * z + c ; ...
];

% Remove more singular values
r(issingular(r)) = 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
