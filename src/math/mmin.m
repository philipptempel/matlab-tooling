function [M, I] = mmin(A)
%% MMIN behaves similar to MIN except that it automatically shrinks down to
% dimension 1
%
% M = MMIN(A) returns the maximum value of A over all dimensions of A.
%
% Inputs:
%
%   A                   Arbitrarily sized matrix A.
%
% Outputs:
%
%   M                   Minimum value found in A.
%
%   I                   Linear index of minimum M in A.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%   2016-11-13
%       * Initial release



%% Do your code magic here

% Get the first maximum
aMins = min(A);

% While M is not a scalar, we will get the maximum value of it
while ~isscalar(aMins)
    aMins = min(aMins);
end



%% Assign output quantities
% First output is the maximum value found
M = aMins;

% Secound output is the index of the maximum value
if nargout > 1
    I = find(A == aMins, 1, 'first');
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
