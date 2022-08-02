classdef KWArgs < handle ...
    & dynamicprops ...
    & matlab.mixin.SetGet ...
    & matlab.mixin.Copyable ...
    & matlab.mixin.Heterogeneous
  %% KWARGS Is a python kwargs-like object
  
  
  
  %% READ-ONLY PROPERTIES
  properties ( Hidden, SetAccess = protected )
    
    % Arguments passed
    Original = {};
    
  end
  
  
  
  %% READ-ONLY DEPENDENT PROPERTIES
  properties ( Dependent, SetAccess = protected )
    
    % Raw arguments
    Args
    
  end
  
  
  
  %% HIDDEN READ-ONLY PROPERTIES
  properties ( Hidden, SetAccess = protected )
    
    % Keys only
    Keys = {}
    
    % Values only
    Values = {}
    
    % Dynamic properties we added for each argument
    DynamicProperties = struct();
    
  end
  
  
  
  %% CONSTRUCTOR
  methods
    
    function obj = KWArgs(varargin)
      %% KWArgs
      
      
      
      % One argument fallback
      if nargin == 1
        % Single cell as argument is assumed all arguments
        if iscell(varargin{1})
          varargin = varargin{1};
        
        % Auto-expand structures
        elseif isstruct(varargin{1})
          varargin = varargin{1};
          v = struct2cell(varargin);
          k = fieldnames(varargin);
          varargin = cell(1, 2 * numel(v));
          varargin(1:2:end) = k;
          varargin(2:2:end) = v;
          
        end
        
      end
      
      % Store original input
      obj.Original = varargin;
      
      % Convert 1xN cell array into 2xM array
      varargin = reshape(varargin, 2, []);
      % Store keys and values
      keys = varargin(1,:);
      vals = varargin(2,:);
      
      % Count arguments
      nargs = numel(keys);
      
      % Store processed arguments in here
      processedKV = struct();
      
      % Loop over all arguments
      for iarg = 1:nargs
        % Get key
        key = keys{iarg};
        % And corresponding value
        val = vals{iarg};
        
        % Ensure the property exists before assigning a value
        prop = ensureprop(obj, key);
        
        % Set value on property
        obj.(prop.Name) = val;
        
        % Store or overwrite added property with value in temporary variable
        processedKV.(prop.Name) = val;
        
      end
      
      % Store keys of all arguments and their values separately
      obj.Keys = fieldnames(processedKV);
      obj.Values = struct2cell(processedKV);
      
    end
    
  end
  
  
  
  %% DYNAMIC PROPERTY METHODS
  methods
    
    function prop = ensureprop(obj, name)
      %% ENSUREPROP
      
      
      
      % Find property
      prop = findprop(obj, name);
      
      % Not found...
      if isempty(prop)
        % Create a new property
        prop = addprop(obj, name);
        
      end
      
    end
    
    
    function prop = addprop(obj, name)
      %% ADDPROP
      
      
      
      % Ensure we have a valid MATLAB property name
      name = KWArgs.makeValidName(name);
      
      % Create a dynamic property of the name
      prop = addprop@dynamicprops(obj, name);
      
      % Ensure it won't be saved when the KWArgs object is being saved
      prop.Transient = true;
      
      % Add the dynamic property handle so we can later on delete it
      obj.DynamicProperties.(name) = prop;
      
    end
    
    
    function p = findprop(obj, prop)
      %% FINDPROP
      
      
      
      p = findprop@dynamicprops(obj, KWArgs.makeValidName(prop));
      
    end
    
    
    function rmprop(obj, prop)
      %% RMPROP
      
      
      
      % Ensure we have a dynamic property object
      if ~isa(prop, 'meta.DynamicProperty')
        prop = findprop(obj, prop);
      end
      
      % If the property exists
      if ~isempty(prop)
        % Find index of the property in the keys and remove that
        idx = strcmp(obj.Keys, prop.Name);
        obj.Keys(idx) = [];
        obj.Values(idx) = [];
        
        % Remove the dynamic property
        delete(obj.DynamicProperties.(prop.Name));
        
      end

    end
    
  end
  
  
  
  %% GETTERS
  methods
    
    function v = has(obj, k)
      %% HAS Check if a key exists
      
      
      
      v = any(strcmp(KWArgs.makeValidName(k), obj.Keys));
      
    end
    
    
    function v = get(obj, k, d)
      %% GET Get value or default value if it cannot be found
      %
      % GET'ing an entry from the KWArgs object returns its value or a fallback
      % default and retains in in the internal storage.
      %
      % GET(KEY) returns the value for key if found, otherwise returns `[]`.
      %
      % GET(KEY, DEFAULT) returns the value for key KEY if found, otherwise
      % returns default DEFAULT.
      %
      % Inputs:
      %
      %   KEY         Char array of key to find in case-insensitive manner.
      %
      %   DEFAULT     Default value to return if KEY is not in the KWargs.
      %
      % Outputs:
      % 
      %   V           Value found for KEY or DEFAULT if not found.
      
      
      
      narginchk(1, 3);
      nargoutchk(0, 1);
      
      if nargin < 2 || isempty(k)
        v = get@matlab.mixin.SetGet(obj);
        
        return
      end
      
      % Only allow a single key to be retrieved at a time
      if iscell(k) && nargin > 2
        throw(MException('FOO:BAR', 'Key must be a single key'));
      end
      
      % Default value to return
      if nargin < 3
        d = [];
      end
      
      try
        % Dispatch to the parent's `get` method
        v = get@matlab.mixin.SetGet(obj, k);
      catch
        v = d;
      end
      
    end
    
    
    function v = pop(obj, k, d)
      %% POP Get value from arguments and remmove it
      %
      % POP'ing an entry off the KWArgs object returns its value or the fallback
      % default and removes the Key/Value pair from the internal storage.
      %
      % POP(KEY) returns the value for key if found, otherwise returns `[]`.
      %
      % POP(KEY, DEFAULT) returns the value for key KEY if found, otherwise
      % returns default DEFAULT.
      %
      % Inputs:
      %
      %   KEY         Char array of key to find in case-insensitive manner.
      %
      %   DEFAULT     Default value to return if KEY is not in the KWargs.
      %
      % Outputs:
      % 
      %   V           Value found for KEY or DEFAULT if not found.
      
      
      
      narginchk(2, 3);
      nargoutchk(0, 1);
      
      % Only allow a single key to be retrieved at a time
      if iscell(k) && nargin > 2
        throw(MException('FOO:BAR', 'Key must be a single key'));
      end
      
      % Default default
      if nargin < 3
        d = [];
      end
      
      try
        % Get value using built-in get method
        v = get(obj, k, d);
        
        % Find and remove property
        rmprop(obj, findprop(obj, k));
        
      catch
        v = d;
        
      end
      
    end
    
  end
  
  
  
  %% GETTERS
  methods
    
    function v = get.Args(obj)
      %% GET.ARGS
      
      
      
      v = reshape([obj.Keys ; obj.Values], 1, []);
      
    end
    
  end
  
  
  
  %% SETTERS
  methods
    
    function set.Keys(obj, v)
      %% SET.KEYS
      
      
      
      obj.Keys = reshape(v, 1, []);
      
    end
    
    
    function set.Values(obj, v)
      %% SET.VALUES
      
      
      
      obj.Values = reshape(v, 1, []);
      
    end
    
  end
  
  
  
  %% SET OPERATIONS
  methods
    
    function nobj = intersect(obj, that)
      %% INTERSECT
      
      
      
      % Determine the new keys
      ckeys = intersect(obj.Keys, that.Keys);
      
      % New values
      newargs = cell(2, 0);
      % If there are any keys to retrieve data for
      if numel(ckeys)
        newargs = [ ckeys ; get(obj, ckeys) ];
      end
      
      % New object with new data
      nobj = KWArgs(newargs{:});
      
    end
    
    
    function nobj = union(obj, that)
      %% UNION
      
      
      
      % Determine the new keys
      [ckeys, ia, ib] = union(obj.Keys, that.Keys);
      
      % New values
      newargs = cell(2, 0);
      if numel(ckeys)
        
        % Get keys and values from `OBJ`
        if numel(ia)
          okeys = obj.Keys(ia);
          ovals = get(obj, okeys);
          newargs = horzcat(newargs, [ okeys ; ovals ]);
          
        end
        
        % Get keys and values from `THAT`
        if numel(ib)
          tkeys = that.Keys(ib);
          tvals = get(that, tkeys);
          newargs = horzcat(newargs, [ tkeys ; tvals ]);
          
        end
        
      end
      
      % New object with new data
      nobj = KWArgs(newargs{:});
      
    end
    
    
    function nobj = setdiff(obj, that)
      %% SETDIFF
      
      
      
      % Determine the new keys
      ckeys = setdiff(obj.Keys, that.Keys);
      
      % New values
      newargs = cell(2, 0);
      % If there are any keys to retrieve data for
      if numel(ckeys)
        newargs = [ ckeys ; get(obj, ckeys) ];
      end
      
      % New object with new data
      nobj = KWArgs(newargs{:});
      
    end
    
    
    function nobj = setxor(obj, that)
      %% SETXOR
      
      
      
      % Determine the new keys
      [ckeys, ia, ib] = setxor(obj.Keys, that.Keys);
      
      % New values
      newargs = cell(2, 0);
      if numel(ckeys)
        
        % Get keys and values from `OBJ`
        if numel(ia)
          okeys = obj.Keys(ia);
          ovals = get(obj, okeys);
          newargs = horzcat(newargs, [ okeys ; ovals ]);
          
        end
        
        % Get keys and values from `THAT`
        if numel(ib)
          tkeys = that.Keys(ib);
          tvals = get(that, tkeys);
          newargs = horzcat(newargs, [ tkeys ; tvals ]);
          
        end
        
      end
      
      % New object with new data
      nobj = KWArgs(newargs{:});
      
    end
    
    
    function nobj = merge(obj, that)
      %% MERGE
      
      
      
      % New object with new data
      nobj = KWArgs([ cell(obj) , cell(that) ]);
      
    end
    
  end
  
  
  
  %% CONVERSION
  methods
    
    function c = cell(obj)
      %% CELL
      
      
      
      c = obj.Args;
      
    end
    
  end
  
  
  
  %% OVERRIDDEN METHODS
  methods ( Access = protected )
    
    function copbj = copyElement(obj)
      %% COPYELEMENT
      
      
      
      % Main copy
      copbj = copyElement@matlab.mixin.Copyable(obj);
      
      % Get all dynamic properties of the source object
      dynprops = struct2array(obj.DynamicProperties);
      
      % Copy all dynamic properties
      for dp = dynprops
        % Create new property
        addprop(copbj, dp.Name);
        
        % Add value to property
        copbj.(dp.Name) = obj.(dp.Name);
        
      end
      
    end
    
  end
  
  
  
  %% STATIC METHODS
  methods ( Static )
    
    function n = makeValidName(k)
      %% MAKEVALIDNAME
      
      
      
      n = matlab.lang.makeValidName(replace(k, {'+', '-'}, {'Plus', 'Minus'}));
      
    end
    
  end

end
