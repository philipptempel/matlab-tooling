function h1 = geth1(f)
%% GETH1 Get H1 line of a file
%
% H1 = GETH1(F) gets H1 help line from file F.
%
% Inputs:
%
%   F                       File name for which to get the H1 line. F can be a
%                           fully qualified file name or not.
%
% Outputs:
%
%   H1                      Character string of the H1 line.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-01
% Changelog:
%   2022-03-01
%       * Initial release



%% Parse arguments

% GETH1(F)
narginchk(1, 1);

% GETH1(___)
% H1 = GETH1(___)
nargoutchk(0, 1);



%% Algorithm

% Turn function handles into strings
if isa(f, 'function_handle')
  f = func2str(f);
end

% Check if no file path was given by checking if no FILESEP can be found in the
% function name
if ~contains(f, filesep())
  f = which(f);
end

% Get the help string for the given function
h = help(f);

% Remove any leading space and percent sign; remove all text after the first
% carriage return
tokens = regexp(h, '^\s*%*\s*([^\n]*)\n','tokens','once');
if isempty(tokens)
  h1 = '';
  
else
  h1 = tokens{1};
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
