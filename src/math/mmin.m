function m = mmin(A, nanflag)%#codegen
%% MMIN behaves similar to MIN except that it automatically shrinks down to
% dimension 1
%
% M = MMIN(A) returns the minimum value of A over all dimensions of A.
%
% M = MMIN(A, NANFLAG) specifies how NaN (Not-A-Number) values are treated.
%
% Inputs:
%
%   A                   Arbitrarily sized matrix A.
%
% Outputs:
%
%   M                   Minimum value found in A.
%
% See also:
%   MIN MMAX



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

% MMIN(A)
% MMIN(A, NANFLAG)
narginchk(1, 2);

% MMIN(___) 
% M = MMIN(___) 
nargoutchk(0, 1);

% MMIN(A)
if nargin < 2 || isempty(nanflag)
  nanflag = 'omitnan';
end



%% Algorithm

% Simple wrapper
m = min(A, [], 'all', nanflag);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
