function Mn = mnormdim(M, dim)%#codegen
%% MNORMDIM Normalize matrix along a certain dimension
% 
% MN = MNORMDIM(M, DIM) normalizes matrix M along dimension DIM.
%   
% Inputs:
%   
%   M                   Matrix of variable dimension to be normalized.
%
%   DIM                 Scalar value of dimension to normalize along.
%
% Outputs:
%
%   MN                  Matrix with each column's norm being one.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-10-04
% Changelog:
%   2022-10-04
%       * Initial release



%% Parse arguments

% MNORMDIM(M, DIM)
narginchk(2, 2);

% MNORMDIM(___)
% MN = MNORMDIM(___)
nargoutchk(0, 1);



%% Algorithm

% To support codegen, we need to repeat CN such that it has the same overall
% shape as M. Thus, get an array that is all 1 except for where the
% normalization dimension was, which is where we need to repeat CN along
md = ones(1, ndims(M));
md(dim) = size(M, dim);

% Divide matrix by the scaling factor along all dimensions but the one we
% normalized along
Mn = bsxfun(@rdivide, M, repmat(sqrt(sum(M .^ 2, dim)), md));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
