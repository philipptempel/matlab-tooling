function startup()
%% STARTUP starts this project



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2022-03-14
% Changelog:
%   2022-03-14
%       * Split repository into tooling repo and workspace repo, thus update
%       function to reflect new layout
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



%% Set paths

% Get path's to add to MATLAB's search path
p = mtl_projpath();
% and add the paths
addpath(p{:});


end


%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
