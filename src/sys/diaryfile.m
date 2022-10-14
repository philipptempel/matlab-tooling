function df = diaryfile()
%% DIARYFILE Get the global diary file
%
% Outputs:
%
%   DF                  Char to the current diary file



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-04-30
% Changelog:
%   2021-04-30
%       * Simplify call to `mlproject`
%   2021-03-18
%       * Initial release



%% Do your code magic here

df = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'diaries', sprintf('%s.txt', datestr(now(), 'yyyy-mm-dd')));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
