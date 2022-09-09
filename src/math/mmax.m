function M = mmax(A, nanflag)%#codegen
%% MMAX behaves similar to MAX except that it automatically shrinks down to
% dimension 1
%
% M = MMAX(A) returns the maximum value of A over all dimensions of A.
%
% M = MMAX(A, NANFLAG) specifies how NaN (Not-A-Number) values are treated.
%
% Inputs:
%
%   A                   Arbitrarily sized matrix A.
%
% Outputs:
%
%   M                   Maximum value found in A.
%
% See also:
%   MAX MMIN



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-02-07
% Changelog:
%   2022-02-07
%       * Add codegen directive
%       * Remove output argument `I` as it makes no sense in this function
%       * Add input argument `NANFLAG`
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%   2016-11-13
%       * Initial release



%% Parse arguments

% MMAX(A)
% MMAX(A, NANFLAG)
narginchk(1, 2);

% MMAX(___) 
% M = MMAX(___) 
nargoutchk(0, 1);

% MMAX(A)
if nargin < 2 || isempty(nanflag)
  nanflag = 'omitnan';
end



%% Algorithm

% Simple wrapper
M = max(A, [], 'all', nanflag);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
