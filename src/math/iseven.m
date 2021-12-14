function flag = iseven(number)
%% ISEVEN checks the given number(s) for being even
%
% ISEVEN(NUMBER) returns true, if the number NUMBER are even i.e., dividable
% by 2.
%
% Inputs:
%
%   NUMBER              Nx1 array to check for being even.
%
% Outputs:
%
%   FLAG                Logical flag whether NUMBER is even (FLAG == 1) or odd
%                       (FLAG == 0).



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%   2016-09-19
%       * Initial release



%% Algorithm

flag = mod(number, 2) == 0;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
