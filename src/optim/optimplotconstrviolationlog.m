function stop = optimplotconstrviolationlog(x, optimValues, state, varargin)
%% OPTIMPLOTCONSTRVIOLATIONLOG Plot max constraint violation into a semilogy plot
%
% In essence, this function is a wrapper to OPTIMPLOTCONSTRVIOLATION which sets
% the y-axis scale to be logarithmic after initializing the plot.
% 
% STOP = OPTIMPLOTCONSTRVIOLATIONLOG(X, OPTIMVALUES, STATE) plots
% OPTIMVALUES.constrviolation into a semi-log-y axis.
%
% See also:
%   OPTIMPLOTCONSTRVIOLATION



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-06-07
% Changelog:
%   2021-06-07
%       * Initial release



%% Do your code magic here

% Pass down to the non-log plot variant
stop = optimplotconstrviolation(x, optimValues, state, varargin{:});

% If in init state, also set the y-axis scale to be logarithmic
switch state
  case 'init'
    set(gca(), 'YScale', 'log');
    
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
