function se = strescape(s)
%% STRESCAPE Escape a string
%
% SE = STRESCAPE(S) escapes string S to be used safely inside math-supporting
% environments such as TITLE, XLABEL, YLABEL, etc.
%
% Inputs:
%
%   S                   Input character string.
%
% Outputs:
%
%   SE                  Escaped character string.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-06-21
% Changelog:
%   2021-06-21
%       * Initial release



%% Parse arguments

% STRESCAPE(S)
narginchk(1, 1);
% STRESCAPE(S)
% ES = STRESCAPE(S)
nargoutchk(0, 1);



%% Perform

persistent old new nreps

if isempty(old)
  old = { ...
      '\' ...
    , '^' ...
    , '_' ...
  };
  new = { ...
      '\\' ...
    , '\^' ...
    , '\_' ...
  };
  nreps = numel(old);
  
end

se = s;

for irep = 1:nreps
  se = strrep(se, old{irep}, new{irep});
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
