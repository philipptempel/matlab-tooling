function deletealltimers(all)
%% DELETEALLTIMERS deletes all timers whether they are visible or not
%
% DELETEALLTIMERS stops all currently running timers regardless their
% visibility. Displays a warning if a timer could not be stopped.
%
% See also:
%   TIMERFINDALL STOPALLTIMERS TIMER/STOP



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-11-16
% Changelog:
%   2021-11-16
%       * Initial release



%% Parse arguments

% DELETEALLTIMERS()
% DELETEALLTIMERS(TRUE)
narginchk(0, 1);

% DELETEALLTIMERS(___)
nargoutchk(0, 0);

if nargin < 1 || isempty(all)
  all = false;
end

if ischar(all)
  all = strcmp('on', parseswitcharg(all));
end



%% Perform

% Get all timers
tmrs = timerfindall();

% Loop over each timer and delete it if it's stopped
for iT = 1:numel(tmrs)
  % If timer is not running or we should delete all timers
  if strcmp(tmrs(iT).Running, 'off') || all
    try
      % Stop timer
      stop(tmrs(iT));
      % Then delete object
      delete(tmrs(iT));
      
    catch me
      warning(me.identifier, '%s', me.message);
      
    end
    
  end
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
