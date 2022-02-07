function f = issize(A, s)%#codegen
%% ISSIZE - Check whether the given matrix is of provided size/dimensions
% 
% F = ISSIZE(A, S) checks if array A has size S
%
% 
% Inputs:
% 
%   A                   Matrix to check size of.
%
%   S                   Array of sizes per dimension to check. To skip a
%                       dimensions, set it to Inf.
% 
% Outputs:
% 
%   F                   Evaluates to true if A is of size S, otherwise false.
% 



%% File Information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-02-07
% Changelog:
%   2022-02-07
%       * Add `codegen` directive
%       * Update algorithm to actually match its name i.e., check for arbitrary
%       sizes
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

% ISSIZE(A, S)
narginchk(2, 2);
% ISSIZE(___)
% F = ISSIZE(___)
nargoutchk(0, 1);



%% Algorithm

% Get size of A for all requested dimensions
sz = size(A, 1:numel(s));

% Get only non-inf dimensions
sel = ~isinf(s);

% And check
f = all(sz(sel) == sz(sel));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original
% author as can be found in the header.
% Your contribution towards improving this function will be acknowledged in
% the "Changelog" section of the header.
