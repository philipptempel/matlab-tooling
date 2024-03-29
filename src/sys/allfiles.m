function Files = allfiles(d, varargin)
% ALLFILES Finds all files in directory DIR and returns them in a structure
%
%   FILES = ALLFILES() scans through current working directory and returns all
%   files. This is basically the same as calling the `dir` function. However,
%   the power lies in the magic of this function. Read more to see what is
%   meant.
%
%   FILES = ALLFILES(DIR) scans through directory DIR and returns all files.
%
%   FILES = ALLFILES(DIR, 'csv') scans through directory DIR and returns all
%   files with extension 'csv' (or, '.csv' to be more precise).
%
%   FILES = ALLFILES('Name', 'Value', ...) with additional options specified by
%   one or more Name,Value pair arguments.
%
%   Optional Inputs -- specified as parameter value pairs
%
%   Dir             Directory to list files from. Defaults to `pwd`.
%
%   Extension       Extension to match. Allows for easy filtering of all
%       'csv' files in a given directory. Extension must be without the trailing
%       period and also without any placeholders. Defaults to '.*'.
%
%   Prefix          Prefix to match files against. When given, only files
%       starting with 'Prefix' are searched and returned. Defaults to '.*'.
%
%   Suffix          Suffix to match files against. When given, only files ending
%       with 'Suffix' are searched and returned. Defaults to '.*'.
%
%   IncludeHidden   Switch to include hidden files i.e., files starting with a
%       '.' (period). Possible options are:
%           'on', 'yes'     Include hidden files
%           'off', 'no'     Do not include hidden files
%       Defaults to 'off'.
%
%   Recurse         Flag whether to recurse into subdirectories, too. Possible
%       options are
%           'on', 'yes'     Recurse into subdirectories
%           'off', 'no'     Do not recurse into subdirectories
%       Defaults to 'off'
%
%   See also: dir



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-12-13
% Changelog:
%   2021-12-13
%       * Update to new signature of `PARSESWITCHARG`
%   2020-11-17
%       * Change bug that would stop function from recursing into package
%       directories
%   2020-11-16
%       * Copy from my personal MATLAB package
%       * Change domain of author's email to `ls2n.fr`
%   2020-01-14
%       * Change default values of `Prefix`, `Suffix`, and `Extension` to '.*'
%       for regexp-conforming default values
%       * Rewrite logic for creating the list of arguments for recursion into
%       subdirectories
%   2018-11-30
%       * Fix incorrect creation of cell array of recursion arguments
%   2018-08-31
%       * Change name/value parameter EXTENSION to an optional parameter, that
%       now may also be left empty to gather all files
%       * Update to more object-oriented approach to using INPUTPARSER. All
%       methods that involve the IP are now called on the IP object rather than
%       passing the IP object as first argument
%   2018-05-21
%       * Fix incorrect passing of arguments to recursive call
%   2018-04-10
%       * Fix 'extension' handling by defaulting prefix and suffix to ''
%   2018-01-22
%       * Make parameter "D" required. By default, if not given, it will fall
%       back to `pwd`
%       * Change optional parameter 'Extension' to a parameter
%       * Add Name/Value pair 'Recurse' to allow recursing into subdirectories,
%       too
%   2016-10-18
%       * Change name/value pair 'Extension' from optional to parameter
%   2016-09-09
%       * Update logic to work correctly and a bit more efficiently
%       * Rename parameter 'IncludeSystem' to 'IncludeHidden' to make it more
%       meaningful
%       * Fix bug due to incorrect referencing of 'isdir' attribute
%   2016-07-14
%       * Wrap IP-parse in try-catch to have nicer error display
%   2016-07-04:
%       * Initial release



%% Define the input parser
ip = inputParser;

% Optional: Directory. Char. Non-empty.
valFcn_Dir = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Dir');
ip.addRequired('Dir', valFcn_Dir);

% Parameter: Extension. Char. Non-empty.
valFcn_Extension = @(x) validateattributes(x, {'char'}, {}, mfilename, 'Extension');
ip.addOptional('Extension', '.*', valFcn_Extension);

% Paramter: Prefix. Char. Non-empty.
valFcn_Prefix = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Prefix');
ip.addParameter('Prefix', '.*', valFcn_Prefix);

% Parameter: Suffix. Char. Non-empty.
valFcn_Suffix = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'Suffix');
ip.addParameter('Suffix', '.*', valFcn_Suffix);

% Parameter: IncludeHidden. Char. Matches {on, yes, off, no}
valFcn_IncludeHidden = @(x) any(validatestring(lower(x), {'on', 'yes', 'off', 'no'}, mfilename, 'IncludeHidden'));
ip.addParameter('IncludeHidden', 'off', valFcn_IncludeHidden);

% Parameter: Recurse. Char. Matches {on, yes, off, no}
valFcn_Recurse = @(x) any(validatestring(lower(x), {'on', 'yes', 'off', 'no'}, mfilename, 'Recurse'));
ip.addParameter('Recurse', 'off', valFcn_Recurse);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    % Default argument fallback
    if nargin == 0 || isempty(d) || 0 == exist('d', 'var')
        d = pwd;
    end
    
    % ALLFILES(D)
    % ALLFILES(D, ...)
    narginchk(1, Inf);
    % ALLFILES(...)
    % F = ALLFILES(...)
    nargoutchk(0, 1);
    
    args = [{d}, varargin];
    
    ip.parse(args{:});
catch me
    throwAsCaller(me);
end



%% Assign parser variables to local variables
% Get the directory to look at: char
chDir = fullpath(ip.Results.Dir);
% File extension to retrieve: char
chExtension = ip.Results.Extension;
% File prefix: char
chPrefix = ip.Results.Prefix;
% File suffix: char
chSuffix = ip.Results.Suffix;
% Include system: char, {'on', 'off'}
chIncludeHidden = parseswitcharg(ip.Results.IncludeHidden);
% Recurse into subdirectories: char, {'on', 'off'})
chRecurse = parseswitcharg(ip.Results.Recurse);



%% Magic, collect the files
% Get all the files in the given directory
stFiles = dir(chDir);

% Build list of arguments for recursing
if chRecurse == matlab.lang.OnOffSwitchState.on
    % Copy methods arguments results
    ip_results = ip.Results;
    % Remove arguments that are marked `required` or `optional`
    ip_results = rmfield(ip_results, 'Dir');
    ip_results = rmfield(ip_results, 'Extension');
    % All names of the arguments
    arguments = fieldnames(ip_results);
    % Build cell array for recursion
    ceArgsRecurse = cell(1, 1 + 2 * numel(arguments));
    ceArgsRecurse{1} = ip.Results.Extension;
    ceArgsRecurse(2:2:end) = arguments;
    ceArgsRecurse(3:2:end) = struct2cell(ip_results);
end

% Proceed only from here on if there were any files found
if ~isempty(stFiles)
    % Remove the system entries '.' and '..'
    stFiles(ismember({stFiles.name}, {'.', '..'})) = [];
    
    % Do we need to filter the system files like '.' and '..'?
    if chIncludeHidden == matlab.lang.OnOffSwitchState.off
        % Remove all directories from the found items
        stFiles(startsWith({stFiles.name}, '.')) = [];
    end
    
    % Logically index directories
    loDirs = [stFiles.isdir];
    % Get index of directories
    idxDirs = find(loDirs);
    
    % Recurse into subdirectories if requested
    if chRecurse == matlab.lang.OnOffSwitchState.on
        for iDir = 1:numel(idxDirs)
            % And merge with the files found in the subdirectory
            stFiles = vertcat(stFiles, allfiles(fullfile(chDir, stFiles(idxDirs(iDir)).name) ...
                , ceArgsRecurse{:} ...
            ));
        end
    end
    % Now, remove all items that are directories (we have left overs from the
    % root direcotry and possibly from recursed directories)
    stFiles([stFiles.isdir]) = [];
    
    % And now filter the files that do not match the requested pattern
    stFiles(cellfun(@isempty, regexp({stFiles.name}, ['^' , chPrefix , '.*' , chSuffix , '\.' , chExtension , '$'], 'match', 'once'))) = [];
end



%% Assign output quantities
Files = stFiles;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
