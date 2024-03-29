function [UCed] = strucwords(varargin)
% STRUCWORDS uppercases each word of the given strings
%
%   Outputs:
%
%   UCED        Description of argument UCED



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2016-09-05
%       * Initial release



%% Do your code magic here

UCed = regexprep(varargin, '(^|[\. ])\s*.', '${upper($0)}');

if nargin == 1
    UCed = UCed{1};
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
