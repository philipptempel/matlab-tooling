function varargout = plot_markers(h, n, varargin)
%% PLOT_MARKERS Plot some markers on the lines given in Axes
% 
% PLOT_MARKERS(H, COUNT) plots COUNT markers along all of the lines of the
% current axes. If count is given as a vector, then the values will be used
% according to the lines found in the current axes. For example, if there are 4
% lines in the current plot, PLOT_MARKERS([25, 50, 30, 60]) will add 25 markers
% on the first line, 50 on the second, 30 on the third, and 60 on the
% fourth/last. If the number of markers is smaller than the number of child
% charts found in the given axes, the markers will cyclically repeat.
%
% PLOT_MARKERS(H, COUNT, SPACING) does spacing according to the value chosen.
% Possible options for SPACING are
%       x       equidistant spacing along the x-axis (primary axis).
%       curve   equidistant along curve y
%       logx    used with logarithmix x-scale
% 
% PLOT_MARKERS(H, COUNT, SPACING, ORDER) uses the given order of marker styles
% to plot into the given axes. Defaults to 'o|+|*|x'. Markers will be applied in
% order of found child objects in the current axis. If the number of markers is
% smaller than the number of valid charts then markers will be cyclically
% repeated.
%
% PLOT_MARKERS(H, COUNT, SPACING, ORDER, 'PropertyName', 'PropertyValue', ...)
% plots markers for the given axis.
%
% MARKERHANDLES = PLOT_MARKERS(...) returns a vector of N handles of markers
% having been placed for each of the N children of the given axes.
%
% [MARKERHANDLES, LEGENDMARKERHANDLES] = PLOT_MARKERS(...) also returns vector
% of N handles representing the legend markers which will be set into the
% legend.
%   
% Inputs:
%
% Outputs:
%
% MARKERHANDLES             Vector of N handles (one for each child of axes) to
%                           all the plotted marker lines.
%
% LEGENDMARKERHANDLES       Vector of handles of single item plots (one per
%                           child) that can be used to mark the handles in the
%                           legend).
%
% Optional Inputs -- specified as parameter value pairs
% 
% Count                     Number of markers per line. Default is 25
%
% Spacing                   Spacing according to which the markers should be
%                           spaced. Valid values are:
%                           x     - equidistant spacing along the x-axis (primary axis)
%                           curve - equidistant along curve 
%                           logx  - equidistant along a log-x axis
%
% Order                     Pipe-separated list of marker order for the lines
%                           found in the given axes. Default is 'o|+|*|x'.
%
% See also
%   PLOT



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%       * Move To Do section below Changelog
%   2018-03-25
%       * Fix collection of child objects from the given axes to ensure that
%       axes with two y-axis also work
%       * Reverse direction of looping over children so that the resulting
%       marker array is of same order as the plotted lines
%       * Update H1 help block
%   2017-09-16
%       * Change order and type of arguments from (opt:count, opt:order,
%       opt:spacing) to (opt:count, opt:spacing, par:order)
%   2016-11-01
%       * Update input argument checking to be more robust
%       * Allow function to be called with either ORDER or SPACING as second
%       argument
%   2016-09-06
%       * Update types of arguments from Parameter to Optional
%   2016-08-02
%       * Change to using gobjects for holding returned graphic handles
%       * Change to using ```axescheck``` and ```newplot```
%   2016-07-14
%       * Wrap IP-parse in try-catch to have nicer error display
%   2016-05-23
%       * Update help doc
%       * Fix bug when plotting more markers than actual data points caused an
%       'subscript indices' error
%       * Remove diff and add gradient into determining the arc length of the
%       given curve
%       * Fix bug that caused script to always open a new axes to plot into
%       instead of plotting into the current one
%   2016-04-01
%       * Initial release
% TODO:
%   * If a legend can be found in the plot, we should extract the lines' legend
%   entries from these values... somehow



%% Parse Arguments

ip = inputParser();

% User provides objects for which to plot markers
% Plot style can be chosen anything from the list below
valFcn_Handle = @(x) validateattributes(x, {'matlab.graphics.chart.primitive.Line'}, {'nonempty'}, mfilename, 'Handle');
addRequired(ip, 'Handle', valFcn_Handle);

% Let user decide on the plot style
% Plot style can be chosen anything from the list below
valFcn_Count = @(x) validateattributes(x, {'numeric'}, {'row', '>=', 1}, mfilename, 'Count');
addRequired(ip, 'Count', valFcn_Count);

% Optional 2: Spacing between the markers
valFcn_Spacing = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Spacing');
addParameter(ip, 'Spacing', 'x', valFcn_Spacing);

% Parameter: Markers to set or order of markers
valFcn_Order = @(x) validateattributes(x, {'char', 'cell'}, {'nonempty'}, mfilename, 'Order');
addParameter(ip, 'Order', 'o|+|*|x', valFcn_Order);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
  narginchk(1, Inf);
  
  nargoutchk(0, 2);
  
  parse(ip, h, n, varargin{:});
  
catch me
  throwAsCaller(me);
  
end



%% Process arguments
% Get handles to plot
hh = ip.Results.Handle;

% Get the number of markers
vMarkersCount = ip.Results.Count;
% Get the marker order
if ischar(ip.Results.Order)
  assert(length(ip.Results.Order) == 1 | any(strfind(ip.Results.Order, '|')), 'PHILIPPTEMPEL:MATLAB_TOOLING:PLOT_MARKERS:InvalidOrderSeparator', 'Invalid format for marker order given. Multiple markers must be separated by a |');
  ceMarkerOrder = strsplit(ip.Results.Order, '|');
else
  ceMarkerOrder = ip.Results.Order;
end
assert(all(ismember(ceMarkerOrder, {'o', '+', '*', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'})), 'PHILIPPTEMPEL:MATLAB_TOOLING:PLOT_MARKERS:InvalidOrderType', 'Invalid order type given.');

% Get the spacing as reqeusted by the user
chSpacing = lower(ip.Results.Spacing);
% Assert spacing
validatestring(chSpacing, {'x', 'curve', 'logx'}, mfilename, 'Spacing', 3);

% Get unmatched values to pass them down
fnu = fieldnames(ip.Unmatched);
unm = reshape(cat(1, fnu, struct2cell(ip.Unmatched)), 1, []);



%% Pre-process data

% How many objects we have
nhh = numel(hh);

% Ensure we have enough markers for all children
if isscalar(vMarkersCount)
  vMarkersCount = vMarkersCount .* ones(nhh, 1);
elseif numel(vMarkersCount) < nhh
  vMarkersCount = repmat(vMarkersCount, 1, ceil(nhh / numel(vMarkersCount)));
end

% Repeat the markers until we have enough for every child
if numel(ceMarkerOrder) < nhh
  ceMarkerOrder = repmat(ceMarkerOrder, 1, ceil(nhh/numel(ceMarkerOrder)));
end

% Holds the handles to the generated plots
hMarkers     = gobjects(nhh, 1);
hMarkerStart = gobjects(nhh, 1);



%% Here is where all the adjustment happens
% For every child...
for ih = 1:nhh
  % Get child object
  mxChild = hh(ih);
  
  % Make original object invisible
  set(mxChild, 'HandleVisibility', 'off');
  % Get original line style
  chOriginalLinestyle = get(mxChild, 'LineStyle');
  % And get original data
  vXData = get(mxChild, 'XData');
  vYData = get(mxChild, 'YData');
  vZData = get(mxChild, 'ZData');
  
  % Fall back to spacing along x if the data is 3D (currently we do not support
  % 'curve' spacing for 3D plots. I honestly don't know the equations to
  % determine the arc length of a 3D plot though it most likely will be similar
  % to the 2D version $s = \int_{x_1}^{x_2}{ 1 + \frac{\partial f}{\partial x}
  % \mathrm{d}\, x}$)
  if ~isempty(vZData) && strcmp(chSpacing, 'curve')
    chSpacing = 'x';
    
  % If there is but one data point
  elseif numel(vXData) == 1
    % Simply space markers according to the X-value
    chSpacing = 'x';
    
  end
  
  % Make sure we do not want to plot more markers than there are
  % actual data points
  if vMarkersCount(ih) > numel(vXData)
    vMarkersCount(ih) = numel(vXData);
  end
  
  % Get child's parent axes object
  hax = ancestor(mxChild, 'axes');
  
  %%% Create two copies of the current graphics type
  % First copy will be used to display only the markers
  hMarkers(ih) = copyobj(mxChild, hax);
  % Second copy will be only the first item so that we can have it set
  % properly into the legends
  hMarkerStart(ih) = copyobj(mxChild, hax);
  
  % Determine the point selector based on the desired input
  switch chSpacing
    % Uniform along x
    case 'x'
      vSelector = round(linspace(1, numel(vXData), vMarkersCount(ih)));
      
    % Logarithmic along x
    case 'logx'
      vSelector = floor( ...
          interp1( ...
              vXData ...
            , 1:length(vXData) ...
            , logspace(log10(vXData(2)), log10(vXData(end-1)) ...
            , vMarkersCount(ih)) ...
          ) ...
        );
      
    % Uniform along the curve
    case 'curve'
      
      % @TODO Determine this value automatically from the axes dimensions
      dFigureScale = 3/4;
      % Normalize y scale in [0 1], height of display is prop to max(abs(y))        
      vNormalizedYData = ( vYData - min(vYData) ) ./ ( max(vYData) - min(vYData) )*dFigureScale;
      % Normalize x scale in [0 1]   
      vNormalizedXData = ( vXData - min(vXData) ) ./ ( max(vXData) - min(vXData) );
      
      % Spacing along curves with INFs in it not possible
      if any(isinf(vNormalizedYData)) || any(isinf(vXData))
        vSelector = round(linspace(1, length(x), num_Markers)); 
        
      else
        vXIndex = 1:length(vXData);
        % Measure length along curve
        vArcLength = cumsum( sqrt( gradient(vNormalizedXData) .^ 2 + gradient(vNormalizedYData) .^ 2 ) );
        % Vector equally spaced along s
        vArcSpaced = ( (0:vMarkersCount(ih)) - 1 ) .* vArcLength(end) ./ ( vMarkersCount(ih) - 1 );
        % Make sure first and last point are on the curve
        vArcSpaced(1)   = vArcLength(1);
        vArcSpaced(end) = vArcLength(end);
        % And get the x-indices of these values of y
        vSelector = fix(interp1(vArcLength, vXIndex, vArcSpaced));
        % Remove NaNs
        vSelector(isnan(vSelector)) = [];
        
      end
      
  end
  
  % Grab the actual data to be plotted
  vMarkerXData = vXData(vSelector);
  vMarkerYData = vYData(vSelector);
  if ~isempty(vZData)
    vMarkerZData = vZData(vSelector);
  end
  
  %%% Work on the "marker only" object
  set( ...
      hMarkers(ih) ...
    , 'LineStyle', 'none' ...
    , 'Marker', ceMarkerOrder{ih} ...
    , 'XData', vMarkerXData ...
    , 'YData', vMarkerYData ...
    , 'HandleVisibility', 'off' ...
    , 'Parent', hax ...
    , 'Tag', sprintf('%s_Marker', get(mxChild, 'Tag')) ...
    , unm{:} ...
  );
  
  % If there is previous z-data we will update that as well
  if ~isempty(vZData)
    set(hMarkers(ih), 'ZData', vMarkerZData);
  end
  
  
  %%% Work on the "first marker" object
  set( ...
      hMarkerStart(ih) ...
    , 'XData', vXData(1) ...
    , 'YData', vYData(1) ...
    , 'LineStyle', chOriginalLinestyle ...
    , 'Marker', ceMarkerOrder{ih} ...
    , 'HandleVisibility', 'on' ...
    , 'Parent', hax ...
    , 'Tag', sprintf('%s_FirstMarker', get(mxChild, 'Tag')) ...
    , unm{:} ...
  );
  
  if ~isempty(vZData)
    set(hMarkerStart(ih), 'ZData', vZData(1));
  end
  
end

% Update the figure
drawnow();



%% Assign output quantities
% First optional return argument is the handles of markers
if nargout > 0
  % Reverse the order of the generated marker-only handles so that it matches
  % the order of plotted lines. If you read this comment and know why this has
  % to be done, please, please, let me know.
  varargout{1} = flipud(hMarkers);
end

% Second optional return argument is the handles of the start markers
if nargout > 1
  % Reverse the order of the generated marker-line handles so that it matches
  % the order of plotted lines. If you read this comment and know why this has
  % to be done, please, please, let me know.
  varargout{2} = flipud(hMarkerStart);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
