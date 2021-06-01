function c = cross2(a, b, dim)%#codegen
%% CROSS2 Two-dimensional cross product of vectors
%
% C = CROSS2(A, B) returns the two-dimensional cross product of vectors A and B.
% That is, C = a(1)*b(2) - a(2)*b(1) along the first dimension of length 2.
%
% C = CROSS2(A, B, DIM) where A and B are N-D arrays returns the cross product
% in the dimension DIM of A and B. A and B must have the same size and both
% SIZE(A, DIM) and SIZE(B, DIM) must be 2.
%
% Inputs:
%
%   A                   2xN or Nx2 vector.
%
%   B                   2xN or Nx2 vector.
%
% Outputs:
%
%   C                   1xN or Nx1 vector of two-dimensional cross product.
%
% See also:
%   CROSS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-18
% Changelog:
%   2020-12-18
%       * Initial release



%% Do your code magic here

% Special case: A and B are vectors
if isvector(a) && isvector(b)
  if (nargin == 2 && (    length(a) ~= 2 ||    length(b) ~= 2)) ...
     || (nargin == 3 && ( size(a, dim) ~= 2 || size(b, dim) ~= 2))
    error(message('MATLAB:cross:InvalidDimAorBForCrossProd'))
  end
  
  % Calculate cross product
  c = a(1) .* b(2) - a(2) .* b(1);
  
% general case
else
  
  % Check dimensions
  if ~isequal(size(a), size(b))
    error(message('MATLAB:cross:InputSizeMismatch'));
  end
  
  if nargin == 2
    dim = find(size(a) == 2, 1);
    if isempty(dim)
      error(message('MATLAB:cross:InvalidDimAorB'));
    end
  elseif size(a, dim) ~= 2
    error(message('MATLAB:cross:InvalidDimAorBForCrossProd'))
  end
  
  % Permute so that DIM becomes the row dimension
  perm = [dim:max(length(size(a)), dim), 1:dim-1];
  a = permute(a, perm);
  b = permute(b, perm);
  
  % Calculate cross product
  c = a(1,:) .* b(2,:) - a(2,:) .* b(1,:);
  
  % Post-process.
  c = ipermute(c, perm);
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
