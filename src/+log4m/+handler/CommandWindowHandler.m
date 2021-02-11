classdef CommandWindowHandler < log4m.handler.Handler
  %% COMMANDWINDOWHANDLER
  
  
  
  %% FACTORY METHODS
  methods
    
    function obj = CommandWindowHandler()
      %% COMMANDWINDOWHANDLER
      
      
      obj@log4m.handler.Handler();
      
    end
    
  end
  
  
  
  %% HANDLER METHODS
  methods
    
    function handle(obj, rcrd)
      %% HANDLE
      %
      % HANDLE(RECORD)
      
      
      fprintf('%s\n', parseLogEntry(obj, rcrd));
      
    end
    
  end
  
end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
