function flag = issize(A, r, c)
%% ISSIZE - Check whether the given matrix is of provided size/dimensions
% 
% F = ISSIZE(A, r, c) checks matrix A is of dimensions RxC
%
% 
% Inputs:
% 
%   A                   Matrix to check size of
%   
%   R                   Rows matrix A has to have. Can be empty to just check
%                       for the columns couunt to match.
%   
%   C                   Number of columns matrix A has to have. Can be empty to
%                       just check for the rows count to match
% 
% Outputs:
% 
%   F                   Evaluates to true if A is of size RxC, otherwise false.
% 



%% File Information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-02-07
% Changelog:
%   2022-02-07
%       * Update H1 documentation format
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2016-12-23
%       * Add narginchk and nargoutchk
%   2016-05-10
%       * Add general `File Information` block
%       * Update inline documentation
%   2015-06-18
%       * Update to allow for empty arguments so that we can just check the
%       columns or rows count
%   2015-04-24
%       * Update validation function to use ```isequaln``` rather than
%       ```isequal``` (slight improvement of readability and speed)
%   2015-04-22
%       * Initial release



%% Assert arguments

% ISSIZE(A, R, C)
narginchk(2, 2);
% ISSIZE(___)
% F = ISSIZE(___)
nargoutchk(0, 1);



%% Algorithm

% If no row and no column was given to check against...
if isempty(r) && isempty(c)
  flag = ismatrix(A) && isequal(size(A, 2), c);

% Just check for a row count
elseif ~isempty(r) && isempty(c)
  flag = ismatrix(A) && isequal(size(A, 1), r);

% Check for both row and column count
else
  flag = ismatrix(A) && isequaln(size(A, 1), [r, c]);

end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original
% author as can be found in the header.
% Your contribution towards improving this function will be acknowledged in
% the "Changelog" section of the header.
