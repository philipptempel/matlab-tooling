function fcname = funcname(plain)%#codegen
% FUNCNAME returns the current function's name
%
%   FUNCNAME() returns the name of the currently executing function i.e.,
%   wherever called. If called within the base workspace or a script, will
%   return 'base'.
%
%   FUNCNAME(NOCLASS) returns the function name without any preceding class name
%   from packages.
%
%   Inputs
%
%   PLAIN               Flag whether to return the function name with or without
%                       package/class name. Defaults to 'off'. Possible values
%                       are
%                       true, 'on', 'yes', 'please'   Return only the function
%                                                     name and not its
%                                                     enwrapping class/package
%                                                     name.
%                       false, 'off', 'no'            Return the full function
%                                                     name including possible
%                                                     package/class names.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-12-13
% Changelog:
%   2021-12-13
%       * Update to new signature of `PARSESWITCHARG`
%   2020-12-02
%       * Update to make it codegen-compatible
%   2017-12-01
%       * Initial release



%% Check arguments

narginchk(0, 1);
nargoutchk(0, 1);

if nargin < 1 || isempty(plain)
  plain = 'off';
end

plain = parseswitcharg(plain);



%% Do your code magic here
stStack = dbstack(1);

% If stack is not empty and has field 'name' ...
if ~isempty(stStack) && isfield(stStack, 'name')
    % That's our function mame
    chName = stStack(1).name;
% No stack, so called from within base
else
    chName = 'base';
end

% Strip any class/package name?
if plain == matlab.lang.OnOffSwitchState.ons
  chName = last(strsplit(chName, '.'));
end



%% Assign output quantities
fcname = chName;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
