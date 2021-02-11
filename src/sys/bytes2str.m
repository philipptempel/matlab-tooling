function s = bytes2str(b, varargin)
%% BYTES2STR turns the number of bytes into a human readable string
%
% Inputs:
%
%   B               MxN numeric array of bytes to translate.
%
% Outputs:
%
%   S               MxN char array representing bytes B in the lowest human
%                   readable scale.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-02-11
% Changelog:
%   2021-02-11
%     * Update return value to return a single char array if a single value of
%     bytes was passed
%   2018-02-06
%     * Initial release



%% Define the input parser
ip = inputParser;

% Bytes: numeric; positive
valFcn_Bytes = @(x) validateattributes(x, {'numeric'}, {'positive', 'finite', 'nonnan', 'nonsparse'}, mfilename, 'Bytes');
addRequired(ip, 'Bytes', valFcn_Bytes);

% Format: char; non-empty
valFcn_Format = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Format');
addParameter(ip, 'Format', '%.2f', valFcn_Format);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
  % BYTES2STR(B)
  % BYTES2STR(B, 'Name', 'Value', ...)
  narginchk(1, Inf);
  % BYTES2STR(B)
  % S = BYTES2STR(B)
  nargoutchk(0, 1);
  
  args = [{b}, varargin];
  
  parse(ip, args{:});
  
catch me
  throwAsCaller(me);
  
end



%% Parse IP results
% The vector of bytes to convert
byts = ip.Results.Bytes;
% The format to use for each byte
fmt = ip.Results.Format;

% Run over each element of B and convert it
s = arrayfun(@(bb) in_parsebytes(bb, fmt), byts, 'UniformOutput', false);

% Single argument?
if numel(byts) == 1
  s = s{1};
end



end


function s = in_parsebytes(b, fmt)
%% IN_PARSEBYTES 
%
% IN_PARSEBYTES() Parse a single byte string into the appropriate format.
%
% Inputs:
%
%    B              Scalar byte value.
%
% Outputs:
%
%    FMT            Format to `sprintf` bytes into.
%
% See also:

% Get the scaling factor
scale = floor(log(b)./log(1024));

decimals = 1024 .^ [  0,    1,    2,    3,    4,    5,    6,    7,    8];
metric =           {'b', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'};

if scale == -Inf
  s = 'n/a';
  
else
  scale = min(scale + 1, numel(decimals));
  s = sprintf('%s %s', sprintf(fmt, b ./ decimals(scale)), metric{scale});
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
