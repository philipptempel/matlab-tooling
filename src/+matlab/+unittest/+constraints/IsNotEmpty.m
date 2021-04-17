classdef IsNotEmpty < matlab.unittest.constraints.IsEmpty
  %% ISNOTEMPTY
  
  
  %% IMMUTABLE PUBLIC PROPERTIES
  properties ( SetAccess = immutable )
    
    ValueWithUnallowedValues
    
  end
  
  
  %% GENERAL METHODS
  methods
    
    function constraint = IsNotEmpty()
      %% ISNOTEMPTY
      
    end
    
    
    function bool = satisfiedBy(~, actual)
      %% SATISFIEDBY
      
      
      bool = ~isempty(actual);
      
    end
    
    
    function diag = getDiagnosticFor(constraint, actual)
      %% GETDIAGNOSTICFOR
      
      
      import matlab.unittest.diagnostics.StringDiagnostic
      
      if constraint.satisfiedBy(actual)
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
      
      if constraint.satisfiedBy(actual)
        diag = StringDiagnostic(sprintf(...
          ['Negated IsNotEmpty failed.\nSize [%s] of '...
          'Actual Value and Expected Value were the same '...
          'but should not have been.'],int2str(size(actual))));
      else
        diag = StringDiagnostic('Negated IsNotEqualTo passed.');
      end
      
    end
    
  end
  
  
  
  %% PRIVATE METHODS
  methods ( Access = private )
    
    function bool = actualIsNotEmpty(constraint, actual)
      %% ACTUALDOESNOTMATCHVALUE
      
      
      bool = all(actual ~= constraint.ValueWithUnallowedValues);
      
    end
  end

end
