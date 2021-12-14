function [varargout] = figplot(varargin)
% FIGPLOT opens a figure and plots inside this figure.
%
%   FIGPLOT takes the same arguments as regular PLOT but additionally creates a
%   new figure.
%
%   FIGPLOT is a shortcut for the common code
%       figure;
%       plot(t, y)
%
% See also: FIGURE PLOT



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2016-10-19
%       * Initial release



%% Do your code magic here
% Create a new figure
figure;

% And plot however the user wants the plot
h = plot(varargin{:});

% If an output argument is requested, we will return the same as `plot` would
% normally return
if nargout > 0
    varargout{1} = h;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
