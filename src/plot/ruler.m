function [varargout] = ruler(Axis, Position, varargin)
% RULER plots a vertical or horizontal ruler at the given position
%
%   RULER(AXIS, POSITION) plots a ruler parallel to the axis AXIS at position
%   POSITION.
%
%   RULER(AXIS, POSITION, 'Name', 'Value', ...) passes unmatched arguments to
%   the underlying plot command so that chart line properties can be adjusted
%   easily.
%
%   RULER('y', 1) plots a horizontal ruler at y = 1 spanning the whole width of
%   the current axes.
%
%   RULER('x', [1, 2, 3]) plots vertical rulers at x=1, x=2, and x=3 spanning
%   the whole width.
%
%   RULER(AX, ...) plots into the given axis handle.
%
%   RULERS = RULER(...) returns the array of handles of each ruler plotted.
%
%   Inputs:
%
%   AXIS: Axis that the positions are given in. Must be 'x' or 'y' where 'x'
%   allows to plot vertical rulers and 'y' allows to plot horizontal rulers.
%
%   POSITION: Coordinate at which the ruler intersects with the given axis. Can
%   be a scalar or vector. If a vector is given, multiple rulers will b plotted.
%   For example, RULER('x', [1 2]) plots a vertical ruler intersecting the
%   x-axis at x = 1 and x = 2.
%
%   Outputs:
%
%   RULERS: Returns a cell array of handles to all drawn rulers.
%
%   See also:
%       PLOT



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2018-05-16
%       * Remove optional argument 'LineSpec' which screwed up unmatched
%       argument processing
%   2017-11-21
%       * Fix error in processing unmatched input parser arguments if there were
%       none given
%   2017-09-17
%       * Fix incorrect processing of unmatched input parser arguments
%   2017-09-16
%       * Move LineSpec argument to unmatched results in input parser
%   2016-12-09
%       * Propagate rename of function `ascolumn` to `ascol`
%   2016-09-07
%       * Fix bug with cycliccell not being created correctly
%   2016-08-02
%       * Initial release



%% Define the input parser
ip = inputParser;

% Require: Axis. Must be 'x' or 'y'
valFcn_Axis = @(x) any(validatestring(lower(x), {'x', 'y'}, mfilename, 'Axis'));
addRequired(ip, 'Axis', valFcn_Axis);

% Allow the plot to have user-defined spec
valFcn_Position = @(x) validateattributes(x, {'double'}, {'vector', 'nonempty'}, mfilename, 'Position');
addRequired(ip, 'Position', valFcn_Position);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    varargin = [{Axis}, {Position}, varargin];
    [haTarget, args, ~] = axescheck(varargin{:});
    
    parse(ip, args{:});
catch me
    throwAsCaller(me);
end



%% Assign local variables
% Get a valid axes handle
haTarget = newplot(haTarget);
% Old hold state
lOldHold = ishold(haTarget);
% Tell figure to add next plots
hold(haTarget, 'on');
% Axis to plot as ruler
chAxis = ip.Results.Axis;
% Positions to plot
vPositions = ascol(ip.Results.Position);
% Holds the rulers' plot handles
hpRulers = gobjects(numel(vPositions), 1);
% Convert unmatched arguments from a struct to key/value cell array
if ~isempty(fieldnames(ip.Unmatched))
    ceUnmatched = cell(1, 2*numel(fieldnames(ip.Unmatched)));
    ceUnmatched(1:2:end) = fieldnames(ip.Unmatched);
    ceUnmatched(2:2:end) = struct2cell(ip.Unmatched);
else
    ceUnmatched = {};
end
% Plot style for the rulers
cePlotStyle = cycliccell(ceUnmatched, numel(vPositions));



%% Plot the lines
% Get the current x and y lims
vXLim = xlim(haTarget);
vYLim = ylim(haTarget);
% Loop over all positons to-be-plotted
for iPos = 1:numel(vPositions)
    % Ruler on which axis?
    switch chAxis
        case 'x'
            % x = pos
            vXValues = [vPositions(iPos), vPositions(iPos)];
            % y = lims
            vYValues = vYLim;
        case 'y'
            % x = lim
            vXValues = vXLim;
            % y = pos
            vYValues = [vPositions(iPos), vPositions(iPos)];
    end
    % Plot the current ruler in x or y dirn
    hpRulers(iPos) = plot(haTarget, vXValues, vYValues);
    % Got plot styles?
    if ~isempty(cePlotStyle)
        % Set the current line style
        set(hpRulers(iPos), cePlotStyle{iPos}{:});
    end
end

% Finally, make sure the figure is drawn
drawnow

% Reset the old hold state if it wasn't set
if ~lOldHold
    hold(haTarget, 'off');
end



%% Assign output quantities
% First return value is the handles of ruler plots
if nargout > 0
    if numel(vPositions) == 1
        varargout{1} = hpRulers(1);
    else
        varargout{1} = hpRulers;
    end
end


end



function ceValue = in_getCyclicValue(ceSource, iCount)

% If the source is not emtpy
if ~isempty(ceSource)
    % Check its not a multi-dim cell aray
    if ~iscell(ceSource{1})
        % Then we will just return the given anchor specs
        ceValue = ceSource;
    % Multi-dim cell array
    else
        % Number of available anchor specs
        nBases = numel(ceSource);
        % Index of the anchor spec we will be using is just the remainder of the
        % division of what anchor number we are processing and how many anchors are
        % available
        iAnchorSelect = mod(iCount - 1, nBases) + 1;
        % Assign this as reutrn value
        ceValue = ceSource{iAnchorSelect};
    end
% Source is empty: extracted value is empty
else
    ceValue = {};
end

end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
