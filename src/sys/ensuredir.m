function d = ensuredir(d)
%% ENSUREDIR Ensure a certain directory exists
%
% ENSUREDIR(D) ensures directory D exists. If it doesn't exist, it will be
% created.
%
% Inputs:
%
%   D                   Path to directory to ensure existence of.
%
% Outputs:
%
%   D                   Returns path of directory



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-03-18
% Changelog:
%   2021-03-18
%       * Add check if `D` resolves to a file to make only its parent directory
%       and not a directory by the name of the file
%   2020-11-25
%       * Initial release



%% Parse arguments

% ENSUREDIR(D)
narginchk(1, 1);
% ENSUREDIR(D)
% D = ENSUREDIR(D)
nargoutchk(0, 1);



%% Handle

% Internal variable
dc = d;

% If the path given resolves to a file, we will need to make sure we are
% actually dealing with only a directory
[fdir, fname, fext] = fileparts(dc);
if ~isempty(fext)
  dc = fdir;
end

% If the directory does not exist, create it
if 7 ~= exist(dc, 'dir')
  mkdir(dc);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
