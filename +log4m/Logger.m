classdef Logger < handle
  %% LOGGER
  
  
  
  %% PUBLIC PROPERTIES
  properties
    
    Handler log4m.handler.Handler = log4m.handler.CommandWindowHandler()
    
    LogLevel log4m.LogLevel = log4m.LogLevel.Error
    
  end
  
  
  
  %% FACTORY METHODS
  methods
    
    function obj = Logger()
      %% LOGGER
      
      
      
      % Set default logging level
      obj.LogLevel = log4m.LogLevel.Error;
      % Default logger
      obj.Handler = log4m.handler.CommandWindowHandler();
      
    end
    
  end
  
  
  
  %% LOGGER METHODS
  methods
    
    function log(obj, lvl, msg, varargin)
      %% LOG
      %
      % LOG(LEVEL, MESSAGE, ARG1, ARG2, ...)
      
      
      % Bail out if the logger is silent
      if lvl < obj.LogLevel || obj.LogLevel == log4m.LogLevel.Off
        return
        
      end
      
      % Get the stack trace for the call
      stack = stacktrace(obj);
      
      % Prepare the record structure
      rcrd = struct( ...
          'message',    sprintf(msg, varargin{:}) ...
        , 'level',      lvl ...
        , 'time',       datestr(now()) ...
        , 'file',       stack.file ...
        , 'function',   stack.name ...
        , 'line',       stack.line ...
      );
      
      % And let the handler handle how/where the message is displayed
      for handler = obj.Handler
        try
          handle(handler, rcrd);
          
        catch me
        end
        
      end
      
    end
    
    
    function trace(obj, msg, varargin)
      %% TRACE
      
      
      log(obj, log4m.LogLevel.Trace, msg, varargin{:});
      
    end
    
    
    function debug(obj, msg, varargin)
      %% DEBUG
      
      
      log(obj, log4m.LogLevel.Debug, msg, varargin{:});
      
    end
    
    
    function info(obj, msg, varargin)
      %% INFO
      
      
      log(obj, log4m.LogLevel.Info, msg, varargin{:});
      
    end
    
    
    function success(obj, msg, varargin)
      %% SUCCESS
      
      
      log(obj, log4m.LogLevel.Success, msg, varargin{:});
      
    end
    
    
    function warning(obj, msg, varargin)
      %% WARNING
      
      
      log(obj, log4m.LogLevel.Warning, msg, varargin{:});
      
    end
    
    
    function error(obj, msg, varargin)
      %% TRACE
      
      
      log(obj, log4m.LogLevel.Error, msg, varargin{:});
      
    end
    
    
    function critical(obj, msg, varargin)
      %% CRITICAL
      
      
      log(obj, log4m.LogLevel.Critical, msg, varargin{:});
      
    end
    
  end
  
  
  
  %% INTERNAL METHODS
  methods ( Access = protected )
    
    function st = stacktrace(obj)
      %% STRACKTRACE
      
      
      st = dbstack(2);
      
      % If the logger was called from anywhere without a trace e.g., the command
      % window, then it will be empty and we will have to set some sane defaults
      if isempty(st)
        st(1).file = '';
        st(1).name = 'base';
        st(1).line = 0;
        
      elseif strcmp(st(1).file, 'Logger.m')
        st(1) = [];
        
      end
      
    end
    
  end
  
end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
