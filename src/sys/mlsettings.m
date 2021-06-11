function mlsettings(action, varargin)
%% MLSETTINGS allows to save and restore MATLAB settings
%
% MLSETTINGS(ACTION) performs ACTION on the MATLAB settings.
%
% MLSETTINGS(ACTION, FILE) uses provided filename `FILE` to load/store
% preferences from/to.
%
% Inputs:
%
%   ACTION              Action mode can be either `backup` or `restore`.
%
%   FILE                Filename to store preferences to or to load preferences
%                       from.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2020-06-23
% Changelog:
%   2021-05-11
%       * Fix restoring of preferences
%       * Add argument `FILE` to allow user to provide a custom filename to
%       store settings into
%       * Update H1 documentation of inline functions
%   2020-06-23
%       * Add `narginchk` and `nargoutchk`
%   2019-11-25
%       * Initial release



%% Parse arguments

% Define the input parser
ip = inputParser();

% MLSETTINGS(ACTION)
narginchk(1, Inf);

% MLSETTINGS(ACTION)
nargoutchk(0, 0);

% Require: Action
valFcn_Action = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'action');
addRequired(ip, 'action', valFcn_Action);

% Optional: Filename
valFcn_Filename = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename(), 'file');
addOptional(ip, 'file', fullfile(mlproject(), 'preferences.json'), valFcn_Filename);

% Configuration of input parser
ip.KeepUnmatched = true;
ip.FunctionName = mfilename;

% Parse the provided inputs
try
    args = [{action}, varargin];
    
    parse(ip, args{:});
catch me
    throwAsCaller(MException(me.identifier, me.message));
end



%% Parse arguments
% Get action to do
action = ip.Results.action;
% Filename to load/store preferences from/to
preffile = ip.Results.file;



%% Do magic

switch lower(action)
    case {'store', 'save', 'export', 'backup'}
        % get current settings, merge down as into a pure structure, then save
        % data as JSON file to hard drive in this folder
        savejson( ...
            '' ...                  % root name
            , read_group(settings()) ...  % object
            , preffile ...          % filename
        );
        
        
    case {'load', 'read', 'restore'}
        % load preferences from file and write settings
        write_group(settings(), loadjson(preffile));
   
    otherwise
        throw(MException('PHILIPPTEMPEL:MLSETTINGS:InvalidAction', 'Unknown action ''%s'' given.', action))
        
end


end


function grouped = read_group(group)
%% READ_GROUP
%
% GROUPED = READ_GROUP(GROUP)



grouped = struct();

for field_ = transpose(fieldnames(group))
    field = field_{1};
    
    if isa(group.(field), 'matlab.settings.SettingsGroup')
        value = read_group(group.(field));
        if ~isempty(value)
            grouped.(field) = value;
        end
    elseif isa(group.(field), 'matlab.settings.Setting')
        value = read_setting(group.(field));
        if ~isempty(value)
            grouped.(field) = value;
        end
    end
end


end


function v = read_setting(setting)
%% READ_SETTING
%
% VALUE = READ_SETTING(SETTING)



if hasPersonalValue(setting)
    v = setting.PersonalValue;
elseif hasTemporaryValue(setting)
    v = setting.TemporaryValue;
elseif hasFactoryValue(setting)
    v = setting.FactoryValue;
else
    v = [];
end


end


function write_group(sttngs, prefs)
%% WRITE_GROUP
%
% WRITE_GROUP(SETTINGS, PREFERENCES)



% No data to write...
if isempty(prefs)
    % Then bail out
    return
end

for field_ = transpose(fieldnames(prefs))
    field = field_{1};
    
    % Check if the setting exists ...
    try
        sttngs.(field);
    % ... if not, create it
    catch
        % Add new SettingsGroup if field contains a structure
        if isa(prefs.(field), 'struct')
            addGroup(sttngs, field);
        % Add new Settings if field contains a single value
        else
            addSetting(sttngs, field);
        end
    end
    
    % updating a settings group?
    if isa(sttngs.(field), 'matlab.settings.SettingsGroup')
        write_group(sttngs.(field), prefs.(field));
    % updating a setting
    elseif isa(sttngs.(field), 'matlab.settings.Setting')
        write_setting(sttngs.(field), prefs.(field));
    end
    
end


end


function write_setting(setting, value)
%% WRITE_SETTING
%
% WRITE_SETTING(SETTING, VALUE)



try
    setting.PersonalValue = value;
catch me
    warning(me.identifier, '%s', me.message)
end


end


%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
