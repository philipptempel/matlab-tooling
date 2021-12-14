function m = rotrow2m(r)%#codegen
%% ROTROW2M converts a 1d rotation matrix row vector to its matrix representation
% 
% RM = ROTROW2M(RR) converts the Nx4 matrix ROW into its 2x2xN matrix
% representation form where each consecutive three elements of ROW are placed in
% each row the matrix
%
% RM = ROTROW2M(RR) converts the Nx9 matrix ROW into its 3x3xN matrix
% representation form where each consecutive three elements of ROW are placed in
% each row the matrix
%   
%   
% Inputs:
% 
%   RR                  The Nx4 or Nx9 row vector representing [R11 R12 R21 R22]
%                       or [R11 R12 R13 R21 R22 R23 R31 R32 R33] per row,
%                       respectively.
% 
% Outputs:
%   
%   RM                  2x2xN or 3x3xN matrix of the rotation row where along
%                       the first dimension the matrix looks like [R11, R12;
%                       R21, R22] or [R11, R12, R13; R21, R22, R23; R31, R32,
%                       R33], respectively.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%   2018-04-22
%        * Add support for two-dimensional rotation matrices
%   2017-04-17
%       * Add argument assertion
%   2016-05-10
%       * Add END OF CODE block
%   2016-05-09
%       * Initial release



%% Assert arguments
narginchk(1, 1);
nargoutchk(0, 1);

assert(any(size(r, 2) == [4, 9]), 'Invalid count of length along dimension 2. Must be 4 or 9');
validateattributes(r, {'numeric'}, {'2d', 'nonnan', 'nonsparse', 'finite', '<=', 1, '>=', -1}, mfilename, 'Row');



%% Transformation
% Number of Rows to convert
nRows = size(r, 1);
% Dimension of the rotation matrix
nDim = size(r, 2);
% And reshape to match size Nx9
m = permute(reshape(transpose(r), sqrt(nDim), sqrt(nDim), nRows), [2 1 3]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
