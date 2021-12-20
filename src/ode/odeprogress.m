function status = odeprogress(t, y, flag, varargin)
% ODEPROGRESS creates a progress bar window for use as simulation progress info
%
%   When the function ODEPROGRESS is passed to an ODE solver as the 'OutputFcn'
%   property, i.e. options = odeset('OutputFcn', @odeprogress), the solver calls
%   ODEPROGRESS(T, Y, '') after every timestep.  The ODEPROGRESS displays a
%   progress bar window with a cancel button so that the current simulation
%   progress can be read.
%
%   Inputs:
%
%   T                   Description of argument T
%
%   Y                   Description of argument Y
%
%   FLAG                Description of argument FLAG
%
%   Outputs:
%
%   STATUS              Description of argument STATUS



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-10-25
%       * Update to display figure name and text more consistently over the
%       various call modes
%   2017-11-20
%       * Implement missing logic for canceling the ODE callback in case the
%       stop button has been pressed
%       * Add info on how the call-syntax for the three differently flagged
%       function calls are
%   2017-09-17
%       * Initial release



%% Initialize function
persistent hWait

% Assume stop button wasn't pushed.
status = 0;
% Check Stop button every 1 sec.
dCallbackDelay = 1;

% support odeprogress(t, y) [v5 syntax]
if nargin < 3 || isempty(flag)
    flag = '';
end



%% Do your code magic here

switch ( flag )
    
    % ODEPROGRESS(t, y, '')
    case ''
        % No figure exists
        if isempty(hWait)
            error(message('PHILIPPTEMPEL:MATLAB:ODEPROGRESS:NotCalledWithInit'));
        
        % Figure still open
        elseif ishghandle(hWait)

            try
                % Has stop button been pushed?
                if hWait.UserData.stop == 1
                    status = 1;
                
                else
                    dMaxTime = hWait.UserData.tspan(2);

                    dProgress = t(1)/dMaxTime;
                    waitbar(dProgress, hWait, sprintf('Simulation time: %.4f/%.2f', t(1), dMaxTime));
                    
                end
            catch ME
                error(message('PHILIPPTEMPEL:MATLAB:odeprogress:ErrorUpdatingWindow', ME.message));
            end

        end
    
    % ODEPROGRESS(tspan, y0, 'init')
    case 'init'
        hWait = waitbar( ...
            0 ...
            , 'Initializing...' ...
            , 'Name', 'ODE Progress' ...
            , 'CreateCancelBtn', @in_cb_stopbutton ...
        );
        set( ...
            findobj(hWait.Children, 'Tag', 'TMWWaitbarCancelButton') ...
            , 'String', 'Stop' ...
        );
        hWait.UserData.tspan = [ min(t) , max(t) ];
        hWait.UserData.stop = 0;
    
    % ODEPROGRESS([], [], 'done')
    case 'done'
        set( ...
            findobj(hWait.Children, 'Tag', 'TMWWaitbarCancelButton') ...
            , 'String', 'Done' ...
            , 'Enable', 'off' ...
          );
        % Reset the persistent progress bar window
        hWindow = hWait;
        hWait = [];
        
        delete(hWindow);
        
    otherwise
        error(message('PHILIPPTEMPEL:MATLAB:ODEPROGRESS:UnrecognizedFlag', flag));
    
end
% END switch ( flag )


end


function in_cb_stopbutton(~, ~)
%% IN_CB_STOPBUTTON


% Get current callback object and its figure
[~, fig] = gcbo();

% Add `stop` marker to figure
fig.UserData.stop = 1;
% Update axes text to say "Stopping..."
ax = findobj(fig.Children, 'Type', 'axes');
set( ...
  ax.Title ...
  , 'String', 'Stopping...' ...
);
% Update button text
set( ...
  findobj(fig.Children, 'Tag', 'TMWWaitbarCancelButton') ...
  , 'String', 'Stopping...' ...
)



end 

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
