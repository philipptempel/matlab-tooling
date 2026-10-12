classdef OutputRecorder < handle
  % OUTPUTRECORDER records every call of an ODE solver to its output function
  %
  %   rec = OutputRecorder();
  %   rec.StopAtCall = 5;
  %   bdf(f, tspan, y0, odeset('OutputFcn', @rec.call));
  %
  %   Use `StopAtCall` to request a stop with the n-th call. The `init` and `done`
  %   calls never request a stop.
  
  
  
  %% PROPERTIES
  properties
    
    % Flags of each call: 'init', '' (step), 'done'
    Flags = {}
    
    % Time argument of each call
    Times = {}
    
    % State argument of each call
    States = {}
    
    % Additional arguments of each call
    Extras = {}
    
    % Number of the call that requests the solver to stop
    StopAtCall = Inf
    
  end
  
  
  
  %% METHODS
  methods
    
    function stop = call(this, t, y, flag, varargin)
      %% CALL is the output function
      
      
      this.Flags{end+1} = flag;
      this.Times{end+1} = t;
      this.States{end+1} = y;
      this.Extras{end+1} = varargin;
      
      stop = ~any(strcmp(flag, {'init', 'done'})) && this.numCalls() >= this.StopAtCall;
      
    end
    
    
    function n = numCalls(this)
      %% NUMCALLS returns the number of calls so far
      
      
      n = numel(this.Flags);
      
    end
    
  end
  
end
