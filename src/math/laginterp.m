function vq = laginterp(x, v, xq)
%% LAGINTERP Multidimensional Lagrange interpolation
%
% VQ = LAGINTERP(X, V, XQ) interpolates the function defined through F(X) = V at
% query points XQ.
%
% Inputs:
%
%   X                   Nx1 vector of data points.
%
%   V                   NxK vector of N data points 
%
%   XQ                  Tx1 vector of query points.
%
% Outputs:
%
%   VQ                  TxK vector of interpolated values.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-26
% Changelog:
%   2021-11-26
%       * Initial release



%% Parse arguments

% LAGINTERP(X, V, XQ)
narginchk(3, 3);
% LAGINTERP(___)
% VQ = LAGINTERP(___)
nargoutchk(0, 1);



%% Algorithm

% Turn all data into column vectors
xq = xq(:);
x = x(:);

% Make sure v is a column vector if it's a vector
if isvector(v)
  v = v(:);
end

% Number of value points and of query points
nx = numel(x);
nxq = numel(xq);

% Pre-alloc eye matrix
eyeN = eye(nx, nx);

% Denominator
d = repmat(permute( ( x - permute(x, [2, 1]) ) + eyeN, [3, 1, 2] ), nxq, 1, 1);

% Numerator
n = repmat(xq - permute(x, [2, 3, 1]), 1, nx, 1);
n = n - repmat(permute(eyeN, [3, 2, 1]), nxq, 1, 1) .* ( n - 1);

% Interpolate function
vq = prod(n ./ d, 3) * v(:);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
