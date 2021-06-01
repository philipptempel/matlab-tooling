classdef Identifiable < handle & matlab.mixin.Copyable
  %% IDENTIFIABLE
  
  
  
  %% READ-ONLY PROPERTIES
  properties ( SetAccess = private )
    
    % Object ID
    ID 
    
  end
  
  
  
  %% GENERAL METHODS
  methods
    
    function obj = Identifiable()
      %% IDENTIFIABLE
      
      
      % Create a unique object ID
      obj.ID = char(java.util.UUID.randomUUID());
      
    end
    
  end
  
  
  
  %% COMPARATORS
  methods
    
    function f = eq(this, that)
      %% EQ
      
      
      f = strcmp(char(this), char(that));
      
    end
    
    
    function f = ne(this, that)
      %% NE
      
      
      f = ~eq(this, that);
      
    end
    
  end
  
  
  
  %% CONVERSION
  methods
    
    function c = char(this)
      %% CHAR
      
      
      if numel(this) > 1
        c = reshape({this.ID}, size(this));
      else
        c = this.ID;
      end
      
    end
    
  end
  
  
  
  %% MIXIN METHODS
  methods ( Access = protected )
    
    function copbj = copyElement(obj)
      %% COPYELEMENT
      
      
      copbj = copyElement@matlab.mixin.Copyable(obj);
      copbj.ID = char(java.util.UUID.randomUUID());
      
    end
    
  end
  
end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
