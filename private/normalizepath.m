function p = normalizepath(varargin)
%% NORMALIZEPATH Normalizes a set of paths
%
% P = NORMALIZEPATH(DIR1, DIR2, ..., DIRN) normalizes all directories i.e.,
% removes empty directory paths and gets full canonical paths for every
% directory entry.
%
% Inputs:
%
%   VARARGIN                Description of argument VARARGIN
%
% Outputs:
%
%   P                       Description of argument P



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-01-31
% Changelog:
%   2022-01-31
%       * Initial release



%% Parse arguments

% NORMALIZEPATH(DIR1, DIR2, ..., DIRN)
narginchk(1, Inf);

% NORMALIZEPATH(___)
% P = NORMALIZEPATH(___)
nargoutchk(0, 1);



%% Algorithm

% Remove empty paths
varargin(cellfun(@isempty, varargin)) = [];

% Process paths
p = cellfun( ...
    @(ip) strjoin( ...
        cellfun( ...
            @(p) char(java.io.File(p).getCanonicalPath()) ...
          , strsplit(strip(ip, 'both', pathsep()), pathsep()) ...
          , 'UniformOutput', false ...
        ) ...
      , pathsep() ...
    ) ...
  , varargin ...
  , 'UniformOutput', false ...
);



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
