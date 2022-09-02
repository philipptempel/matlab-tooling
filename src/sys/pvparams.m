function [numargs, pvargs] = pvparams(args)%#codegen
%% PVPARAMS Split variable arguments into numeric and name/value pairs
%
% [NUMARGS, PVARGS] = PVPARAMS(ARGS) splits the list of variable arguments into
% a list of numeric arguments NUMARGS and of name/value pairs PVARGS.
%
% Outputs:
%
%   NUMARGS             Cell array of numeric args extracted from VARARGIN.
%
%   PVARGS              Cell array of name/value args extracted from VARARGIN.
%
% See also
%   PARSEPARAMS



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-09-02
% Changelog:
%   2022-09-02
%       * Replace VARARGIN with ARGS so that we pass only one argument into this
%       function which creates less overhead in calling the function
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2019-01-27
%       * Initial release



%% Split stuff

% Gather if argument is is a char or string
idxChars = cellfun(@matlab.graphics.internal.isCharOrString, args);

% Find the first char or string argument
charindx = find(idxChars);

% None found => all numeric args
if isempty(charindx)
  numargs = args;
  pvargs = args(1:0);

% Found one, split arguments
else
  numargs = args(1:(charindx(1) - 1));
  pvargs = args(charindx(1):end);
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
