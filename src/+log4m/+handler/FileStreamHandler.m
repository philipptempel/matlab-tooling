classdef FileStreamHandler < log4m.handler.Handler
  %% FILESTREAMHANDLER
  
  
  
  %% READ-ONLY PROPERTIES
  properties ( SetAccess = immutable )
    
    File
    
    FileID
    
  end
  
  
  
  %% FACTORY METHODS
  methods
    
    function obj = FileStreamHandler(file, permission)
      %% FILESTREAMHANDLER
      
      
      narginchk(1, Inf);
      nargoutchk(0, 1);
      
      if nargin < 2 || isempty(permission)
        permission = 'W';
      end
      
      obj@log4m.handler.Handler();
      
      obj.File = file;
      
      obj.FileID = fopen(obj.File, permission);
      
    end
    
    
    function delete(obj)
      %% DELETE
      
      
      % Close open file handle
      fclose(obj.FileID);
      
    end
    
  end
  
  
  
  %% HANDLER METHODS
  methods
    
    function handle(obj, rcrd)
      %% HANDLE
      %
      % HANDLE(RECORD)
      
      
      fprintf(obj.FileID, '%s\n', parseLogEntry(obj, rcrd));
      
    end
    
  end
  
end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
