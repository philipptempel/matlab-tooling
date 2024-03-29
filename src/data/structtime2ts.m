function TimeseriesData = structtime2ts(StructWithTime, varargin)
% STRUCTTIME2TS Turn a simulink sink "struct with time" to a timeseries data
% 
%   STRUCTTIME2TS(STRUCTWITHTIME) turns the simulink sink "struct with time"
%   into a timeseries object
%   
%   Inputs:
%   
%   STRUCTWITHTIME: Simulink sink block data as defined as a "structure with
%   time"
%
%   Outputs:
%   
%   TIMESERIESDATA: Timeseries object that contains all the data from
%   STRUCTWITHTIME in its respective containers
%



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2016-07-14
%       * Wrap IP-parse in try-catch to have nicer error display
%   2016-03-30
%       * Initial release



%% Create an input parser
% Input parse to easily parse input arguments
ip = inputParser();

% Required: Structure with Time
valFcn_StructWithTime = @(x) validateattributes(x, {'struct'}, {'nonempty'}, mfilename, 'StructWithTime');
addRequired(ip, 'StructWithTime', valFcn_StructWithTime);

% Configuration for the input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    parse(ip, StructWithTime, varargin{:});
catch me
    throwAsCaller(me);
end


%% Local variables
stSource = ip.Results.StructWithTime;
tsData = timeseries();



%% Magic, do your thing
tsData.Time = stSource.time;
tsData.Data = stSource.signals.values;
tsData.UserData.blockName = stSource.blockName;
tsData.Name = stSource.signals.label;



%% Assign outputs
TimeseriesData = tsData;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
