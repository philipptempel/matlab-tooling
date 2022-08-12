classdef ClassInputParser < handle
  %% CLASSINPUTPARSER
  
  
  
  %% CONSTRUCTOR
  methods
    
    function obj = ClassInputParser()
      %% CLASSINPUTPARSER
    end
    
  end
  
  
  
  %% CLASS METHODS
  methods ( Static, Sealed )
    
    function [args, pargs, nargs] = parse(cls, varargin)
      %% PARSE
      
      
      
      narginchk(0, Inf);
      nargoutchk(0, 3);
      
      ip = feval(str2func([ cls , '.inputParser']));
      
      parse(ip, varargin{:});
      
      args  = ip.Results;
      pargs = ip.Unmatched;
      nargs = numel(fieldnames(args));
      
    end
    
  end
  
  
  
  %% STATIC PROTECTED METHODS
  methods ( Static, Access = protected )
    
    function ip = inputParser()
      %% INPUTPARSER
      
      
      
      ip = inputParser();
      ip.CaseSensitive   = false;
      ip.KeepUnmatched   = true;
      ip.PartialMatching = true;
      ip.StructExpand    = true;
      
    end
    
  end
  
end
