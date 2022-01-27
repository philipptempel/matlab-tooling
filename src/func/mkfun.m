function mkfun(fname, varargin)
%% MKFUN creates a new function file based on a template
%
% MKFUN(NAME) creates function NAME into a new file at the specified target. It
% will not have any input or return arguments pre-defined.
%
% MKFUN(NAME, ARGIN) also adds the list of input arguments defined in ARGIN to
% the function declaration.
%
% MKFUN(NAME, ARGIN, ARGOUT) creates function NAME into a new file at the
% specified target. The cell array ARGIN and ARGOUT define the argument input
% and argument output names.
%
% MKFUN(___, Name, Value) allows passing additional inputs as Name/Value pairs.
%
% Inputs:
%
%   NAME                Name of the function. Can also be a fully qualified file
%                       name from which the function name will then be
%                       extracted. Function name given will be converted to
%                       valid MATLAB function names before being processed. See
%                       MATLAB.LANG.MAKEVALIDNAME for more info.
%
%   ARGIN               Cell array of input variable names. If empty, function
%                       will not take any arguments. Placeholder `varargin` can
%                       be used by liking. Note that, any variable name occuring
%                       after `varargin` will be striped.
%
%   ARGOUT              Cell array of output variable names. If empty i.e., {},
%                       function will not return any arguments. Placeholder
%                       `varargout` may be used by requirement. Note that, any
%                       variable name occuring after `varargout` will be
%                       striped.
%
% Optional Inputs -- specified as parameter value pairs
%
%   Author              Author string to be set. Most preferable you will  use
%                       something like
%                       'Firstname Lastname <author-email@example.com>'
%   
%   Description         Description of function which is usually the first line
%                       after the function declaration and contains the function
%                       name in all caps.
%
%   NArgIn              Number of input arguments to use in `narginchk`.
%                       Default: [] i.e., all arguments required.
%
%   NArgOut             Number of output arguments to use in `nargoutchk`.
%                       Default: [] i.e., all arguments required.
%
%   Overwrite           Flag whether to overwrite the target function file if it
%                       already exists.
%                       Default: 'off'
%
%   Template            Path to a template file that should be used instead of
%                       the default found in this function's directory.
%                       Default: 'functiontemplate.mtpl'
%
% See also:
%   MATLAB.LANG.MAKEVALIDNAME MVFUN CPFUN



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-01-27
% Changelog:
%   2022-01-27
%       * Update to use renamed `onoffstate` function instead of
%       `parseswitcharg`
%   2022-01-26
%       * Fix bug adding double newlines at the end of each file
%       * Add support to add a newline at the end of the created function only
%       if there is no newline already
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-12-13
%       * Rename to `MKFUN` to be more consistent with functions like `MKDIR`
%       * Internal code beautification and stream-lining, better exception
%       handling and printing
%       * Use `FILEREAED` instead of `TEXTSCAN` to read template file
%       * Update to use new signature of `PARSESWITCHARG`
%       * Add parameter `Overwrite` to H1 documentation
%   2021-11-30
%       * Ensure function name given is always a valid name by uisng
%       `MATLAB.LANG.MAKEVALIDNAME`
%   2021-11-23
%       * Fix H1 Documentation
%       * Add Name/Value options `NArgin` and `NArgout`
%       * Add section "Parse arguments" in generated file
%   2020-11-12
%       * Fix indentation of 'Inputs:' and 'Outputs:' in generated code
%   2020-11-02
%       * Change domain name in default value for `Author` to `ls2n.fr`
%   2018-11-18
%       * Fix typo in help lines
%   2018-05-14
%       * A custom defined template file path can be given now, too
%       * Additionally, if no custom template file path was givent, a file
%       template matching the target function name will be searched and used if
%       found. For example, if a function called `myfun` was to be created, we
%       look for a file called `myfun.mtpl` somewhere on the MATLAB path and load
%       this instead of `functiontemplate.mtpl`
%   2017-03-05
%       * Really fix incorrcet determination of the next major column depending
%       on the length of the input arguments and dividable by 4
%   2016-12-03
%       * Fix incorrect determination of the next major column depending on the
%       length of the input arguments and dividable by 4
%   2016-11-17
%       * Add validation of input and output argument formats such that these
%       will be valid MATLAB identifiers (make use of matlab.lang.makeValidName)
%       * Remove inline function in_charToValidArgument and replace with
%       parseswitcharg
%   2016-11-13
%       * Minor tweaking of determination of column to start argument
%       description in. Now is at least at column 21 if no longer argument names
%       are found
%   2016-11-11
%       * Update handling of no return arguments causing an empty equal sign to
%       appear and break code highlighting
%       * Fix message identifiers used in MException
%   2016-11-06
%       * Fix that square brackets were placed around a single output argument
%       where it actually is not needed
%   2016-09-02
%       * Fix bug in description parsing when only {'varargin'} or {'varargout'}
%       was given for 'ArgIn' or 'ArgOut', respectively
%       * Tweak checking for file existance and overwrite flag
%   2016-09-01
%       * Prevent function from overwriting already existing functions unless
%       overwriting is explicitely enforced
%       * Fix bug in determination of longest ON or OUT argument name causing a
%       warning to be emitted by MATLAB
%   2016-08-25
%       * Add support for input and output arguments appearing in the help part
%       of the script
%       * Change option 'Open' to 'Silent' to have argument make more sense (A
%       toggle should always be FALSE by default and only TRUE by request.
%       Previously, that was not the case)
%    2016-08-04
%       * Change default value of option 'Open' to 'on'
%   2016-08-02
%       * Initial release



%% Define the input parser
ip = inputParser();

% Require: Filename
valFcn_Name = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Name');
addRequired(ip, 'Name', valFcn_Name);

% Allow custom input argument list
valFcn_ArgIn = @(x) validateattributes(x, {'cell'}, {}, mfilename(), 'ArgIn');
addOptional(ip, 'ArgIn', {}, valFcn_ArgIn);

% Allow custom return argument list
valFcn_ArgOut = @(x) validateattributes(x, {'cell'}, {}, mfilename(), 'ArgOut');
addOptional(ip, 'ArgOut', {}, valFcn_ArgOut);

% Author: Char. Non-empty
valFcn_Author = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Author');
addParameter(ip, 'Author', 'Philipp Tempel <philipp.tempel@ls2n.fr>', valFcn_Author);

% Description: Char. Non-empty
valFcn_Description = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'Description');
addParameter(ip, 'Description', '', valFcn_Description);

% Number of input/output arguments
valFcn_NArgIn  = @(x) validateattributes(x, {'double'}, {'vector', 'numel', 2, 'nonnegative', 'nondecreasing', 'nonnan'}, mfilename(), 'NArgIn');
valFcn_NArgOut = @(x) validateattributes(x, {'double'}, {'vector', 'numel', 2, 'nonnegative', 'nondecreasing', 'nonnan'}, mfilename(), 'NArgOut');
addParameter(ip, 'NArgIn', [], valFcn_NArgIn);
addParameter(ip, 'NArgOut', [], valFcn_NArgOut);

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
    % MKFUN(NAME)
    % MKFUN(NAME, IN)
    % MKFUN(NAME, IN, OUT)
    % MKFUN(NAME, IN, OUT, 'Name', 'Value', ...)
    narginchk(1, Inf);
    
    % MKFUN(...)
    nargoutchk(0, 0);
    
    parse(ip, fname, varargin{:});
catch me
    throwAsCaller(me);
end



%% Parse results
% Function name/path
fname = matlab.lang.makeValidName(ip.Results.Name);
% Get function path, file name, and extension
[fun_path, fun_name, fun_ext] = fileparts(fname);
% Empty filepath?
if isempty(fun_path)
    % Save in the current working directory
    fun_path = pwd();
end
% Empty file extension?
if isempty(fun_ext)
    % Ensure we'll save as '.m' file
    fun_ext = '.m';
end
% List of input arguments
[arg_in, fVarArgIn] = parse_vararg('in', ip.Results.ArgIn);
% List of output arguments
[arg_out, fVarArgOut] = parse_vararg('out', ip.Results.ArgOut);
% Description text
description = ip.Results.Description;
% Author name
author = ip.Results.Author;
% Silent creation?
lsilent = onoffstate(ip.Results.Silent);
% Overwrite existing?
loverwrite = onoffstate(ip.Results.Overwrite);
% Path to template file
template = ip.Results.Template;
% Package name
package = ip.Results.Package;
% Number of input/output arguments
narg_in = ip.Results.NArgIn;
narg_out = ip.Results.NArgOut;

%%% Local variables
% No templtae file given?
if isempty(template)
    % Check if a template for this function name exists
    if 2 == exist(sprintf('%s.mtpl', fun_name), 'file')
        % Get the fully qualified file path to the function template name
        template = which(sprintf('%s.mtpl', fun_name));
    else
        % Then use the default function template
        template = fullfile(fileparts(mfilename('fullpath')), 'functiontemplate.mtpl');
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
    fun_path = fullfile(fun_path, package);
end
% Lastly, add file name to file path
fun_fullpath = fullfile(fun_path, [ fun_name , fun_ext ]);



%% Assert variables

% % Assert we have a valid function template filepath
% assert(2 == exist(chTemplateFilepath, 'file'), 'PHILIPPTEMPEL:MATLAB_TOOLING:MKFUN:functionTemplateNotFound', 'Function template cannot be found at %s.', chTemplateFilepath);
% Assert the target file does not exist yet
assert(2 == exist(fun_fullpath, 'file') && loverwrite == matlab.lang.OnOffSwitchState.on || 0 == exist(fun_fullpath, 'file'), 'PHILIPPTEMPEL:MKFUN:functionExists', 'Function already exists. Will not overwrite unless forced to do so.');



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

% Join the input arguments
signature_argin = strjoin(cellfun(@(chArg) matlab.lang.makeValidName(chArg), arg_in, 'UniformOutput', false), ', ');
% Join the output arguments
signature_argout = strjoin(cellfun(@(chArg) matlab.lang.makeValidName(chArg), arg_out, 'UniformOutput', false), ', ');
% Wrap output argumets in square brackets if there are more than one
if numel(arg_out) > 0
    if numel(arg_out) > 1
        signature_argout = [ '[' , signature_argout , ']' ];
    end
    
    signature_argout = [ signature_argout , ' = ' ];
end

% Input/output argument checking
arginchk  = build_argchk('in', narg_in);
argoutchk = build_argchk('out', narg_out);

% Description string
description = in_createDescription(description, arg_in, arg_out);

% Define the set of placeholders to replace here
substitutions = {...
    'FUNCTION'        , fun_name          ; ...
    'FUNCTION_UPPER'  , upper(fun_name)   ; ...
    'ARGIN'           , signature_argin   ; ...
    'ARGOUT'          , signature_argout  ; ...
    'DESCRIPTION'     , description       ; ...
    'AUTHOR'          , author            ; ...
    'DATE'            , chDate            ; ...
    'ARGINCHK'        , arginchk          ; ...
    'ARGOUTCHK'       , argoutchk         ; ...
};
nsubstitutions = size(substitutions, 1);

% Replace all placeholders with their respective content
for isub = 1:nsubstitutions
    content = strrep(content, [ '{{' , substitutions{isub,1} , '}}' ], substitutions{isub,2});
end


% Save the file
try
  % Make target directory
    if 7 ~= exist(fun_path, 'dir')
        [status, errmsg, errid] = mkdir(fun_path);
        if status ~= 1
            throw(MException(errid, errmsg));
        end
    end
    
    [fid, errmsg] = fopen(fun_fullpath, 'w+');
    if fid < 0
        throw(MException('MATLAB:FileIO:InvalidFid', errmsg));
    end
    
    % Ensure file is closed on any error
    coClose = onCleanup(@() fclose(fid));
    
    % Write content
    fprintf(fid, '%s', content);
    
    % Ensure a EOF-newline
    if ~strcmp(content(end), newline())
      fprintf(fid, '%s', newline());
    end
    
catch me
    throwAsCaller(me);
end



%% Assign output quantities
% Open file afterwards?
if lsilent == matlab.lang.OnOffSwitchState.off
    open(fun_fullpath);
end


end


function description = in_createDescription(description, argsin, argsout)
%% IN_CREATEDESCRIPTION
%
% DESCRIPTION = IN_CREATEDESCRIPTION(DESCRIPTION, ARGS_IN, ARGS_OUT)



% Holds the formatted list entries of inargs and outargs
argsin_list = cell(numel(argsin), min(numel(argsin), 1));
argsout_list = cell(numel(argsout), min(numel(argsout), 1));

% Determine longest argument name for input
argsin_length = max(cellfun(@(x) length(x), argsin));
if isempty(argsin_length)
    argsin_length = 0;
end
% and output
argsout_length = max(cellfun(@(x) length(x), argsout));
if isempty(argsout_length)
    argsout_length = 0;
end

% Determine the longer argument names: input or output?
args_length = max([argsin_length, argsout_length]);
% Get the index of the next column (dividable by 4) but be at least at
% column 25
ncol_spacer = max([25, 4*ceil((args_length + 1)/4) + 1]);

% First, create a lits of in arguments
if ~isempty(argsin)
    % Prepend comment char and whitespace before uppercased argument
    % name, append whitespace up to filling column and a placeholder at
    % the end
    argsin_list = cellfun(@(x) sprintf('%%   %s%s%s %s', upper(x), repmat(' ', 1, ncol_spacer - length(x) - 1), 'Description of argument', upper(x)), argsin, 'Uniform', false);
end

% Second, create a lits of out arguments
if ~isempty(argsout)
    % Prepend comment char and whitespace before uppercased argument
    % name, append whitespace up to filling column and a placeholder at
    % the end
    argsout_list = cellfun(@(x) sprintf('%%   %s%s%s %s', upper(x), repmat(' ', 1, ncol_spacer - length(x) - 1), 'Description of argument', upper(x)), argsout, 'Uniform', false);
end

% Append list of input arguments?
if ~isempty(argsin_list)
    description = [ ...
        description   , newline() ...
      , '%'           , newline() ...
      , '% Inputs:'   , newline() ...
      , '%'           , newline() ...
      , strjoin(argsin_list, [ newline() , '% ' , newline() ]) ...
    ];
%     description = sprintf('%s\n%%\n%% Inputs:\n%%\n%s', description, strjoin(argin_list, '\n%\n'));
end

% Append list of output arguments?
if ~isempty(argsout_list)
    description = [ ...
        description   , newline() ...
      , '%'           , newline() ...
      , '% Outputs:'  , newline() ...
      , '%'           , newline() ...
      , strjoin(argsout_list, [ newline() , '% ' , newline() ]) ...
    ];
%     description = sprintf('%s\n%%\n%% Outputs:\n%%\n%s', description, strjoin(argout_list, '\n%\n'));
end


end


function [args, f] = parse_vararg(t, args)
%% PARSE_VARARG
%
% [ARGS, F] = PARSE_VARARG(T, ARGS)



% Find the index of 'varargin' in the input argument names
idxS = find(strcmpi(args, sprintf('vararg%s', t)));
f = ~isempty(idxS) && numel(args) >= idxS;
% Reject everything after 'varargin'
if f
  args((idxS + 1):end) = [];
end


end


function a = build_argchk(t, n)
%% BUILD_ARGCHK
%
% A = BUILD_ARGCHK(T, N)



if ~isempty(n)
  a = sprintf('narg%schk(%d, %d);', t, n(1), n(2));
  
  if strcmpi(t, 'in')
    a = sprintf('\n%s\n', a);
    
  elseif strcmpi(t, 'out')
    a = sprintf('%s\n\n', a);
    
  end
  
else
  a = '';
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
