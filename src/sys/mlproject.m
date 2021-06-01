function d = mlproject(pfn, from)
%% MLPROJECT Locate the MATLAB project directory in the parent directories.
%
% MLPROJECT()
%
% MLPROJECT(PFN)
%
% MLPROJECT(PFN, FROM)
%
% Inputs:
%
%   PFNAME              Name of the MATLAB project file to look for. Defaults to
%                       '.mlproject'.
%
%   FROM                Directory to start searching from.
%
% Outputs:
%
%   D                   Path to the directory containing `.mlproject` as a
%                       direct parent directory of the current file's directory.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-02-09
% Changelog:
%   2021-02-09
%       * Add parameter `FROM` to start searching from a user-defined base
%       directory.
%   2021-02-05
%       * Initial release



%% Parse arguments

% MLPROJECT()
% MLPROJECT(PFNAME)
% MLPROJECT(PFNAME, FROM)
narginchk(0, 2);

% MLPROJECT(...)
% D = MLPROJECT(...)
nargoutchk(0, 1);

% Default file to look for
if nargin < 1 || isempty(pfn)
  pfn = '.mlproject';
end



%% Find directory

% MLPROPJECT()
% MLPROPJECT(PFNAME)
if nargin < 2 || isempty(from)
  % First, we will check if the function was called from a script/function or from
  % within the base command window
  stStack = dbstack(1);

  % If stack is not empty and has field 'name' ...
  if ~isempty(stStack) && isfield(stStack, 'name')
      % That's our function mame
      callingFunc = stStack(1).name;

  % No stack, so called from within base
  else
      callingFunc = 'base';

  end

  % Called in base workspace
  if strcmp(callingFunc, 'base')
    d = pwd();

  % Called from within a function/script, so we will locate that file using its
  % filename (stored in `callingFunc`) and the file locator `which`.
  else
    d = fileparts(which(callingFunc));

  end
% User provided a start directory to search from
else
  d = from;
  
end

% First guess, current directory
f = fullfile(d, pfn);

% Move up one directory
while 2 ~= exist(f, 'file') && ~strcmp(d, fullpath(fullfile(d, '..')))
  d = fullpath(fullfile(d, '..'));
  f = fullfile(d, pfn);

end

% Check if we are all the way at the filesystem root 
if strcmp(d, fullpath(fullfile(d, '..')))
  throw(MException('MLPROJECT:LOCATE:NoProjectFound', 'No project found in current directory or any of its parent directories.'));

end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
