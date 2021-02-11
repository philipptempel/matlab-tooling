classdef LogLevel
  %% LOGLEVEL



  %% READ-ONLY PROPERTIES
  properties ( SetAccess = immutable )

    Severity
    
    Color

  end



  %% ENUMERATES
  enumeration
    
    Off       (0, 'black')
    
    All       (1, 'black')

    Trace     (5, 'gray')

    Debug     (10, 'gray')

    Info      (20, 'blue')

    Success   (25, 'green')

    Warning   (30, 'orange')

    Error     (40, 'red')

    Critical  (50, 'red')

  end
  
  
  
  
  %% FACTORY METHODS
  methods
    
    function obj = LogLevel(severity, col)
      %% LogLevel
      
      
      obj.Severity = severity;
      obj.Color = col;
      
    end
    
  end
  
  
  
  %% COMPARISON METHODS
  methods
    
    function f = lt(this, that)
      %% LT
      
      
      f = double(this) < double(that);
      
    end
    
    
    function f = le(this, that)
      %% LE
      
      
      f = double(this) <= double(that);
      
    end
    
    
    function f = gt(this, that)
      %% GT
      
      
      f = double(this) > double(that);
      
    end
    
    
    function f = ge(this, that)
      %% GE
      
      
      f = double(this) >= double(that);
      
    end
    
    
    function f = eq(this, that)
      %% EQ
      
      
      f = double(this) == double(that);
      
    end
    
    
    function f = ne(this, that)
      %% NE
      
      
      f = double(this) ~= double(that);
      
    end
    
  end
  
  
  
  %% CONVERTER METHODS
  methods
    
    function d = double(obj)
      %% DOUBLE
      
      
      if numel(obj) == 1
        d = obj.Severity;
        
      else
        d = reshape([obj.Severity], size(obj));
        
      end
      
    end
    
  end
  

end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
