function s = time2str(d, varargin)
%% TIME2STR turns a duration in seconds into a human readable string
%
%   Inputs:
%
%   D                   MxN numeric array of durations to translate.
%
%   Outputs:
%
%   S                   MxN char array representing durations D in the lowest
%                       human readable scale.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-07-02
% Changelog:
%   2021-07-02
%       * Change validation of argument `D` to allow also zero as value
%   2021-02-11
%       * Initial release



%% Define the input parser
ip = inputParser;

% Duration: numeric; positive
valFcn_Duration = @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'finite', 'nonnan', 'nonsparse'}, mfilename, 'Duration');
addRequired(ip, 'Duration', valFcn_Duration);

% Format: char; non-empty
valFcn_Format = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Format');
addParameter(ip, 'Format', '%.2f', valFcn_Format);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
  % TIME2STR(B)
  % TIME2STR(B, 'Name', 'Value', ...)
  narginchk(1, Inf);
  % TIME2STR(B)
  % S = TIME2STR(B)
  nargoutchk(0, 1);
  
  args = [{d}, varargin];
  
  parse(ip, args{:});
catch me
  throwAsCaller(me);
end



%% Parse IP results
% The vector of durations to convert
durs = ip.Results.Duration;
% The format to use for each byte
fmt = ip.Results.Format;

% Run over each element of B and convert it
s = arrayfun(@(dur) in_parseduration(dur, fmt), durs, 'UniformOutput', false);

if numel(durs) == 1
  s = s{1};
end


end


function s = in_parseduration(d, fmt)

secs = 1;
mins = 60 * secs;
hours = 60 * mins;
days = 24 * hours;
weeks = 7 * days;
months = 30.471 * days;
years = 365.26 * days;
millennia = 1000 * years;

factors = [10 .^ (-24:3:0), mins, hours, days, weeks, months, years, millennia];
metric = {'ys', 'zs', 'as', 'fs', 'ps', 'ns', 'mus', 'ms', 's', 'min', 'hr', 'd', 'w', 'a', 'ka'};

% Get the scaling factor
scls = d ./ factors;

idx = find(1 <= scls & scls < 1e3, 1, 'last');
if isempty(idx)
  idx = 9;
end

s = [sprintf(fmt, d ./ factors(idx)) , ' ' , metric{idx}];

end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
