function mkscrpt(sname, varargin)
%% MKSCRPT creates a new script file based on a template
%
% MKSCRPT(NAME) creates script NAME into a new file at the specified target. It
% will not have any input or return arguments pre-defined.
%
% MKSCRPT(___, Name, Value) allows passing additional inputs as Name/Value
% pairs.
%
% Inputs:
%
%   NAME                Name of the script. Can also be a fully qualified file
%                       name from which the script name will then be extracted.
%                       Script name given will be converted to valid MATLAB
%                       script names before being processed. See
%                       MATLAB.LANG.MAKEVALIDNAME for more info.
%
% Optional Inputs -- specified as parameter value pairs
%
%   Author              Author string to be set. Most preferable you will  use
%                       something like
%                       'Firstname Lastname <author-email@example.com>'
%   
%   Description         Description of script which is usually the first line
%                       after the script declaration and contains the script
%                       name in all caps.
%
%   Overwrite           Flag whether to overwrite the target script file if it
%                       already exists.
%                       Default: 'off'
%
%   Template            Path to a template file that should be used instead of
%                       the default found in this script's directory.
%                       Default: 'scripttemplate.mtpl'
%
% See also:
%   MATLAB.LANG.MAKEVALIDNAME MVSCRPT CPSCRPT



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-01-25
% Changelog:
%   2022-01-25
%       * Initial release as copy from `MKFUN`



%% Define the input parser
ip = inputParser();

% Require: Filename
valFcn_Name = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Name');
addRequired(ip, 'Name', valFcn_Name);

% Author: Char. Non-empty
valFcn_Author = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Author');
addParameter(ip, 'Author', 'Philipp Tempel <philipp.tempel@ls2n.fr>', valFcn_Author);

% Description: Char. Non-empty
valFcn_Description = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Description');
addParameter(ip, 'Description', '', valFcn_Description);

% Overwrite: Char. Matches {'on', 'off', 'yes', 'no'}. Defaults 'no';
valFcn_Overwrite = @(x) any(validatestring(x, {'on', 'off', 'yes', 'no'}, mfilename(), 'Overwrite'));
addParameter(ip, 'Overwrite', 'off', valFcn_Overwrite);

% A package name may also be provided
valFcn_Package = @(x) validateattributes(x, {'char'}, {}, mfilename(), 'Package');
addParameter(ip, 'Package', '', valFcn_Package);

% Silent: Char. Matches {'on', 'off', 'yes', 'no'}. Defaults 'off'
valFcn_Silent = @(x) any(validatestring(x, {'on', 'off', 'yes', 'no'}, mfilename(), 'Silent'));
addParameter(ip, 'Silent', 'off', valFcn_Silent);

% Template: Char; non-empty
valFcn_Template = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Template');
addParameter(ip, 'Template', '', valFcn_Template);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    % MKSCRPT(NAME)
    % MKSCRPT(NAME, 'Name', 'Value', ...)
    narginchk(1, Inf);
    
    % MKSCRPT(...)
    nargoutchk(0, 0);
    
    parse(ip, sname, varargin{:});
catch me
    throwAsCaller(me);
end



%% Parse results
% Script name/path
sname = matlab.lang.makeValidName(ip.Results.Name);
% Get script path, file name, and extension
[scrpt_path, scrpt_name, scrpt_ext] = fileparts(sname);
% Empty filepath?
if isempty(scrpt_path)
    % Save in the current working directory
    scrpt_path = pwd();
end
% Empty file extension?
if isempty(scrpt_ext)
    % Ensure we'll save as '.m' file
    scrpt_ext = '.m';
end
% Description text
description = ip.Results.Description;
% Author name
author = ip.Results.Author;
% Silent creation?
lsilent = parseswitcharg(ip.Results.Silent);
% Overwrite existing?
loverwrite = parseswitcharg(ip.Results.Overwrite);
% Path to template file
template = ip.Results.Template;
% Package name
package = ip.Results.Package;

%%% Local variables
% No templtae file given?
if isempty(template)
    % Check if a template for this script name exists
    if 2 == exist(sprintf('%s.mtpl', scrpt_name), 'file')
        % Get the fully qualified file path to the script template name
        template = which(sprintf('%s.mtpl', scrpt_name));
    else
        % Then use the default script template
        template = fullfile(fileparts(mfilename('fullpath')), 'scripttemplate.mtpl');
    end
end

% Date of creation of the file
chDate = datestr(now, 'yyyy-mm-dd');

% Parse package name
if ~isempty(package)
    % Split package name as string into package parts
    cePackage = strsplit(package, '.');
    % Merge package name components back into a string with '/+' as separator
    package = strjoin(cePackage, '/+');
    % Prepend a last missing package indicator in front of the first package name
    package = ['+' , package];
    % Append to file path
    scrpt_path = fullfile(scrpt_path, package);
end
% Lastly, add file name to file path
fun_fullpath = fullfile(scrpt_path, [ scrpt_name , scrpt_ext ]);



%% Assert variables

% % Assert we have a valid script template filepath
% assert(2 == exist(chTemplateFilepath, 'file'), 'PHILIPPTEMPEL:MATLAB_TOOLING:MKSCRPT:functionTemplateNotFound', 'Function template cannot be found at %s.', chTemplateFilepath);
% Assert the target file does not exist yet
assert(2 == exist(fun_fullpath, 'file') && loverwrite == matlab.lang.OnOffSwitchState.on || 0 == exist(fun_fullpath, 'file'), 'PHILIPPTEMPEL:MKSCRPT:ScriptExists', 'Script already exists. Will not overwrite unless forced to do so.');



%% Create the file contents

% Read the file template
try
    [fid, errmsg] = fopen(template);
    if fid < 0
      throw(MException('MATLAB:FileIO:InvalidFid', errmsg));
    end
    coClose = onCleanup(@() fclose(fid));
    content = fileread(template);
%     content = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
%     content = content{1};
    ncontent = numel(content);
    
catch me
    throwAsCaller(me);
end

% Description string
description = in_createDescription(description);

% Define the set of placeholders to replace here
substitutions = {...
    'SCRIPT'          , scrpt_name          ; ...
    'SCRIPT_UPPER'    , upper(scrpt_name)   ; ...
    'DESCRIPTION'     , description       ; ...
    'AUTHOR'          , author            ; ...
    'DATE'            , chDate            ; ...
};
nsubstitutions = size(substitutions, 1);

% Replace all placeholders with their respective content
for isub = 1:nsubstitutions
    content = strrep(content, [ '{{' , substitutions{isub,1} , '}}' ], substitutions{isub,2});
end


% Save the file
try
  % Make target directory
    if 7 ~= exist(scrpt_path, 'dir')
        [status, errmsg, errid] = mkdir(scrpt_path);
        if status ~= 1
            throw(MException(errid, errmsg));
        end
    end
    
    [fid, errmsg] = fopen(fun_fullpath, 'w+');
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
if lsilent == matlab.lang.OnOffSwitchState.off
    open(fun_fullpath);
end


end


function description = in_createDescription(description)
%% IN_CREATEDESCRIPTION
%
% DESCRIPTION = IN_CREATEDESCRIPTION(DESCRIPTION)





end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
