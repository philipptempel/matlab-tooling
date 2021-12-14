function MaxValue = maxplotvalue(Axis)
% MAXPLOTVALUE Determine the maximum plotted value along all axes
% 
%   MAXVALUE = MAXPLOTVALUE() gets the maximum plotted value for x, y, and
%   possibly z axis for the given axis handle.
% 
%   MAXVALUE = MAXPLOTVALUE(ax) gets the maximum plotted value for x, y, and
%   possibly z for the given axis handle.
%   
%   Inputs:
%   
%   AXIS:       A valid axis handle to return the maximum plotted range for.
%
%   Outputs:
%   
%   MAXVALUE:   An array of [maxX, maxY] or [maxX, maxY, maxZ] plot range for 2D
%       plots or 3D plots, respectively.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2016-09-20
%       * Comment formatting
%   2016-03-25
%       * Add help
%   2016-03-23
%       * Initial release



%% Argument defaults
% Make sure we have an axis handle
if nargin == 0
    Axis = gca;
end



%% Actual code

% Call the plotrange function and assign output
MaxValue = plotrange(Axis, 'max');


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
