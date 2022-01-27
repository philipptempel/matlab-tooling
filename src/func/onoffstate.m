function res = onoffstate(arg, moreon)%#codegen
%% ONOFFSTATE parses the toggle arg to a valid and unified char.
%
% RES = ONOFFSTATE(ARG) parses toggle argument ARG to match a unified
% true/false value. The following mapping is used internally:
%       'on'      ->  'on'
%       'yes'     ->  'on'
%       'please'  ->  'on'
%       'off'     ->  'off'
%       'no'      ->  'off'
%       'never'   ->  'off'
% If ARG cannot be parsed, it defaults to 'off'.
%
% Inputs:
%
%   ARG                 Argument as given to the function call.
%
%   MOREON              1xK cell array of additional values that should be
%                       considered `ON`.
%
% Outputs:
%
%   RES                 Resulting MATLAB.LANG.ONOFFSWITCHSTATE object.
%
% See also:
%   MATLAB.LANG.ONOFFSWITCHSTATE



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-01-27
% Changelog:
%   2022-01-27
%       * Rename to `ONOFFSTATE`
%       * Remove assertion of arguments
%       * Remove argument `ADD_OFF` as it's not needed technically if we have
%       only `ADD_ON`
%       * Rename argument `ADD_ON` to `MOREON`
%   2021-12-13
%       * Return an object of type `MATLAB.LANG.ONOFFSWITCHSTATE` instead of
%       returning a char array
%   2020-11-17
%       * Change author's email domain to `ls2n.fr`
%   2017-08-31
%       * Remove necessity for argument ARG to be non-empty
%   2016-09-18
%       * Add option to pass additional strings for 'on' or 'off' result
%   2016-09-07
%       * Initial release



%% Default arguments

% ONOFFSTATE(ARG)
% ONOFFSTATE(ARG, MOREON)
narginchk(1, 2);

% ONOFFSTATE(___)
% RES = ONOFFSTATE(___)
nargoutchk(0, 1);

% ONOFFSTATE(ARG)
if nargin < 2 || isempty(moreon)
    moreon = {};
end



%% Algorithm

res = matlab.lang.OnOffSwitchState(any(strcmpi(arg, [ 'on' , 'yes' , 'please' , moreon ])));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.

