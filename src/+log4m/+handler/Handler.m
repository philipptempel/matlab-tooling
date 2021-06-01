classdef ( Abstract ) Handler < handle ...
    & matlab.mixin.Heterogeneous
  %% HANDLER
  
  
  
  %% READ-ONLY PROPERTIES
  properties ( SetObservable )
    
    % Format for messages
    Format = ''
    
    % Parts of the message format split for easier replacing
    FormatTokens = {}
    
    % Parsed message string
    FormatMessage = ''
    
  end
  
  
  
  %% FACTORY METHODS
  methods
    
    function obj = Handler(fmt)
      %% HANDLER
      
      
      addlistener(obj, 'Format', 'PostSet', @log4m.handler.Handler.postSetListener);
      
      if nargin < 1 || isempty(fmt)
        obj.Format = '%{time}s [%{level}s]: %{message}s';
      end
      
    end
    
  end
  
  
  
  %% HANDLER METHODS
  methods
    
    function handle(obj, rcrd)
      %% HANDLE
      %
      % HANDLE(RECORD)
      
      
      
    end
    
    
    function m = parseLogEntry(obj, rcrd)
      %% PARSELOGENTRY
      
      
      args = cellfun(@(c) rcrd.(c), obj.FormatTokens, 'UniformOutput', false);
      
      m = sprintf(obj.FormatMessage, args{:});
      
    end
    
  end
  
  
  
  %% INTERNAL METHODS
  methods ( Access = protected )
    
    function parseFormat(obj)
      %% PARSEFORMAT
      
      
      try
        % Find tokens user put in the message
        [matches, tokens] = regexpi(obj.Format, '{([^}]+)}', 'match', 'tokens');
        tokens = [tokens{:}];
        
        % Remove tokens from original format and store the resulting "clean"
        % message format string
        obj.FormatMessage = replace(obj.Format, matches, '');
        
        % Store tokens for latter use
        obj.FormatTokens = tokens;
        
      catch me
      end
      
    end
    
  end
  
  
  
  %% EVENT LISTENER CALLBACKS
  methods ( Static )
    
    function postSetListener(src, evnt)
      %% POSTSETLISTENER
      
      
      obj = evnt.AffectedObject;
      
      switch src.Name
        case 'Format'
          parseFormat(obj);
          
      end
      
    end
    
  end
  
end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
