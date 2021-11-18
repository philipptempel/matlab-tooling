function m = mcols(A, mexpected)%#codegen
%% MCOLS Count number of columns of matrix A
%
% M = MCOLS(A) get the number of columns of 2D matrix A.
%
% M = MCOLS(A, MEXPECTED) checks the number of columns of 2D matrix A against
% MEXPECTED. If it is the same number, then M is true, otherwise false.
%   
% Inputs:
%   
%   A                   NxM array to count the columns of.
%
%   MEXPECTED           Expected number of columns.
% 
% Outputs:
% 
%   C                   Number of columns of A or True/False flag.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2016-04-08
%       * Replace validateattributes by assert
%       * Update docs
%       * Add narginchk
%   2015-05-10
%       * Update help documentation and add support for variables of type 2d
%   2015-04-27
%       * Initial release



%% Pre-process inputs
narginchk(1, 2);
% Allow for fallback MExpected
if nargin < 2 || isempty(mexpected)
    mexpected = Inf;
end



%% Assert inputs

% Need a matrix of doubles
assert(isa(A, 'double'), 'Argument [A] must be of type double');
assert(ismatrix(A), 'Argument [A] must be a matrix');
% Make sure we check MExpected only if its given
if ~isinf(mexpected)
    % MExpected must be of type double and must also be greater than zero
    assert(isa(mexpected, 'double'), 'Argument [MExpected] must be of type double');
    assert(mexpected > 0, 'Argument [MExpected] must be greater than zero');
end



%% Magic
% Get the number of rows
nCols = size(A, 2);

% Need to check against something?
if ~isinf(mexpected)
    m = nCols == mexpected;
% Don't check againts a value
else
    % Get number of rows of A
    m = nCols;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
