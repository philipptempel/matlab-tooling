function safesave(filename, varargin)
%% SAFESAVE Like save, just safer
%
% SAFESAVE(FILENAME) acts as a wrapper to MATLAB's SAVE except that it will
% never overwrite file FILENAME but appends the current ISO8601 datetime if
% FILENAME already exists.
%
% Inputs:
%
%   FILENAME          Filename to safely store data in. If not given, defaults
%                     to 'matlab.mat'.
%
% See also:
%   SAVE



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-06-03
% Changelog:
%   2021-06-03
%       * Initial release



%% Parse arguments

% SAFESAVE(FILENAME)
% SAFESAVE(FILENAME, ...)
narginchk(0, Inf);

if nargin < 1 || isempty(filename)
  filename = 'matlab.mat';
end



%% Safely save data

% Split given filename into directory, file name, and file stem
[fdir, fname, fext] = fileparts(filename);

% Fix missing file extension
if isempty(fext)
  fext = '.mat';
end
% Fix missing file directory
if isempty(fdir)
  fdir = pwd();
end

% Build a filename candidate
cand = fullfile(fdir, sprintf('%s%s', fname, fext));

% If filename candidate exists, append the current ISO8601 timestap
if 2 == exist(cand, 'file')
  cand = fullfile(fdir, sprintf('%s_%s%s', fname, datestr8601(), fext));
end

% Build list of variable arguments
vargs = strjoin(varargin, ''', ''');
% And, if not-empty, enclose it in single quotes and prepend with a comma
if numel(vargs)
  vargs = [', ''' , vargs , ''''];
end

% Build `save` command syntax
cmd = sprintf('save(''%s''%s)', cand, vargs);

% And call command in caller's workspace
evalin('caller', cmd);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
