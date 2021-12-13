function cpfun(nsrc, ntrgt, varargin)
%% CPFUN renames the function to a new name
%
% CPFUN(SOURCE, TARGET) copies function SOURCE to TARGET and changes its
% signature.
%
% FUNCNREN(SOURCE, TARGET, 'Name', 'Value', ...) allows setting optional inputs
% using name/value pairs.
%
% Inputs:
%
%   SOURCE              Name of the source function to copy.
%
%   TARGET              Target name of the function. Can be either only a
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
%                       Defaults to 'off'.
%
% See also:
%   MKFUN CPFUN



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-12-13
% Changelog:
%   2021-12-13
%       * Initial release



%% Define the input parser
ip = inputParser();

% Require: Filename
valFcn_Old = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Source');
addRequired(ip, 'Source', valFcn_Old);

% Allow custom input argument list
valFcn_New = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Target');
addRequired(ip, 'Target', valFcn_New);

% Silent creation i.e., not opening file afterwards
valFcn_Open = @(x) any(validatestring(x, {'on', 'off', 'yes', 'no', 'please', 'never'}, mfilename, 'Open'));
addParameter(ip, 'Open', 'off', valFcn_Open);


% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    % CPFUN(OLD, NEW);
    % CPFUN(OLD, NEW, 'Name', 'Value', ...);
    narginchk(2, Inf);
    
    % CPFUN(OLD, NEW);
    nargoutchk(0, 0);
    
    parse(ip, nsrc, ntrgt, varargin{:});
catch me
    throwAsCaller(me);
end



%% Parse results

% Source function name
nsrc = ip.Results.Source;
% Target function name
ntrgt = ip.Results.Target;
% Open after rename
lopen = parseswitcharg(ip.Results.Open);




%% Copy the file

% Get the path to the specified function
psrc = which(nsrc);
assert(~isempty(psrc), 'PHILIPPTEMPEL:MATLAB_TOOLING:CPFUN:InvalidFuncName', 'Could not find function %s anywhere in your path', nsrc);

% Get the path parts of the old and new file
[src_path, src_name, src_ext] = fileparts(psrc);
[trgt_path, trgt_name, ~] = fileparts(ntrgt);
% Create path parts for the new file
if isempty(trgt_path)
  trgt_path = src_path;
end
trgt_ext = src_ext;

% Find out if the old function is a packaged function, if so, check the new
% function name if its packaged or not and adjust accordingly (fail if there is
% no such new module)

% Create path of new file
ptrgt = fullfile(trgt_path, [ trgt_name , trgt_ext ]);

% Try copying the file
try
    [status, message, messageid] = copyfile(psrc, ptrgt);
    
    if status ~= 1
        throw(MException(messageid, message));
    end
catch me
    throwAsCaller(MException(me.identifier, me.message));
end

% Read the new file's content
try
    fidSource = fopen(ptrgt);
    
    coClose = onCleanup(@() fclose(fidSource));
    
    fun_content = textscan(fidSource, '%s', 'Delimiter', '\n', 'Whitespace', ''); fun_content = fun_content{1};
    
catch me
    if strcmp(me.identifier, 'MATLAB:FileIO:InvalidFid')
        throw(MException('PHILIPPTEMPEL:MATLAB_TOOLING:CPFUN:InvalidFid', 'Could not open source file for reading.'));
    end
    
    throwAsCaller(MException(me.identifier, me.message));
end

% Replace the function name
subs_fun = {
    src_name, trgt_name;
    upper(src_name), upper(trgt_name);
};

% Replace all placeholders with their respective content
for isub = 1:size(subs_fun, 1)
    fun_content = cellfun(@(str) strrep(str, sprintf('%s', subs_fun{isub,1}), subs_fun{isub,2}), fun_content, 'Uniform', false);
end

% Save the changed function contents
try
    fidTarget = fopen(ptrgt, 'w+');
    
    coClose = onCleanup(@() fclose(fidTarget));
    
    for irow = 1:numel(fun_content)
        fprintf(fidTarget, '%s\r\n', fun_content{irow,:});    
    end
    
catch me
    if strcmp(me.identifier, 'MATLAB:FileIO:InvalidFid')
        throw(MException('PHILIPPTEMPEL:MATLAB_TOOLING:CPFUN:InvalidFid', 'Could not open target file for writing.'));
    end
    
    throwAsCaller(MException(me.identifier, me.message));
end



%% Assign output quantities

% Open file afterwards?
if strcmp('on', lopen)
    edit(ptrgt);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
