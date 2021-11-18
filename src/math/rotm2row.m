function rr = rotm2row(rm)%#codegen
%% ROTM2ROW converts a 3D rotation matrix to a row
% 
% RR = ROTM2ROW(RM) converts the 2x2xM or 3x3xM matrix into a Mx4 or Mx9 vector.
%   
%   
% Inputs:
%   
%   RM                  A 2x2xM or 3x3xN matrix of rotation matrices.
% 
% Outputs:
% 
%   RR                  Mx4 or Mx9 matrix of rotation matrix rows where the
%                       columns of MATRIX are horizontally concatenated.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-11-17
% Changelog:
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

assert(any([any(size(rm, 2) == [2, 2, NaN]), any(size(rm, 2) == [3, 3, NaN])]), 'Invalid count of length along dimension 2. Expected Matrix to be of size 2x2xM or 3x3xM.');
validateattributes(rm, {'numeric'}, {'3d', 'nonnan', 'nonsparse', 'finite', '<=', 1, '>=', -1}, mfilename, 'Matrix');



%% Transformation
% Number of matrices to convert
nMatrices = size(rm, 3);
% Size of the rotation matrix
nDim = size(rm, 2);
% And reshape to match size Nx9
rr = reshape(permute(rm, [3, 2, 1]), nMatrices, nDim*nDim);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
