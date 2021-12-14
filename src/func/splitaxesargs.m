function [o, ax, args] = splitaxesargs(varargin)
% SPLITAXESARGS calls axescheck for a list with an object inside
%
%   Outputs:
%
%   O                   The object.
%
%   AX                  An axes handle or empty if no valid axis was given.
%
%   ARGS                List of variable arguments



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2018-05-03
%       * Initial release



%% Do your code magic here
% Split the arguments into an axes handle and everything else
[ax, args, ~] = axescheck(varargin{:});

% Get the object
o = args{1};

% And get the list of variable arguments
args = args(2:end);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
