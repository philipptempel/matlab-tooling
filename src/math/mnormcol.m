function Mn = mnormcol(M)%#codegen
%% MNORMCOL Normalize a matrix per column
% 
% MN = MNORMCOL(M) normalizes each column of matrix MAT by its norm.
%   
% Inputs:
%   
%   M                   Matrix of variable dimension to be normalized.
%
% Outputs:
%
%   MN                  Matrix with each column's norm being one.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%   2016-04-04
%       * Initial release



%% Parse arguments

narginchk(1, 1);
nargoutchk(0, 1);

assert(isa(M, 'double'), 'Input must be of type double');



%% Algorithm

Mn = transpose(mnormrow(transpose(M)));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
