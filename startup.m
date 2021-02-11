function startup()
% STARTUP starts this project



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2020-06-11
% Changelog:
%   2020-06-11
%       * Add initialization of figure styles, diaries, format, random number
%       generator, warnings, last workspace
%       * Make standalone tooling project and ensure that it can be used as
%       start directory of MATLAB
%   2018-05-16
%       * Move the installation of the plot styles to a separate file
%   2018-05-14
%       * Add installation of plot styles to MATLAB's `prefdir()/ExportSetup`
%       directory
%   2018-04-29
%       * Move all path definitions to `pathdef.m`
%   2017-03-12
%       * Initial release



%% Bootstrap
chBase = fullfile(fileparts(mfilename('fullpath')));



%% Early level configuration
% Set time zone
setenv('TZ','Europe/Zurich');   
% Get path's to add to MATLAB's search path
p = mlt_projpath();
% and add the paths
addpath(p{:});



%% Configure MATLAB diaries
% Make sure we have a directory for our diaries
if 7 ~= exist(fullfile(chBase, 'diaries'), 'dir')
    mkdir(fullfile(chBase, 'diaries'));
end

% Set the diary filename
diary(fullfile(chBase, 'diaries', sprintf('%s.txt', datestr(now, 'yyyy-mm-dd'))));



%% Init MATLAB

% Set random number generator to a set or pre-defined options
setrng()

% Copy all plotstyles if they need to be copied
copy_plotstyles();

% Initialize random state
rng(sum(100*clock), 'v5uniform');
rng(sum(100*clock), 'v5normal');

% Command window format
format('compact');
format('longG');

% Default recursion limits
set(0, 'RecursionLimit', 50);

% Select solarized style depending on current hour of the day (at night i.e., between 8pm and 8am we choose 'dark', otherwise 'light')
c = clock();
% c = [year, month, day, hour, minute, second]
if c(4) < 8 || 20 <= c(4)
  setupSolarized('dark');
else
  setupSolarized('light');
end
clear('c');



%% Setting up figures
%%% Default figure properties
set(groot, 'DefaultFigurePaperType', 'A4');
% set(groot, 'DefaultFigurePaperSize', [21.0 29.7]);
set(groot, 'DefaultFigurePaperUnits', 'normalized');
set(groot, 'DefaultFigurePaperPosition', [0.05, 0.05, 0.90, 0.90]);
set(groot, 'DefaultFigureWindowStyle', 'normal');

%%% Default text properties
set(groot, 'DefaultTextFontSize', 14);

%%% Default UI Control properties
set(groot, 'DefaultUicontrolFontSize', 8);

%%% Default axes properties
set(groot, 'DefaultAxesBox', 'on');
set(groot, 'DefaultAxesFontSize', 16);
set(groot, 'DefaultAxesLineStyleOrder', '-|--|-.|:');
set(groot, 'DefaultAxesLinewidth', 1.5);

%%% Default line plot properties
set(groot, 'DefaultLineLinewidth', 1.5);

%%% Default quiver plot properties
set(groot, 'DefaultQuiverLinewidth', 1.5);

%%% Default stair plot properties
set(groot, 'DefaultStairLinewidth', 1.5);

%%% Default patch properties
set(groot, 'DefaultPatchLinewidth', 1.5);

%%% Default axes Grid options
set(groot, 'DefaultAxesXGrid', 'on');
set(groot, 'DefaultAxesYGrid', 'on');
set(groot, 'DefaultAxesZGrid', 'on');



%% Setting up handy debugging options
% And some other values
recycle('off');
warning('off', 'verbose');
warning('on', 'all');
warning('on', 'backtrace');

% Clear all debug errors for now
dbclear('all');

% Tell debugger to stop if errors emerge
% dbstop('if', 'error')

% Tell debugger to stop if we try/catch an error
% dbstop if caught error



%% Lastly, load the most recent workspace
% Get all mat files in the subdirectory
stFiles = dir(fullfile(chBase, 'workspace', 'ws_*.mat'));

% If we have found some files
if numel(stFiles) > 0
    [~, idxDates] =  sort([stFiles(:).datenum]);
    try
        evalin('base', sprintf('load(''%s'');', fullfile(stFiles(idxDates(end)).folder, stFiles(idxDates(end)).name)));
    catch
    end
end


end


%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
