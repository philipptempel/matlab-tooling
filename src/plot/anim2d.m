function [varargout] = anim2d(X, Y, varargin)
% ANIM2D animates 2-dimensional data over time.
%
%   ANIM2D(X, Y) animates over the first dimension of X and Y the corresponding
%   items in the matrices. The values must be given in absolute X and Y
%   coordinates while there is no limitation on how much data will be plotted.
%   The inputs must follow a specific format for proper rendering. Let X and Y
%   be MxNxP matrices, then the dimensions represent the following information
%       M:  Number of snapshots of the data at different time frames.
%       N:  Number of markers of each plot
%       P:  Number of different plots
%
%   Internally, ANIM2D uses a timer object that is bound to a new or a given
%   axes. The timer is called at specified periods and changes the XData and
%   YData properties of each child plot found in the axes.
%
%   BEWARE: The actual speed of animating your plot largely depends on the
%   amount of data being plotted, the speed of custom callback functions, and
%   the size and resolution of the figure. Small figure windows animate much
%   much more quickly than larger ones.
%
%   ANIM2D(X, Y, T) uses the time T to plot over. By default, 25 frames per
%   second are drawn thus the row of T closest to the current frame's time is
%   used to gather data from. Helpful to animate results of a simulation with a
%   variable step-size solver.
%
%   ANIM2D(X, Y, 'Name', 'Value', ...) plots with additional
%   name/value-arguments.
%
%   Inputs:
%
%   X       MxNxP matrix or MxN matrix of X-data of plots. Defines P lines to be
%           plotted with N nodes over at most M items.
%
%   Y       MxNxP matrix or MxN matrix of Y-data of plots. Defines P lines to be
%           plotted with N nodes over at most M items.
%
%   Optional Inputs -- specified as parameter value pairs
%
%   EvenX           Switch to toggle even x-axis extension 'on' or 'off'. If
%       'EvenX' is 'on' then the by magnitude larger x-axis limit is projected
%       onto the other one. For example, xlims of [-3, 4] will become [-4, 4].
%
%   Fps             Number of frames per second to draw. This values is being
%       used for the timer's period. Defaults to 25.
%
%   Fun             Function to be used for plotting the data. By default,
%       'plot' will be used but this way, 'log' or 'stem' can be used to plot
%       ALL data (line-specific plot functions are not yet supported).
%
%   MarkStart       Switch to mark the first row of the plotted data. This can
%       be useful to e.g., highlight the initial condition. Defaults to 'off'.
%       Can be 'on' or 'off'.
%
%   Output          Char argument representing the name (or path) of a file to
%       write content to. The name/path should contain the correct file
%       type/extension to avoid creation of incorrect files. See also argument
%       'VideoProfile'
%
%   Tag             Cell array of tags that should be assigned to each plot
%   during initial drawing phase.
%
%   Time            Mx1 vector of time values to use. By default, this function
%       iterates over the first dimension of X and Y. If a time vector is given,
%       then the row with the value closest to the current animation time is
%       being used for animation. Additionally, this value is passed to the
%       title of the plot to display the progress.
%
%   Title           String to be displayed in the title. Can be set to 'timer'
%       or 'timer_of' to enable automatic rendering of the time in the
%       axes' title. Can also be set to 'index' or 'index_of', to display the
%       current frame iteration index.
%       If a user-specific string is provided, it will be passed to `sprintf`
%       where the current time is being parsed as first argument, the current
%       frame index as second.
%       If you specify this property using a function handle, when MATLAB
%       executes the callback it passes the axes handle and the current loop
%       index to the callbak function i.e., TitleFcn(ax, idx)
%
%   StartFcn        String or function handle that shall be called after the
%       animation is set up and before it is started.
%       If you specify this property using a string, when MATLAB executes the
%       callback, it evaluates the MATLAB code contained in the string. This
%       code has access to the variables 'ax', 'plt', and 'idx' representing the
%       target axes, the plot object, and the current frame index, respectively.
%       If you specify this property using a function handle, when MATLAB
%       executes the callback it passes the axes handle, the current time step
%       number, and the plot handle to the callback function. If you specify
%       this property as a cell array, you can make combinations of strings or
%       function handles as you like.
%
%   StopFcn         String or function handle that shall be called after the
%       animation has stopped.
%       If you specify this property using a string, when MATLAB executes the
%       callback, it evaluates the MATLAB code contained in the string. This
%       code has access to the variables 'ax', 'plt', and 'idx' representing the
%       target axes, the plot object, and the current frame index, respectively.
%       If you specify this property using a function handle, when MATLAB
%       executes the callback it passes the axes handle, the current time step
%       number, and the plot handle to the callback function. If you specify
%       this property as a cell array, you can make combinations of strings or
%       function handles as you like.
%
%   UpdateFcn       String or function handle that shall be called after the
%       animation is updated at each frame.
%       If you specify this property using a string, when MATLAB executes the
%       callback, it evaluates the MATLAB code contained in the string. This
%       code has access to the variables 'ax', 'plt', and 'idx' representing the
%       target axes, the plot object, and the current frame index, respectively.
%       If you specify this property using a function handle, when MATLAB
%       executes the callback it passes the axes handle, the current time step
%       number, and the plot handle to the callback function. If you specify
%       this property as a cell array, you can make combinations of strings or
%       function handles as you like.
%
%   VideoProfile    Profile to be used to write video file. Must be matching the
%       video file extension/type, otherwise it won't work. Allowed values can
%       be inferred from VideoWriter
%
%   See also
%   TIMER VIDEOWRITER WRITEVIDEO GETFRAME
%
%   KNOWN BUGS:
%   Due to some weird behavior (of feval probably) the order of plots is changed
%       i.e., X(:,:,1) is plot into plt(n) while X(:,:,n) is plot into plt(1).
%       This is a bit unexpected behavior if you want to adjust the lines
%       styles, colors, or markers. However, this behavior cannot be reproduced
%       in standalone code so it is unclear where exactly it is coming from.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Move To Do section below Changelog
%   2021-12-13
%       * Update to new signature of `PARSESWITCHARG`
%   2019-01-07
%       * Fix incorrect property name in validation function of Y.
%       * Fix typos in help section.
%   2018-12-31
%       * Update how the title is being set when 'Title' property is given. Now,
%       it seems to be faster as we are not traversing through the whole axes
%       object but are accessing the title object directly.
%   2018-12-30
%       * Allow passing third argument, time T, simply as a numeric array. If
%       so, the list of variable arguments will expanded accordingly.
%   2018-11-13
%       * Add parameter 'Tag' to allow tagging a single plot so that it can be
%       more easily retrieved in the start, update, or stop callbacks.
%       * Remove ability to pass an object as second argument. Following
%       standard object-oriented approaches, the object should be passed as the
%       first argument (and that will be caught by MATLAB and dispatched
%       properly), while the then second argument may be an axes handle.
%   2018-09-25
%       * Change property 'Frame2Time' of the UserData structure to 'DataIndex'
%       for more clear notation (and also because this function may be used
%       without an reference to time but just looping over data sets.
%       * Properly implement the optional positional argument 'Time' to also be
%       a name/value paired argument. Now, ANIM2D(X, Y, T, ...) and
%       ANIM2D(X, Y, 'Time', T, ...) both produce the same result.
%   2018-09-24
%       * Change arguments passed to TitleFcn. Title callbacks must now take the
%       arguments (ax, idx) where ax is the current axes handle and idx is the
%       current zero-based execution counter.
%       * Change order of execution of user-supplied StartFcn and UpdateFcn as
%       well as TitleFcn. The TitleFcn now is run after all plot data has been
%       updated i.e., after any call to StartFcn or UpdateFcn, respectivel.y
%       * Add options 'index' and 'index_of' to parameter 'Title' which will
%       display the current index number.
%   2018-02-17
%       * Ensure figure is visible after the function has been called. Prior to
%       now, the figure was made visible once the timer started which wasn't
%       very convenient or to-be-expected
%   2017-10-18
%       * Fix error when a time vector was given that spans less time than fit
%       in between frames. Now the time to frame mapping will be such that the
%       first and last time step are used
%   2017-09-07
%       * Change checking of name/value pair 'timer' to be case insensitive
%   2017-09-03
%       * Add option 'timer_of' to parameter 'Title' which will also display the
%       maximum time of animation
%   2017-08-05
%       * Fix incorrect validation of 'VideoProfile' argument
%       * Add input parser option to add 'VideoWriter' options to override them
%       by the user
%   2017-08-02:
%       * Update check for too-narrow axes: now compares difference of lower
%       and upper axes boundaries against eps
%   2017-08-01
%       * Fix error with axes assigment when calling anim2d on an object that
%       overrides the method
%   2017-05-18
%       * Update handling of objects being passed to anim2d in combination with
%       a user-given axes handle
%   2017-05-17
%       * Make sure figures are non-resizable if there is an active video export
%   2017-05-16
%       * Fix bug when no explicit title was set on the plot causing MATLAB to
%       state that "The statement is incomplete" without any further display.
%       Now, the axes can have no title and it will run perfectly (even though I
%       recommend setting the title to at least the value 'timer' so that you
%       can see the progress
%       * Add argument 'Output' and 'VideoProfile' to export the axes frame to.
%       This can come in very handy when creating visualizations for scientific
%       results
%       * Change call order in start function so that, if the start should be
%       marked, this will be done BEFORE any user-given callbacks are executed
%       * Remove `axis 'equal'` from code because that should be up to the user
%       to decide how they want their axes ratio
%   2017-03-14
%       * Remove name/value pair 'Axes'
%       * Add support for calling with `anim2d` on a custom axes with an object
%       that implements its own anim2d function
%   2017-03-05
%       * Fix argument parsing to now support an array of axes to be passed as
%       the first argument. This also makes the argument parsing of the IP
%       instance more robust
%       * Generally improve argument parsing to catch more unwanted input
%       arguments
%   2017-01-21
%       * Fix DeleteFcn callback on axes not working properly. Now, when the
%       figure with the axes is being closed/deleted, this axes timer will be
%       stopped and deleted
%       * Add option 'Axis' as explicit option
%   2017-01-14
%       * Fix double error when closing a running animation by removing deleting
%       the timer object when it is being stopped. This now also allows for
%       continuing the timer once it has been stopped
%       * Slight little bit of code cleanup
%   2016-11-13
%       * Remove need for X and Y to be finite. Now, `animd2d` supports plotting
%       of differently sized plots e.g., two lines with 10 plot points and one
%       line with length of 14. Just set the values that should not be plotted
%       to `NaN` and the plotting command will handle the rest (the plot
%       commands by default do not plot values of NaN)
%   2016-10-14
%       * Fix wrong name/value pair description in help
%       * Fix error when removing field `Timer` in timer end callback
%   2016-09-21
%       * Update 'StartFcn', 'UpdateFcn', and 'StopFcn' to support cell arrays
%       of function handles. This way, multiple functions can be called at the
%       same time (for as long as cellfun is "at the same time") allowing better
%       anonymous function inclusion
%       * Add support for displaying a title on the axes
%       * Add support for automatically displaying the initial state with dashed
%       lines
%   2016-09-18
%       * Change order of arguments for StartFcn, StopFcn, UpdateFcn from
%       (ax,idx,plt) to (ax,plt,idx)
%   2016-09-17
%       * Initial release
% TODO:
%   * Line-specific plot-functions like 'plot' for 1:3, and 'stem' for 4:6'
%   * Resample time vector such that it explictly matches the FPS value. Right
%   now, if there are animation values for e.g., t in [0, 2.3, 5]s, then the
%   animation (and timer title) will "freeze" during 0s and 2.3s as there is no
%   data drawn => Title should at least update



%% Assert arguments
narginchk(2, Inf);
nargoutchk(0, 1);



%% Define the input parser
ip = inputParser;

% Parse the provided inputs
args = [{X}, {Y}, varargin];
[haTarget, args, nargs] = axescheck(args{:});

% Check if the third argument is a string or a vector. If it's a vector we
% assume it to be the value of the name/value parameter 'Time'.
if nargs > 2 && isnumeric(args{3}) && isvector(args{3})
  args = [args(1:2), 'Time', args(3:end)];
end

try
  % Required: X. Numeric. Matrix; Non-empty; Columns matches columns of
  % Y;
  valFcn_X = @(x) validateattributes(x, {'numeric'}, {'3d', 'nonempty', 'size', size(args{2})}, mfilename, 'X');
  addRequired(ip, 'X', valFcn_X);

  % Required: Y. Numeric. Matrix; Non-empty; Columns matches columns of
  % X;
  valFcn_Y = @(x) validateattributes(x, {'numeric'}, {'3d', 'nonempty', 'size', size(args{1})}, mfilename, 'Y');
  addRequired(ip, 'Y', valFcn_Y);

  % Parameter: Time. Numeric. Vector; Non-empty; Increasing; Numel matches
  % numel X and Y;
  valFcn_Time = @(x) validateattributes(x, {'numeric'}, {'nonempty', 'vector', 'increasing', 'finite', 'numel', size(args{1}, 1)}, mfilename, 'Time');
  addParameter(ip, 'Time', [], valFcn_Time);

  % Parameter: Axes. Handle. Non-empty
  valFcn_Axes = @(x) validateattributes(x, {'matlab.graphics.axis.Axes'}, {'nonempty', 'vector'}, mfilename, 'Axes');
  addParameter(ip, 'Axes', [], valFcn_Axes);

  % Parameter: EvenX. Char. Matches {'on', 'off', 'yes' 'no'}.
  valFcn_EvenX = @(x) any(validatestring(lower(x), {'on', 'yes', 'off', 'no'}, mfilename, 'EvenX'));
  addParameter(ip, 'EvenX', 'off', valFcn_EvenX);

  % Parameter: Output. Char. Non-empty
  valFcn_Output = @(x) validateattributes(x, {'char', 'nonempty'}, {'nonempty'}, mfilename, 'Output');
  addParameter(ip, 'Output', '', valFcn_Output);

  % Parameter: FPS. Numeric. Non-empty; Scalar; Positive; Finite;
  valFcn_Fps = @(x) validateattributes(x, {'numeric'}, {'nonempty', 'scalar', 'positive', 'finite', 'nonsparse'}, mfilename, 'Fps');
  addParameter(ip, 'Fps', 25, valFcn_Fps);

  % Parameter: Fun. Char; Function Handle. Non-empty;
  valFcn_Fun = @(x) validateattributes(x, {'char', 'cell', 'function_handle'}, {'nonempty'}, mfilename, 'Fun');
  addParameter(ip, 'Fun', @plot, valFcn_Fun);

  % Parameter: MarkStart. Char. Matches {'on', 'off', 'yes' 'no'}.
  valFcn_MarkStart = @(x) any(validatestring(lower(x), {'on', 'yes', 'off', 'no'}, mfilename, 'MarkStart'));
  addParameter(ip, 'MarkStart', 'off', valFcn_MarkStart);

  % Parameter: StartFcn. Charl Function Handle. Non-empty;
  valFcn_StartFcn = @(x) validateattributes(x, {'char', 'cell', 'function_handle'}, {'nonempty'}, mfilename, 'StartFcn');
  addParameter(ip, 'StartFcn', {}, valFcn_StartFcn);

  % Parameter: StopFcn. Char; Function Handle. Non-empty;
  valFcn_StopFcn = @(x) validateattributes(x, {'char', 'cell', 'function_handle'}, {'nonempty'}, mfilename, 'StopFcn');
  addParameter(ip, 'StopFcn', {}, valFcn_StopFcn);

  % Parameter: Tag. Cell;
  valFcn_Tag = @(x) validateattributes(x, {'cell'}, {'nonempty', 'numel', size(args{1}, 3)}, mfilename, 'Tag');
  addParameter(ip, 'Tag', {}, valFcn_Tag);

  % Parameter: Title. Char; Function Handle. Non-empty;
  valFcn_Title = @(x) validateattributes(x, {'char', 'function_handle'}, {'nonempty'}, mfilename, 'Title');
  addParameter(ip, 'Title', '', valFcn_Title);

  % Parameter: UpdateFcn. Char. Function Handle. Non-empty;
  valFcn_UpdateFcn = @(x) validateattributes(x, {'char', 'cell', 'function_handle'}, {'nonempty'}, mfilename, 'UpdateFcn');
  addParameter(ip, 'UpdateFcn', {}, valFcn_UpdateFcn);

  % Parameter: VideoProfile. Char. Non-empty;
  valFcn_VideoProfile = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'VideoProfile');
  addParameter(ip, 'VideoProfile', 'Motion JPEG AVI', valFcn_VideoProfile);

  % Parameter: VideoWriter. Cell. Non-empty;
  valFcn_VideoWriter = @(x) validateattributes(x, {'cell'}, {'nonempty'}, mfilename, 'VideoWriter');
  addParameter(ip, 'VideoWriter', {}, valFcn_VideoWriter);

  % Configuration of input parser
  ip.KeepUnmatched = true;
  ip.FunctionName = mfilename;

  parse(ip, args{:});
catch me
  throwAsCaller(me);
end



%% Parse IP results
% Matrix of X-data
aXData = ip.Results.X;
% Matrix of Y-data
aYData = ip.Results.Y;
% Number of data plots
nData = size(aXData, 3);
% Vector of time
vTime = ip.Results.Time;
% If time is empty, we will just loop over the samples of X and Y
if isempty(vTime)
  vTime = 1:size(aXData,1);
  loLoopTime = false;
else
  loLoopTime = true;
end
% Frames per second
nFps = ip.Results.Fps;
% Custom plot functions
mxFun = ip.Results.Fun;
if numel(mxFun) == 1
  mxFun = repmat({mxFun}, 1, size(aXData, 3));
end

% Get start function callback handle
try
  ceStartCallbacks = in_parseCallbacks(ip.Results.StartFcn, 'StartFcn');
catch me
  throwAsCaller(me);
end

% Get update function callback handle
try
  ceUpdateCallbacks = in_parseCallbacks(ip.Results.UpdateFcn, 'UpdateFcn');
catch me
  throwAsCaller(me);
end

% Get start function callback handle
try
  ceStopCallbacks = in_parseCallbacks(ip.Results.StopFcn, 'StopFcn');
catch me
  throwAsCaller(me);
end

% Get filename for output (if given)
chOutputFile = ip.Results.Output;
% Write to file?
loFileOutput = ~isempty(chOutputFile);
% Profile of the video
chVideoProfile = ip.Results.VideoProfile;
% Videowriter options
ceVideoWriter = ip.Results.VideoWriter;

% Even x-axis?
chEvenX = parseswitcharg(ip.Results.EvenX);
% Title of the axes
mxTitle = ip.Results.Title;
% Tags of plots
ceTags = ip.Results.Tag;
% Mark start?
chMarkStart = parseswitcharg(ip.Results.MarkStart);
% Get a valid axes handle
if ~isempty(ip.Results.Axes)
  haTarget = ip.Results.Axes;
end
loHideAxes = isempty(haTarget);
haTarget = newplot(haTarget);
if loHideAxes
  hfFigure = gpf(haTarget);
  hfFigure.Visible = 'off';
end



%% Create all data
% Collect all data we need into one struct that we will assign to the axes
stUserData = struct();
stUserData.DataCount = nData;
stUserData.EvenX = chEvenX;
stUserData.File = chOutputFile;
stUserData.Fun = mxFun;
stUserData.InitialPlot = [];
stUserData.MarkStart = chMarkStart;
stUserData.StartFcn = ceStartCallbacks;
stUserData.StopFcn = ceStopCallbacks;
stUserData.Tag = ceTags;
stUserData.Time = vTime;
stUserData.TitleFcn = '';
% Parse function handles as title
if isa(mxTitle, 'function_handle')
  stUserData.TitleFcn = mxTitle;
% Parse 'timer' as axes title
else
  switch mxTitle
  case 'timer'
    stUserData.TitleFcn = @(ax, idx) sprintf('Time: %.2fs', ax.UserData.Time(ax.UserData.DataIndex( idx*(idx > 0) + (idx == 0) )));
  case 'timer_of'
%       stUserData.TitleFcn = @(ax, idx) num2str(idx);
    stUserData.TitleFcn = @(ax, idx) sprintf('Time: %.2fs/%.2fs', ax.UserData.Time(ax.UserData.DataIndex( idx*(idx > 0) + (idx == 0) )), ax.UserData.Time(ax.UserData.DataIndex(end)));
  case 'index'
    stUserData.TitleFcn = @(ax, idx) sprintf('Index: %g', idx);
  case 'index_of'
    stUserData.TitleFcn = @(ax, idx) sprintf('Index: %g/%g', idx, ax.UserData.Time(end));
  otherwise
    if ~isempty(mxTitle)
      stUserData.TitleFcn = @(ax, idx) eval(mxTitle);
    else
      stUserData.TitleFcn = [];
    end
  end
end
stUserData.UpdateFcn = ceUpdateCallbacks;
stUserData.VideoObject = [];
stUserData.WriteFile = loFileOutput;
stUserData.XData = aXData;
stUserData.YData = aYData;

% Create a video writer object if the output should be sent to a file
if loFileOutput
  try
      % Create a video writer object
      stUserData.VideoObject = VideoWriter(chOutputFile, chVideoProfile);

      % Set the frame rate
      stUserData.VideoObject.FrameRate = nFps;

      % Set video quality for some video profiles
      if any(strcmpi({'MPEG-4', 'Motion JPEG AVI'}, chVideoProfile))
          % Set the quality of the video
          stUserData.VideoObject.Quality = 100;
      end

      % Set custom video writer options?
      if ~isempty(ceVideoWriter)
          try
              nVideoWriterOpts = lower(numel(ceVideoWriter)/2);

              for iOpt = 1:2:nVideoWriterOpts
                  stUserData.VideoObject.(ceVideoWriter{iOpt}) = ceVideoWriter{iOpt + 1};
              end
          catch me
              warning(me.identifier, me.message);
          end
      end

      % Try to open the video file for writing
      open(stUserData.VideoObject)
  catch me
      throwAsCaller(addCause(MException('PHILIPPTEMPEL:MATLABTOOLING:ANIM2D:ErrorOpeningVideoFile', 'Error opening video file at %s.', escapepath(chOutputFile)), me));
  end

  % We know we are writing to a file and have a valid video writer object, so
  % now we will create the callbacks that will extract the current frame and
  % pass it to the video writer
  stUserData.StartFcn{end+1} = @cb_start_writeVideo;
  stUserData.UpdateFcn{end+1} = @cb_update_writeVideo;
  stUserData.StopFcn{end+1} = @cb_stop_writeVideo;
end

% If we loop over the items and draw them one by one, the mapping of frame
% to time is simple:
stUserData.DataIndex = stUserData.Time;

% Time is given explicitely, so we need to find out what time index each
% frame corresponds to
if loLoopTime
  % Number of frames equals end of animation time multiplied by number of
  % frames
  nFrames = fix(vTime(end)*nFps);
  % The time stamp assigned to each frame
  vFrameTime = ((1:nFrames) - 1)/nFps;
  % If no time cannot be found because the given final time is less than the
  % first frame, we will display at least the first frame
  if isempty(vFrameTime)
      vFrameTime = 0;
  end
  % If the last frame does not represent the last snapshot of time, we
  % will append this one
  if vFrameTime(end) ~= vTime(end)
      vFrameTime(end+1) = vTime(end);
  end
  % Now, find the time index closest to each frame's time
  vDataIndex = zeros(numel(vFrameTime) - 1, 1);
  for iFrame = 1:nFrames
      vDataIndex(iFrame) = closest(vTime, vFrameTime(iFrame));
  end
  if vDataIndex(end) ~= numel(vTime)
      vDataIndex(end+1) = numel(vTime);
  end
  % And move the time correctly
  stUserData.DataIndex = vDataIndex;
end

% Store the axes parent figure locally so we can access it further down, too,
% e.g., during starting the animation or during exporting a video
stUserData.Figure = gpf(haTarget);

% Assign our user data to the axes
haTarget.UserData = stUserData;

% Create a timer object
tiUpdater = timer(...
  'ExecutionMode', 'fixedDelay' ...
  , 'Period', round(1000/nFps)/1000 ... % Just doing this so we don't get a warning about milliseconds being striped
  , 'StartDelay', 1 ... % Just so that the StartFcn can actually change the drawing
  , 'StartFcn', @(timer, event) cb_timerstart(haTarget, timer, event) ...
  , 'StopFcn', @(timer, event) cb_timerend(haTarget, timer, event)...
  , 'TimerFcn', @(timer, event) cb_timerupdate(haTarget, timer, event) ...
  , 'TasksToExecute', numel(stUserData.DataIndex) ... % Execute only as often as we have samples
);

% Create a close function on the current axis
% haTarget.DeleteFcn = @cb_cleanup;
% haTarget.DeleteFcn = 'disp(''hello world'')';
hfFigure = gpf(haTarget);
hfFigure.DeleteFcn = {@cb_cleanup, haTarget};

% Set the title object, if a title function callback exists
if ~isempty(stUserData.TitleFcn)
    haTarget.UserData.Title = title(haTarget, haTarget.UserData.TitleFcn(haTarget, 0));
else
    haTarget.UserData.Title = [];
end

% Add the timer to the axes, too
haTarget.UserData.Timer = tiUpdater;

% Finally, make the figure visible (even though it will be empty)
hfFigure.Visible = 'on';



%% Assign outputs
% If no return arguments are wanted
if nargout == 0
  % Start the timer
  start(tiUpdater)
end

% If return arguments are wanted, this function will return the timer so the
% user can/must start it manually
if nargout > 0
  varargout{1} = tiUpdater;
end


end


function cb_timerstart(ax, timer, event)
%% CB_TIMERSTART


% Don't do anything if the axes is not a valid handle
if ~ishandle(ax)
  return
end

try 
  % Make the axes' figure visible again (it might have been made invisible if
  % a new axes was created by calling this function)
  ax.UserData.Figure.Visible = 'on';

  % Get the current axes' user data
  stUserData = ax.UserData;
  
  % Add to axes
  hold(ax, 'on');

  % Plot the first row of data
  arrayfun(@(iP) feval(stUserData.Fun{iP}, ax, squeeze(stUserData.XData(1,:,iP)), squeeze(stUserData.YData(1,:,iP))), 1:stUserData.DataCount);
  
  % Done adding to axes
  hold(ax, 'off');
  
  % Process tags?
  if ~isempty(stUserData.Tag)
    [ax.Children.Tag] = deal(stUserData.Tag{:});
  end

  % And save the user data back into it
  ax.UserData = stUserData;

  % Get the limits and fallback values
  vXLim = [min(min(min(ax.UserData.XData))), max(max(max(ax.UserData.XData)))];
  vYLim = [min(min(min(ax.UserData.YData))), max(max(max(ax.UserData.YData)))];
  % If no x-axis limits are given, we wil make some of our own
  if abs( vXLim(1) - vXLim(2) ) <= 10*eps
      vXLim = vXLim + [-1, +1];
  end
  % If no Y-axis limits are given, we will make some of our own
  if abs( vYLim(1) - vYLim(2) ) <= 10*eps
      vYLim = vYLim + [-1, +1];
  end

  % Force even x-axis limits?
  if ax.UserData.EvenX == matlab.lang.OnOffSwitchState.on
      vXLim = max(abs(vXLim)).*[-1, 1];
  end
  
  % Update limits
  try
      xlim(ax, vXLim);
      ylim(ax, vYLim);
  catch me
      display(me.message);
  end

  % Mark the initial plot?
  if stUserData.MarkStart == matlab.lang.OnOffSwitchState.on
      % Copy the plot objects quickly
      stUserData.InitialPlot = copyobj(ax.Children, ax);
      % Adjust all 'initial state' objects to be dashed lines
      set(ax.Children((stUserData.DataCount + 1):end), 'LineStyle', '--');
  end

  % Call the user supplied start callback(s) (we do not rely on cellfun as we
  % do not know in what order the functions will be executed and the user
  % might want to have their callbacks executed in a particular order).
  % 
  % @see
  % http://stackoverflow.com/questions/558478/how-to-execute-multiple-statements-in-a-matlab-anonymous-function#558868
  for iSF = 1:numel(ax.UserData.StartFcn)
      ax.UserData.StartFcn{iSF}(ax, ax.Children(1:ax.UserData.DataCount), timer.TasksExecuted);
  end

  % Update figure
  drawnow limitrate
catch me
  stop(timer)

  throwAsCaller(addCause(me, MException('PHILIPPTEMPEL:MATLAB_TOOLING:ANIM2D:AnimationStartFailed', 'Starting of animation failed.')));
end

% That's it for the start

end


function cb_timerupdate(ax, timer, event)
%% CB_TIMERUPDATE


% Don't do anything if the axes is not a valid handle
if ~ishandle(ax)
  return
end

try
  % Update the XData and YData of each of the children but only over the
  % data we have (this way we won't be looping of possible start or end
  % plots of the data)`
  for iChild = 1:ax.UserData.DataCount
      set(ax.Children(iChild) ...
          , 'XData', squeeze(ax.UserData.XData(ax.UserData.DataIndex(timer.TasksExecuted),:,iChild)) ...
          , 'YData', squeeze(ax.UserData.YData(ax.UserData.DataIndex(timer.TasksExecuted),:,iChild)) ...
      );
  end

  % Call the user supplied update callback(s)
  for iSF = 1:numel(ax.UserData.UpdateFcn)
      ax.UserData.UpdateFcn{iSF}(ax, ax.Children(1:ax.UserData.DataCount), timer.TasksExecuted);
  end

  % Update the title, if it previously was set and if there is a callback
  if ~isempty(ax.UserData.Title)
      ax.UserData.Title.String = ax.UserData.TitleFcn(ax, timer.TasksExecuted);
  end

  % Update figure
  drawnow limitrate
catch me
  stop(timer)

  throwAsCaller(addCause(me, MException('PHILIPPTEMPEL:MATLAB_TOOLING:ANIM2D:AnimationUpdateFailed', 'Update of animation failed at time step %i.', timer.TasksExecuted)));
end

end


function cb_timerend(ax, timer, event)
%% CB_TIMEREND


% Don't do anything if the axes is not a valid handle
if ~ishandle(ax)
  return
end

try
  % Call the user supplied end/stop callbacks
  for iSF = 1:numel(ax.UserData.StopFcn)
      ax.UserData.StopFcn{iSF}(ax, ax.Children(1:ax.UserData.DataCount), timer.TasksExecuted);
  end

  % Update figure
  drawnow limitrate

  % Let go off our axes
  hold(ax, 'off');
catch me
  throwAsCaller(addCause(me, MException('PHILIPPTEMPEL:MATLAB_TOOLING:ANIM2D:AnimationStopFailed', 'Stopping of animation failed.')));
end

end


function cb_cleanup(ax, ~, hax)
%% CB_CLEANUP


% Default third argument
if nargin < 3
  hax = [];
end

% If there is a third argument, this function is called from the axes parent's
% DeleteFcn, so the actual axes is passed as the third argument
if ~isempty(hax)
  ax = hax;
end

% Don't do anything if the axes is not a valid handle
if ~ishandle(ax)
  return
end

% If the timer exists in the axes and is running, we will stop it
if isfield(ax.UserData, 'Timer') && strcmp('on', ax.UserData.Timer.Running)
  stop(ax.UserData.Timer);

  delete(ax.UserData.Timer);
end

end


function ceCallbacks = in_parseCallbacks(ceCallbackArgs, Type)
%% IN_PARSECALLBACKS

% Default start callback: empty/does nothing
ceCallbacks = {};

if ~isempty(ceCallbackArgs)
  ceCallbacks = cell(size(ceCallbackArgs));
  % If given as a cell...
  if iscell(ceCallbackArgs)
      % Loop over every callback and check its a char or function_handle;
      for iFh = 1:numel(ceCallbackArgs)
          if ~ ( ischar(ceCallbackArgs{iFh}) || isa(ceCallbackArgs{iFh}, 'function_handle') )
              throwAsCaller(MException('PHILIPPTEMPEL:MATLAB_TOOLING:ANIM2D:InvalidStartFcn', 'All %s callbacks must be char or function_handle.', Type));
          end

          % Convert char functions to actual callable functions
          if ischar(ceCallbackArgs{iFh})
              ceCallbacks{iFh} = @(ax, plt, idx) eval(ceCallbackArgs{iFh});
          % Move function_handles right to the return value
          else
              ceCallbacks{iFh} = ceCallbackArgs{iFh};
          end
      end
  % Not a cell, then make it one
  else
      ceCallbacks = {ceCallbackArgs};
  end
end

end


function cb_start_writeVideo(ax, ~, ~)
%% CB_START_WRITEVIDEO sets the figure resize option to 'off'


try
  ax.UserData.Figure.Resize = 'off';
catch me
  warning(me.message, me.identifier);
end

end


function cb_update_writeVideo(ax, plt, idx)
%% IN_UPDATECALLBACK_WRITEVIDEO writes the current frame to the video object


% Write the current frame to the video object
try
  writeVideo(ax.UserData.VideoObject, getframe(ax.UserData.Figure));
catch me
  warning(me.message, me.identifier);
end

end


function cb_stop_writeVideo(ax, plt, idx)
%% IN_STOPCALLBACK_WRITEVIDEO closes the video object


try
  close(ax.UserData.VideoObject);
catch me
  warning(me.message, me.identifier);
end

end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
