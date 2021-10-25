function stopalltimers()
% STOPALLTIMERS stops all timers whether they are visible or not
%
%   STOPALLTIMERS stops all currently running timers regardless their
%   visibility. Displays a warning if a timer could not be stopped.
%
%   See also:
%   TIMERFINDALL TIMER/STOP



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-10-25
% Changelog:
%   2021-10-25
%       * Wrap timers' `stop` into `try/catch` to not fail if one timer fails
%       stopping
%   2018-08-26
%       * Revert back to a simple for-loop. Feels more real looping, doesn't it?
%   2017-01-21
%       * Make use of arrayfun over simple loops
%   2016-09-02
%       * Initial release



%% Perform

% Get all timers
tmrs = timerfindall();

% Loop over each timer and stop it if it's running
for iT = 1:numel(tmrs)
  if strcmp(tmrs(iT).Running, 'on')
    try
      stop(tmrs(iT));
      
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
