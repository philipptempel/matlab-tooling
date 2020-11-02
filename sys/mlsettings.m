function mlsettings(action, varargin)
% MLSETTINGS allows to save and restore MATLAB settings
%
%   Inputs:
%
%   ACTION              Action mode can be either `backup` or `restore`



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2020-06-23
% Changelog:
%   2020-06-23
%       * Add `narginchk` and `nargoutchk`
%   2019-11-25
%       * Initial release



%% Define the input parser
ip = inputParser;

% MLSETTINGS(ACTION)
narginchk(1, 1);

% MLSETTINGS(ACTION)
nargoutchk(0, 0);

% Require: Filename
valFcn_Action = @(x) validateattributes(x, {'char'}, {'nonempty'}, mfilename, 'action');
addRequired(ip, 'Action', valFcn_Action);

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
chAction = ip.Results.Action;



%% Do magic

switch lower(chAction)
    case {'store', 'save', 'export', 'backup'}
        % get current settings
        user_preferences = settings();
        % and merge it down to the correct format so we can store it as a
        % versionizable JSON string
        user_preferences = read_group(user_preferences);
        
        % and save data as JSON file to hard drive in this folder
        savejson( ...
            '', ...
            user_preferences, ...
            fullfile(...
                fileparts(....
                    mfilename('fullpath') ...
                ), ...
                '..', ...
                'preferences.json' ...
            ) ...
        );
        savejson(user_preferences)
        
        
    case {'load', 'read', 'restore'}
        % load preferences for the user
        user_preferences = loadjson(fullfile(fileparts(mfilename('fullpath')), '..', 'preferences.json'));
        
        % and set them
        write_group(settings(), user_preferences)
   
    otherwise
        throw(MException('PHILIPPTEMPEL:MLSETTINGS:InvalidAction', 'Unknown action ''%s'' given.', chAction))
        
end


end


function grouped = read_group(group)
%% READ_GROUP

grouped = struct();

for field = transpose(fieldnames(group))
    field = field{1};
    
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


function pref = read_setting(setting)
%% READ_SETTING

if hasPersonalValue(setting)
    pref = setting.PersonalValue;
elseif hasTemporaryValue(setting)
    pref = setting.TemporaryValue;
elseif hasFactoryValue(setting)
    pref = setting.FactoryValue;
else
    pref = [];
end

end


function write_group(prefs, group)
%% WRITE_GROUP

for field = transpose(fieldnames(group))
    field = field{1};
    
    % skip non-existing preferences
    if ~isfield(prefs, field)
        continue
    end
    
    % updating a settings group?
    if isa(prefs.(field), 'matlab.settings.SettingsGroup')
        write_group(prefs.(field), group.(field));
    elseif isa(prefs.(field), 'matlab.settings.Setting')
        write_setting(prefs.(field), group.(field));
    end
    
end

end


function write_setting(field, value)
%% WRITE_SETTING

try
    field.PersonalValue = value;
catch me
    warning(me.identifier, '%s', me.message)
end

end


%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
