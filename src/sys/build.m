function build(varargin)
%% BUILD Build mexw functions for some m-files
%
%   BUILD('all') build all targets
%
%   BUILD(TARGET1, TARGET2, ...) builds only selected target(s).



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-28
% Changelog:
%   2020-12-28
%       * Fix incorrect coder configuration being passed to build callback
%       * Use `strcase` with `upperCamel` for setting CPP namespaces
%   2020-12-11
%       * Ensure all directories including custom `mex` functions are removed
%       from search path before building code and then afterwards addeda again
%   2020-11-25
%       * Change how build targets are now handled. They must be defined in the
%       `available_targets` callback per goal and must provide a function
%       callback that performs the code generation as desired
%   2020-11-17
%       * Fix bug causing existing MEX functions to be found when compiling
%       functions that made use of such MEX functions
%   2020-11-16
%       * Copy to `functions` package and make generic per package
%   2020-11-10
%       * Set build target to `./mex` directory
%   2020-11-07
%       * Add build target for `geometry.abscissae` package
%   2020-11-06
%       * Initial release



%% Parse arguments

% BUILD()
if nargin == 0
  targets = {'all'};
else
  targets = unique(varargin);
end

% BUILD(...)
narginchk(0, Inf);
% BUILD(...)
nargoutchk(0, 0);



%% Prepare code building

% Get current working directory
cwd = fullpath(pwd);

try
  % Obtain package name from working directory
  srcdirs = dir(fullfile(cwd, 'src', '*'));
  % Remove files
  srcdirs(~[srcdirs.isdir]) = [];
  % Remove any hidden files and folders
  srcdirs(startsWith({srcdirs.name}, '.') )= [];

  % Ideally we now only have one entry left. If not, bail out
  if numel(srcdirs) == 0
    throw(MException('PHILIPPTEMPEL:CONTINUUMROBOTICS:FUNCTIONS:BUILD:NoSrcDirectory', 'No `src` directory found.'));
  end

  % Cleanup object to safely return
  coCwd = onCleanup(@() cd(cwd));

  % Change to `build` directory
  cd(fullfile(cwd, 'bldcfg'));

  % Build all available targets
  [ns, goals] = available_targets(codertypes());

  % Remove this cleanup object
  clear coCwd;
catch me
  throw(addCause(MException('PHILIPPTEMPEL:CONTINUUMROBOTICS:FUNCTIONS:BUILD:BuildConfigurationInvalid', 'No valid build configuration found in current directory. Bailing out!'), me));
end

% Get all default target
if ismember(targets, 'all')
  targets = fieldnames(goals).';
else
  targets = intersect(targets, fieldnames(goals));
end

% Base code generation configuration
cfg = coder.config('mex');
% Report
cfg.GenerateReport = false;
cfg.LaunchReport = false;
cfg.ReportPotentialDifferences = false;
% Debugging
cfg.EchoExpressions = false;
cfg.EnableDebugging = false;
% Code Generation
cfg.TargetLang = 'C++';
% C++ Language Features
cfg.CppNamespaceForMathworksCode = 'external';
% Comments
cfg.MATLABSourceComments = true;

% Base Directory of sources
srcdir = fullpath(fullfile(cwd, 'src'));

% Ensure we are in the `src` directory
cwd = fullfile(pwd);
cd(srcdir);

% Cleanup object to return to previous 
coCurDir = onCleanup(@() cd(cwd));

% Clean up MATLAB's path so that no `mex` directories are on it
oldPath = strsplit(path(), pathsep());
% New path to set
newPath = oldPath;
% Remove all paths that containt '/mex/' in their name
newPath(contains(newPath, [filesep(), 'mex'])) = [];

% Set new path to the new array
path(strjoin(newPath, pathsep()));

% Create a cleanup object to restore MATLAB's original search path
coPath = onCleanup(@() path(strjoin(oldPath, pathsep())));



%% Build binaries
for itarget = 1:numel(targets)
  % Get target name
  target = targets{itarget};
  % Get its goals
  goal = goals.(target);
  
  % Create a copy of the coder config
  cfgTarget = copy(cfg);
  cfgTarget.CppNamespace = sprintf('%s%s', strucfirst(ns), strcase(target, 'uppercamel'));
  
  % Get build function names
  build_funcs = fieldnames(goal);
  
  % Verbose output
  fprintf('building `%s.%s`... \n', ns, target);
  
  % Loop over each function to build
  for ifunc = 1:numel(build_funcs)
    % Verbose output
    fprintf('\tbuilding mex-function `%s`... ', build_funcs{ifunc});
    
    % Build code
    try
      goal.(build_funcs{ifunc})(cfgTarget, cwd);
      
      % Verbose output
      fprintf('success\n');
    catch me
      fprintf('failed: %s\n', me.message);
    end
  end
  
  % Verbose info
  fprintf('built `%s.%s`... \n', ns, target);
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
