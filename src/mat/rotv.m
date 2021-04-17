function r = rotv(a, b, tol)
%% ROTV Calculate rotation axis-angle between two vectors.
%
% R = ROTV(A, B) alculates a rotation needed to transform a 3d vector A to a
% 3d vector B.
%
% R = ROTV(A, B, TOL) calculates the rotation with the default tolerance for
% singular values being set to TOL.
%
% Inputs:
%
%   A                   3x1 source vector.
%
%   B                   3x1 target vector.
%
%   TOL                 Tolerance for assuming values singular.
%
% Outputs:
%
%   R                   4x1 axis-angle vector rotating A to B with the angle in
%                       R(1) and the normalized rotation axis in R([2,3,4]).



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-23
% Changelog:
%   2020-12-23
%       * Rename to `rotv`
%   2020-12-11
%       * Initial release



%% Parse arguments


% ROTV(A, B)
% ROTV(A, B, TOL)
narginchk(2, 3);
% ROTV(...)
% R = ROTV(...)
nargoutchk(0, 1);

if nargin < 3 || isempty(tol)
  tol = 1e-12;
end



%% Do your code magic here

% Normalize vectors
an = a(:);
an = an ./ repmat(sqrt(sum(an .^ 2, 1)), [3, 1]);
an(issingular(an, tol)) = 0;
bn = b(:);
bn = bn ./ repmat(sqrt(sum(bn .^ 2, 1)), [3, 1]);
bn(issingular(bn, tol)) = 0;

cn = cross(an, bn);
cn = cn ./ repmat(sqrt(sum(cn .^ 2, 1)), [3, 1]);
cn(issingular(cn, tol)) = 0;

% min to eliminate possible rounding errors that can lead to dot product >1
angle = acos(min(dot(an, bn), 1));

% if cross(an, bn) is zero, vectors are parallel (angle = 0) or antiparallel
% (angle = pi). In both cases it is necessary to provide a valid axis. Let's
% select one that satisfies both cases - an axis that is perpendicular to
% both vectors. We find this vector by cross product of the first vector 
% with the "least aligned" basis vector.
if ~any(cn)
    absa = abs(an);
    [~, mind] = min(absa);
    c = zeros(3, 1);
    c(mind) = 1;
    cn = cross(an, c);
    cn = cn ./ repmat(sqrt(sum(cn .^ 2, 1)), [3, 1]);
    cn(issingular(cn, tol)) = 0;
end


% Build vector of rotation
r = [ ...
  angle ; ...
  cn(:) ; ...
];


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
