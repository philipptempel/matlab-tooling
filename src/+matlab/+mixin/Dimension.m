classdef ( Abstract ) Dimension < handle
  %% DIMENSION
  %
  % DIMENSION()
  
  
  
  %% ABSTRACT READ-ONLY PROPERTIES
  properties ( Abstract, SetAccess = immutable )
    
    % Number of spatial dimensions i.e., planar == 2, spatial == 3
    NDimension
    
  end
  
  
  
  %% FACTORY METHODS
  methods
    
    function obj = Dimension()
      %% DIMENSION
      
      
    end
    
  end
  
end
