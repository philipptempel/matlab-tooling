classdef IsNotEqualTo < matlab.unittest.constraints.BooleanConstraint
  %% ISNOTEQUALTO
  
  
  %% IMMUTABLE PUBLIC PROPERTIES
  properties ( SetAccess = immutable )
    
    ValueWithUnallowedValues
    
  end
  
  
  %% GENERAL METHODS
  methods
    
    function constraint = IsNotEqualTo(value)
      %% ISNOTEQUALTO
      
      
      constraint.ValueWithUnallowedValues = value;
      
    end
    
    
    function bool = satisfiedBy(constraint, actual)
      %% SATISFIEDBY
      
      
      bool = constraint.actualDoesNotMatchValue(actual);
      
    end
    
    
    function diag = getDiagnosticFor(constraint, actual)
      %% GETDIAGNOSTICFOR
      
      
      import matlab.unittest.diagnostics.StringDiagnostic
      
      if constraint.actualDoesNotMatchValue(actual)
        diag = StringDiagnostic('IsNotEqualTo passed.');
      else
        diag = StringDiagnostic(sprintf(...
          'IsNotEqualTo failed.\nActual Size: [%s]\nExpectedSize: [%s]',...
          int2str(size(actual)),...
          int2str(size(constraint.ValueWithUnallowedValues))));
      end
      
    end
    
  end
  
  
  
  %% PROTECTED METHODS
  methods ( Access = protected )
    
    function diag = getNegativeDiagnosticFor(constraint, actual)
      %% GETNEGATIVEDIAGNOSTICFOR
      
      
      import matlab.unittest.diagnostics.StringDiagnostic
      
      if constraint.actualDoesNotMatchValue(actual)
        diag = StringDiagnostic(sprintf(...
          ['Negated IsNotEqualTo failed.\nSize [%s] of '...
          'Actual Value and Expected Value were the same '...
          'but should not have been.'],int2str(size(actual))));
      else
        diag = StringDiagnostic('Negated IsNotEqualTo passed.');
      end
      
    end
    
  end
  
  
  
  %% PRIVATE METHODS
  methods ( Access = private )
    
    function bool = actualDoesNotMatchValue(constraint, actual)
      %% ACTUALDOESNOTMATCHVALUE
      
      
      bool = all(actual ~= constraint.ValueWithUnallowedValues);
      
    end
  end

end
