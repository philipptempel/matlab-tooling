function mvscrpt(src, dst, varargin)
%% MVSCRPT renames the script to a new name
%
% MVSCRPT(SOURCE, DESTINATION) renames script SOURCE to DESTINATION and changes
% its signature.
%
% MVSCRPT(SOURCE, DESTINATION, 'Name', 'Value', ...) allows setting optional
% inputs using name/value pairs.
%
% Inputs:
%
%   SOURCE              Old name of script. Must be the old name and not the
%                       file name of the script.
%
%   DESTINATION         New name of script. Must be the new name and not the
%                       file name of the script.
%
% Optional Inputs -- specified as parameter value pairs
%
%   Open                Flag to open file after renaming or not. Possible values
%                       are
%                       'on', 'yes'     Open file in editor after renaming
%                       'off', 'no',    Do not open file in editor after
%                                       renaming
%                       Defaults to 'off'.
%
% See also:
%   MKFUN CPFUN



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-01-25
% Changelog:
%   2022-01-25
%       * Initial release as copy from `MVFUN`



%% Define the input parser
ip = inputParser();

% Require: Filename
valFcn_Old = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Source');
addRequired(ip, 'Source', valFcn_Old);

% Allow custom input argument list
valFcn_New = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Destination');
addRequired(ip, 'Destination', valFcn_New);

% Silent creation i.e., not opening file afterwards
valFcn_Open = @(x) any(validatestring(x, {'on', 'off', 'yes', 'no', 'please', 'never'}, mfilename(), 'Open'));
addParameter(ip, 'Open', 'off', valFcn_Open);


% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename();

% Parse the provided inputs
try
    % MVSCRPT(SOURCE, DESTINATION);
    % MVSCRPT(SOURCE, DESTINATION, 'Name', 'Value', ...);
    narginchk(2, Inf);
    
    % MVSCRPT(SOURCE, DESTINATION);
    nargoutchk(0, 0);
    
    parse(ip, src, dst, varargin{:});
catch me
    throwAsCaller(me);
end



%% Parse results
% Old script name
src = ip.Results.Source;
% New script name
dst = ip.Results.Destination;
% Open after rename
lopen = parseswitcharg(ip.Results.Open);




%% Rename file
% Get the path to the specified sript
src_which = which(src);
assert(~isempty(src_which), 'PHILIPPTEMPEL:MATLAB_TOOLING:MVSCRPT:InvalidFuncName', 'Could not find script %s anywhere in your path', src);

% Get the path parts of the old and new file
[src_path, src_name, src_ext] = fileparts(src_which);
[dst_path, dst_name, dst_ext] = fileparts(dst);
% Create path parts for the new file
if isempty(dst_path)
  dst_path = src_path;
end
dst_ext = src_ext;

% Create path of new file
dst_fullpath = fullfile(dst_path, [ dst_name , dst_ext ]);

% Try copying the file
try
    [status, message, messageid] = movefile(src_which, dst_fullpath);
    if status ~= 1
      throw(MException(messageid, message));
    end
catch me
    throwAsCaller(me);
end

% Read the new file's content
try
    [fid, errmsg] = fopen(dst_fullpath);
    if fid < 0
      throw(MException('MATLAB:FileIO:InvalidFid', errmsg));
    end
    coClose = onCleanup(@() fclose(fid));
    
    content = fileread(dst_fullpath);
    
catch me
    throwAsCaller(me);
end

% Replace the script name
substitutions = { ...
    src_name        , dst_name        ; ...
    upper(src_name) , upper(dst_name) ; ...
};
nsubstitutions = size(substitutions, 1);

% Replace all placeholders with their respective content
for isub = 1:nsubstitutions
    content = strrep(content, substitutions{isub,1}, substitutions{isub,2});
end

% Save the changed script content
try
    [fid, errmsg] = fopen(dst_fullpath, 'w+');
    if fid < 0
      throw(MException('MATLAB:FileIO:InvalidFid', errmsg));
    end
    
    coClose = onCleanup(@() fclose(fid));
    
    fprintf(fid, '%s%s', content, newline());
    
catch me
    throwAsCaller(me);
end



%% Assign output quantities

% Open file afterwards?
if lopen == matlab.lang.OnOffSwitchState.on
    edit(dst_fullpath);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
