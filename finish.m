function finish()
% FINISH shuts down the project



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2022-01-31
% Changelog:
%   2022-01-31
%       * Fix removing of paths in incorrect order
%   2021-12-22
%       * Fix order in which paths are removed to from-back-to-front
%   2021-05-11
%       * Remove paths added to MATLAB's search path
%   2017-03-12
%       * Initial release



%% Do your code magic here


% Where to save the current workspace to
chWorkspacePath = fullfile(fileparts(mfilename('fullpath')), 'workspace');

% Make sure we have a directory for our workspace files
if 7 ~= exist(chWorkspacePath, 'dir')
    mkdir(chWorkspacePath);
end

% Save the current workspace to a file in this file's directory
evalin('base', sprintf('save(''%s'');', fullfile(chWorkspacePath, sprintf('ws_%s.mat', datestr(now, 'yyyymmddThhMMss')))));

% Get path's to add to MATLAB's search path
p = mtl_projpath();
% and remove the paths in reverse order
rmpath(strjoin(cellfun(@(c) strjoin(fliplr(strsplit(c, pathsep())), pathsep()), p, 'UniformOutput', false), pathsep()));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
