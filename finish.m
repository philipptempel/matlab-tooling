function finish()
% FINISH shuts down the project



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2022-08-02
% Changelog:
%   2022-08-02
%       * Revert previous change (Reverse order of removing paths)
%   2022-03-14
%       * Reverse order of removing paths
%       * Split repository into tooling repo and workspace repo, thus update
%       function to reflect new layout
%   2022-01-31
%       * Fix removing of paths in incorrect order
%   2021-12-22
%       * Fix order in which paths are removed to from-back-to-front
%   2021-05-11
%       * Remove paths added to MATLAB's search path
%   2017-03-12
%       * Initial release



%% Algorithm

% Get path's to add to MATLAB's search path
p = mtl_projpath();
% and remove the paths in reverse order
rmpath(p{end:-1:1});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
