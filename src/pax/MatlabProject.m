classdef MatlabProject < handle
  %% MATLABPROJECT
  
  
  
  %% PUBLIC READ-ONLY PROPERTIES
  properties ( SetAccess = immutable )
    
    Root
    
  end
  
  
  
  %% CONSTRUCTOR METHODS
  methods
    
    function obj = MatlabProject(rwd)
      %% MATLABPROJECT
      
      
      
      obj.Root = rwd;
      
    end
    
  end
  
  
  
  %% PATH METHODS
  methods
    
    function f = data(obj, varargin)
      %% DATA
      
      
      
      f = fullfile(obj, 'data', varargin{:});
      
    end
    
    
    function f = dev(obj, varargin)
      %% DEV
      
      
      
      f = fullfile(obj, 'dev', varargin{:});
      
    end
    
    
    function f = fullfile(obj, varargin)
      %% FULLFILE
      
      
      
      f = fullfile(obj.Root, varargin{:});
      
    end
    
    
    function f = local(obj, varargin)
      %% LOCAL
      
      
      
      f = fullfile(obj, 'local', varargin{:});
      
    end
    
    
    function f = root(obj, varargin)
      %% ROOT
      
      
      
      f = fullfile(obj, varargin{:});
      
    end
    
    
    function f = src(obj, varargin)
      %% SRC
      
      
      
      f = fullfile(obj, 'src', varargin{:});
      
    end
    
    
    function f = test(obj, varargin)
      %% TEST
      
      
      
      f = fullfile(obj, 'test', varargin{:});
      
    end
    
  end
  
  
  
  %% PROJECT METHODS
  methods
    
    function finish(obj)
      %% FINISH
      
      
      
      run(root(obj, 'finish.m'));
      
    end
    
    
    function startup(obj)
      %% STARTUP
      
      
      
      run(root(obj, 'startup.m'));
      
    end
    
  end
  
  
  
  %% STATIC METHODS
  methods ( Static )
    
    function mp = this()
      %% THIS
      
      
      
      % Initialize empty project
      mp = [];
      
      % First, check in the caller's directory tree
      caller = dbstack(1, '-completenames');
      if ~isempty(caller)
        mp = MatlabProject.from(fileparts(caller(1).file));
      end
      
      % Then, check in the current working directory's tree
      if isempty(mp)
        mp = MatlabProject.from(pwd());
        
      end
      
    end
    
  end
  
  
  
  %% PROTECTED STATIC METHODS
  methods ( Static , Access = protected )
    
    function mp = from(rwd)
      %% FROM
      
      
      
      % Convert path into a JAVA file object
      rwd = java.io.File(fullpath(rwd));
      froots = rwd.listRoots();
      
      % Loop indicator
      stop = false;
      
      % Loop up one directory at a time
      while ~stop
        found = isempty(rwd) || ... # skip if path empty
          ... # skip if current directory matches file system root
          any(arrayfun(@(r) strcmp(r, rwd), froots)) || ...
          ... % skip if found a .MLPROJECT file
          2 == exist(fullfile(char(rwd), '.mlproject'), 'file');
        
        if found
          stop = true;
          
        else
          stop = false;
          rwd = java.io.File(rwd.getParent());
          
        end
        
      end
      
      % Return a project object if we found a `.MLPROJECT` file and if it's not
      % the root directory
      if ~( isempty(rwd) || any(arrayfun(@(r) strcmp(r, rwd), froots)) )
          mp = MatlabProject(fullfile(char(rwd)));
          
      % Nothing found
      else
        mp = [];
        
      end
      
    end
    
  end
  
end
