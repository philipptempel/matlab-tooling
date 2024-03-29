function vq = laginterp(x, v, xq)
%% LAGINTERP Multidimensional Lagrange interpolation
%
% VQ = LAGINTERP(X, V, XQ) interpolates the function defined through F(X) = V at
% query points XQ.
%
% Inputs:
%
%   X                   Nx1 vector of sample points.
%
%   V                   NxK vector of N data points i.e., values.
%
%   XQ                  1xQ vector of query points.
%
% Outputs:
%
%   VQ                  QxK vector of interpolated values.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-01-18
% Changelog:
%   2022-01-18
%       * Make interface similar to `INTERP1` with respect to passing single-dim
%       and multi-dim data arrays and row/column vectors for `X` and `XQ`.
%       * Fix incorrect handling of NxK value arrays.
%   2021-11-26
%       * Initial release



%% Parse arguments

% LAGINTERP(X, V, XQ)
narginchk(3, 3);
% LAGINTERP(___)
% VQ = LAGINTERP(___)
nargoutchk(0, 1);



%% Algorithm

% Turn sample points vectors into column vectors
xq_c = xq(:);
x_c = x(:);

% Make sure v is a column vector if it's a vector
if isvector(v)
  v = v(:);
end

% Number of value points and of query points
nx = numel(x_c);
nxq = numel(xq_c);

% Ensure that V is NxK not KxN
if size(v, 1) ~= nx
  error(message('MATLAB:interp1:YVectorInvalidNumRows'))
end

% Pre-alloc eye matrix
eyeN = eye(nx, nx);

% Denominator
d = repmat(permute( ( x_c - permute(x_c, [2, 1]) ) + eyeN, [3, 1, 2] ), nxq, 1, 1);

% Numerator
n = repmat(xq_c - permute(x_c, [2, 3, 1]), 1, nx, 1);
n = n - repmat(permute(eyeN, [3, 2, 1]), nxq, 1, 1) .* ( n - 1);

% Interpolate function
vq = prod(n ./ d, 3) * v;

% Transpose queried data points in case number of data points K is 1 and QX was
% not a column vector
if size(xq, 1) == 1 && size(vq, 2) == 1
  vq = permute(vq, [2, 1]);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
