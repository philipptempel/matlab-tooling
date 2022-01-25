function cpfun(src, dst, varargin)
%% CPFUN renames the function to a new name
%
% CPFUN(SOURCE, DESTINATION) copies function SOURCE to TARGET and changes its
% signature.
%
% CPFUN(SOURCE, DESTINATION, 'Name', 'Value', ...) allows setting optional
% inputs using name/value pairs.
%
% Inputs:
%
%   SOURCE              Name of the source function to copy.
%
%   DESTINATION         Destination name of the function. Can be either only a
%                       function name or a full file path. In case of only a
%                       function name, the SOURCE function is copied into the
%                       current working directory. In case of a full file name,
%                       the SOURCE funtion is copied there.
%
% Optional Inputs -- specified as parameter value pairs
%
%   Open                Flag to open file after renaming or not. Possible values
%                       are
%                       'on', 'yes'     Open file in editor after renaming
%                       'off', 'no',    Do not open file in editor after
%                                       renaming
%                       Default: 'off'
%
%   Overwrite           Flag whether to overwrite the target function file if it
%                       already exists.
%                       Default: 'off'
%
% See also:
%   MKFUN CPFUN



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-01-25
% Changelog:
%   2022-01-25
%       * Fix H1 documentation
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-12-13
%       * Initial release



%% Define the input parser
ip = inputParser();

% Require: Filename
valFcn_Old = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Source');
addRequired(ip, 'Source', valFcn_Old);

% Allow custom input argument list
valFcn_New = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Destination');
addRequired(ip, 'Destination', valFcn_New);

% Silent creation i.e., not opening file afterwards
valFcn_Open = @(x) any(validatestring(x, {'on', 'off', 'yes', 'no', 'please', 'never'}, mfilename, 'Open'));
addParameter(ip, 'Open', 'off', valFcn_Open);

% Overwrite: Char. Matches {'on', 'off', 'yes', 'no'}. Defaults 'no';
valFcn_Overwrite = @(x) any(validatestring(x, {'on', 'off', 'yes', 'no'}, mfilename(), 'Overwrite'));
addParameter(ip, 'Overwrite', 'off', valFcn_Overwrite);


% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    % CPFUN(SRC, DST);
    % CPFUN(SRC, DST, 'Name', 'Value', ...);
    narginchk(2, Inf);
    
    % CPFUN(SRC, DST);
    nargoutchk(0, 0);
    
    parse(ip, src, dst, varargin{:});
catch me
    throwAsCaller(me);
end



%% Parse results

% Source function name
src = ip.Results.Source;
% Target function name
dst = ip.Results.Destination;
% Open after rename
lopen = parseswitcharg(ip.Results.Open);
% Overwrite if target exists?
loverwrite = parseswitcharg(ip.Results.Overwrite);



%% Copy the file

% Get the path to the specified function
src_fullpath = which(src);
assert(~isempty(src_fullpath), 'PHILIPPTEMPEL:MATLAB_TOOLING:CPFUN:InvalidFuncName', 'Could not find function %s anywhere in your path', src);

% Get the path parts of the old and new file
[~, src_name, src_ext] = fileparts(src_fullpath);
[dst_path, dst_name, ~] = fileparts(dst);
% Create path parts for the new file
if isempty(dst_path)
  dst_path = pwd();
end
dst_ext = src_ext;

% Find out if the old function is a packaged function, if so, check the new
% function name if its packaged or not and adjust accordingly (fail if there is
% no such new module)

% Create path of new file
dst_fullpath = fullfile(dst_path, [ dst_name , dst_ext ]);

% Read the original file's content
try
    [fid, errmsg] = fopen(src_fullpath);
    if fid < 0
      throw(MException('MATLAB:FileIO:InvalidFid', errmsg));
    end
    
    coClose = onCleanup(@() fclose(fid));
    
    content = fileread(src_fullpath);
    
catch me
    throwAsCaller(me);
end

% Replace the function name
substitutions = {
    src_name        , dst_name        ; ...
    upper(src_name) , upper(dst_name) ; ...
};
nsubstitutions = size(substitutions, 1);

% Replace all placeholders with their respective content
for isub = 1:nsubstitutions
    content = strrep(content, substitutions{isub,1}, substitutions{isub,2});
end

% Save the changed function contents
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
