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
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-01-27
% Changelog:
%   2022-01-27
%       * Update to use renamed `onoffstate` function instead of
%       `parseswitcharg`
%       * Update dbstack to use `-completenames` argument
%       * Update inline documentation
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-12-13
%       * Update to new signature of `PARSESWITCHARG`
%   2020-12-02
%       * Update to make it codegen-compatible
%   2017-12-01
%       * Initial release



%% Check arguments

% FUNCNAME()
% FUNCNAME(PLAIN)
narginchk(0, 1);

% FUNCNAME(___)
% FN = FUNCNAME(___)
nargoutchk(0, 1);

% FUNCNAME()
if nargin < 1 || isempty(plain)
  plain = 'off';
end

% Convert given text of plain into a `matlab.lang.OnOffSwitchState.on` object
plain = onoffstate(plain);



%% Algorithm
% Get callstack
stStack = dbstack(1, '-completenames');

% If stack is not empty and has field 'name' ...
if ~isempty(stStack) && isfield(stStack, 'name')
    % That's our function mame
    chName = stStack(1).name;
% No stack, so called from within base
else
    chName = 'base';
end

% Strip any class/package name?
if plain == matlab.lang.OnOffSwitchState.on
  chName = last(strsplit(chName, '.'));
end



%% Assign output quantities
fcname = chName;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
