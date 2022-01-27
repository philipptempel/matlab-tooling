function mvfun(src, dst, varargin)
%% MVFUN renames the function to a new name
%
% MVFUN(SOURCE, DESTINATION) renames function SOURCE to DESTINATION and changes
% its signature.
%
% MVFUN(SOURCE, DESTINATION, 'Name', 'Value', ...) allows setting optional
% inputs using name/value pairs.
%
% Inputs:
%
%   SOURCE              Old name of function. Must be the old name and not the
%                       file name of the function.
%
%   DESTINATION         New name of function. Must be the new name and not the
%                       file name of the function.
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
% Date: 2022-01-27
% Changelog:
%   2022-01-27
%       * Update to use renamed `onoffstate` function instead of
%       `parseswitcharg`
%   2022-01-25
%       * Fix H1 documentation
%   2021-12-14
%       * Update email address of Philipp Tempel
%       * Move To Do section below Changelog
%   2021-12-13
%       * Rename to `MVFUN` to be more consistent with functions like `MKDIR`
%       * Update H1
%       * Internal code beautification and stream-lining, better exception
%       handling and printing
%       * Change signature and rename argument `OLD` to `SOURCE` and `NEW` to
%       `DESTINATION`
%       * Use `NEWLINE()` rather than hard-coded `\r\n` in creating new file's
%       content
%       * Make sure function calls such as `MFILENAME()` are written with
%       parentheses.
%       * Use `FILEREAED` instead of `TEXTSCAN` for file reading when replacing
%       the function name
%       * Update to use new signature of `PARSESWITCHARG`
%   2018-03-03
%       * Change parameter 'silent' to 'open' and change it's default value to
%       'off'
%       * Update H1 with help on name/value-parameters
%   2017-01-10
%       * Add TODO to handle packaged functions
%   2016-12-03
%       * Fix bug that would prevent function name to be replaced if the full
%       filename was given i.e., `mvfun('oldname.m', 'newname.,')` would not
%       have renamed any occurence of `OLDNAME` in the script but only of
%       `OLDNAME.M`
%   2016-11-11
%       * Adjust message identifiers of MExceptions
%       * Replace `in_charToValidArgument` with `parseswitcharg`
%   2016-10-08
%       * Fix bug when file-extension was given in old filename and new file
%       content would be without replaced function name in text inside
%   2016-08-25
%       * Add option 'Silent' to silent renaming i.e., to not open file
%       afterwards
%   2016-08-02
%       * Initial release
% TODO:
%   * Need to be able to handle packaged function names. For the old function
%   name it seems to work, but for the new function name it does (somehow
%   magically, but not really) work.



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
    % MVFUN(SOURCE, DESTINATION);
    % MVFUN(SOURCE, DESTINATION, 'Name', 'Value', ...);
    narginchk(2, Inf);
    
    % MVFUN(SOURCE, DESTINATION);
    nargoutchk(0, 0);
    
    parse(ip, src, dst, varargin{:});
catch me
    throwAsCaller(me);
end



%% Parse results
% Old function name
src = ip.Results.Source;
% New function name
dst = ip.Results.Destination;
% Open after rename
lopen = onoffstate(ip.Results.Open);




%% Rename file
% Get the path to the specified function
src_which = which(src);
assert(~isempty(src_which), 'PHILIPPTEMPEL:MATLAB_TOOLING:MVFUN:InvalidFuncName', 'Could not find function %s anywhere in your path', src);

% Get the path parts of the old and new file
[src_path, src_name, src_ext] = fileparts(src_which);
[dst_path, dst_name, dst_ext] = fileparts(dst);
% Create path parts for the new file
if isempty(dst_path)
  dst_path = src_path;
end
dst_ext = src_ext;

% Find out if the old function is a packaged function, if so, check the new
% function name if its packaged or not and adjust accordingly (fail if there is
% no such new module)

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

% Replace the function name
substitutions = { ...
    src_name        , dst_name        ; ...
    upper(src_name) , upper(dst_name) ; ...
};
nsubstitutions = size(substitutions, 1);

% Replace all placeholders with their respective content
for isub = 1:nsubstitutions
    content = strrep(content, substitutions{isub,1}, substitutions{isub,2});
end

% Save the changed function content
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
