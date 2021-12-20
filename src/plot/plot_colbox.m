function varargout = plot_colbox(colors, varargin)
% PLOT_COLBOX plots a colored box (patch) for the given color
%
%   PLOT_COLBOX(COLORS) plots the colors as boxes in an evenly distributed grid.
%
%   PLOT_COLBOX(COLORS, 'Name', 'Value', ...) allows setting optional inputs
%   using name/value pairs.
%
%   Inputs:
%
%   COLORS              Mx3 array of colors to plot. Each color will be plotted
%                       into its own rectangle of a specified width and with a
%                       given padding.
%
%   Optional Inputs -- specified as parameter value pairs
%
%   Edge                Edge length of each colored box. Defaults to 50 (units).
%
%   Padding             Padding around each box. Defaults to 5 (units).
%
%   Background          1x3 array of background RGB values that should be
%                       applied. Defaults to `[1, 1, 1]` (white).



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2019-11-25
%       * Update implementation such that it plots colored boxes with row-major,
%       which is more intuitive
%       * Remove option Rows
%       * Increase default values of `Edge` and `Padding`
%       * Add option to provide background color as RGB values
%   2018-01-23
%       * Update procedure to support custom rows count
%   2017-02-24
%       * Initial release



%% Define the input parser
ip = inputParser;

% Required: Colors; numeric; 2d, non-empty, non-sparse, finite, non-negative, <=
% 1, ncols == 3
valFcn_Colors = @(x) validateattributes(x, {'numeric'}, {'2d', 'nonempty', 'ncols', 3, 'nonsparse', 'finite', 'nonnegative', '<=', 1}, mfilename, 'colors');
addRequired(ip, 'Colors', valFcn_Colors);

% Parameter: Edge; numeric; scalar, non-empty, non-sparse, finite, non-negative
valFcn_Edge = @(x) validateattributes(x, {'numeric'}, {'scalar', 'nonempty', 'nonsparse', 'finite', 'nonnegative'}, mfilename, 'Edge');
addParameter(ip, 'Edge', 50, valFcn_Edge);

% Parameter: Padding; numeric; scalar, non-empty, non-sparse, finite, non-negative
valFcn_Padding = @(x) validateattributes(x, {'numeric'}, {'scalar', 'nonempty', 'nonsparse', 'finite', 'nonnegative'}, mfilename, 'Padding');
addParameter(ip, 'Padding', 5, valFcn_Padding);

% Parameter: Background; numeric; vector, non-empty, non-sparse, ge 0, le 1, non-negative
valFcn_Background = @(x) validateattributes(x, {'numeric'}, {'vector', 'nonempty', 'nonsparse', 'finite', 'nonnegative', 'numel', 3, '>=', 0, '<=', 1}, mfilename, 'Background');
addParameter(ip, 'Background', [1, 1, 1], valFcn_Background);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    varargin = [{colors}, varargin];
    [haTarget, args, ~] = axescheck(varargin{:});
    
    parse(ip, args{:});
catch me
    throwAsCaller(me);
end



%% Parse IP results
% Colors to plot
aColors = ip.Results.Colors;
% Edge length
dRectangle_EdgeLength = ip.Results.Edge;
% Padding around rectangles
dRectangle_Padding = ip.Results.Padding;
% Background color
vBackground = ip.Results.Background(:);



%% Do your code magic here
% Number of colors to plot
nColors = size(aColors, 1);
% Calculate number of columns and number of rows
nRows = floor(sqrt(nColors));
nCols = ceil(nColors / nRows);

% Get a valid axes handle
haTarget = newplot(haTarget);

% Old hold state
lOldHold = ishold(haTarget);

% Hold axes
hold(haTarget, 'on');

% Init image
aImg = uint8((255 * permute(vBackground, [3, 2, 1]))) .* ones((nRows + 1)*dRectangle_Padding + nRows*dRectangle_EdgeLength , (nCols + 1)*dRectangle_Padding + nCols*dRectangle_EdgeLength, 3, 'uint8');

% Loop over each color
for iColor = 1:nColors
    % Get column and row index for the linearly indexed color
    [iCur_Col, iCur_Row] = ind2sub([nRows, nCols], iColor);
    
    vRectangle_X = (iCur_Col - 1).*(dRectangle_EdgeLength + dRectangle_Padding) + dRectangle_Padding + ([1, dRectangle_EdgeLength]);
    vRectangle_Y = (iCur_Row - 1).*(dRectangle_EdgeLength + dRectangle_Padding) + dRectangle_Padding + ([1, dRectangle_EdgeLength]);
    
    aImg(vRectangle_X(1):vRectangle_X(end),vRectangle_Y(1):vRectangle_Y(end),1) = aColors(iColor,1).*255;
    aImg(vRectangle_X(1):vRectangle_X(end),vRectangle_Y(1):vRectangle_Y(end),2) = aColors(iColor,2).*255;
    aImg(vRectangle_X(1):vRectangle_X(end),vRectangle_Y(1):vRectangle_Y(end),3) = aColors(iColor,3).*255;
end

% Show the image we created
imshow(permute(aImg, [2, 1, 3]), 'Parent', haTarget, 'Border', 'tight');

% Finally, make sure the figure is drawn
drawnow

% Reset the old hold state if it wasn't set
if ~lOldHold
    hold(haTarget, 'off');
end



%% Assign output quantities
if nargout > 0
    varargout{1} = hPatches;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
