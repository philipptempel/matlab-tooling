function p = mtl_projpath()
%% MTL_PROJPATH returns the path definiton for this project
%
% P = MTL_PROJPATH()
%
% Outputs:
%
%   P                   Cell array of paths to automatically load



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2022-03-14
% Changelog:
%   2022-03-14
%       * Add `NARGINCHK` and `NARGOUTCHK`
%       * Remove submodules from list of paths
%   2022-01-31
%       * Fix post-processing of generated paths
%       * Remove top-level directory from list of paths
%   2021-12-22
%       * Ensure that all paths returned by this function are normalized and
%       absolute canonical names
%   2021-07-01
%       * Rename file to `mtl_projpath`
%   2021-02-11
%       * Move all source code into `src` directory
%   2020-10-30
%       * Fix path to `matlab2tikz` source directory
%   2020-06-11
%       * Add directory` video` to cell of paths
%       * Move into `private` directory so it is only accesible from functions
%       within this directory
%       * Rename to `mlt_projpath`
%   2019-02-28
%       * Remove directory 'dae' which is not yet to be available
%   2018-04-29
%       * Initial release



%% Parse arguments

% MTL_PROJPATH()
narginchk(0, 0);

% P = MTL_PROJPATH()
nargoutchk(0, 1);



%% Algorithm

% Base directory
b = fullfile(fileparts(mfilename('fullpath')), '..');

% Parsed base directory
chPath = char(java.io.File(b).getCanonicalPath());

% All paths to add
p = { ...
    genpath(fullfile(chPath, 'mex')) ...
  , genpath(fullfile(chPath, 'src')) ...
};

% Remove empty paths
p(cellfun(@isempty, p)) = [];

% Porcess all paths to be absolute, fully qualified paths
p = cellfun( ...
    @(ip) strjoin( ...
        cellfun( ...
            @(p) char(java.io.File(p).getCanonicalPath()) ...
          , strsplit(strip(ip, 'both', pathsep()), pathsep()) ...
          , 'UniformOutput', false ...
        ) ...
      , pathsep() ...
    ) ...
  , p ...
  , 'UniformOutput', false ...
);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
