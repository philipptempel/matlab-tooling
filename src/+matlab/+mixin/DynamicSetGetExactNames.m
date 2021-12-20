classdef DynamicSetGetExactNames < handle ...
    & dynamicprops ...
    & matlab.mixin.SetGetExactNames ...
    & matlab.mixin.Copyable
  %% DYNAMICSETGET
  
  
  
  %% PUBLIC READ-ONLY DEPENDENT PROPERTIES
  properties ( Dependent , Hidden , SetAccess = protected )
    
    % Keys of all properties
    Keys
    
  end
  
  
  
  %% HIDDEN READ-ONLY PROPERTIES
  properties ( Hidden, SetAccess = protected )
    
    % Dynamic properties we added for each argument
    DynamicProperties
    
  end
  
  
  
  %% CONSTRUCTOR
  methods
    
    function obj = DynamicSetGetExactNames(varargin)
      %% DYNAMICSETGETEXACTNAMES
      
      
      
      narginchk(0, Inf);
      
      % Cases
      %   DYNAMICSETGETEXACTNAMES({Name, Value, ...})
      % or
      %   DYNAMICSETGETEXACTNAMES(STRUCT())
      if nargin == 1
        % DYNAMICSETGETEXACTNAMES({Name, Value, ...})
        % Single cell as argument is assumed all arguments
        if iscell(varargin{1})
          varargin = varargin{1};
        
        % DYNAMICSETGETEXACTNAMES(STRUCT())
        elseif isstruct(varargin{1})
          varargin = varargin{1};
          v = struct2cell(varargin);
          k = fieldnames(varargin);
          varargin = cell(1, 2 * numel(v));
          varargin(1:2:end) = k;
          varargin(2:2:end) = v;
          
        end
        
      end
      
      % Call parent constructors
      obj@handle();
      obj@dynamicprops();
      obj@matlab.mixin.SetGetExactNames();
      obj@matlab.mixin.Copyable();
      
      % Convert 1xN varargin cell array into 2xM array (columns are now
      % Key/Value pairs)
      varargin = reshape(varargin, 2, []);
      % Get keys in alphabetically sorted order and accordingly sorted values
      [keys, idx] = sort(varargin(1,:));
      vals = varargin(2,idx);
      
      % Count arguments
      nargs = numel(keys);
      
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
        
      end
      
    end
    
  end
  
  
  
  %% CONVERSION METHODS
  methods
    
    function s = struct(obj)
      %% STRUCT
      
      
      
      s = get(obj);
      
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
      name = obj.makeValidName(name);
      
      % Create a dynamic property of the name
      prop = addprop@dynamicprops(obj, name);
      
      % Configure property
      prop.Transient = true;
      prop.NonCopyable = false;
      
      % Add the dynamic property handle so we can later on delete it
      obj.DynamicProperties = horzcat(obj.DynamicProperties, prop);
      
    end
    
    
    function p = findprop(obj, prop)
      %% FINDPROP
      
      
      
      p = findprop@dynamicprops(obj, obj.makeValidName(prop));
      
    end
    
    
    function rmprop(obj, prop)
      %% RMPROP
      
      
      
      % Ensure we have a dynamic property object
      if ~isa(prop, 'meta.DynamicProperty')
        prop = findprop(obj, prop);
      end
      
      % If the property exists
      if ~isempty(prop)
        % Remove the dynamic property
        delete(obj.DynamicProperties(strcmp(prop.Name, {obj.DynamicProperties.Name})));
        
      end

    end
    
    
    function del(obj, k)
      %% DEL
      %
      % DEL(OBJ, KEY) removes property identified by key `KEY`.
      
      
      
      rmprop(obj, k);
      
    end
    
  end
  
  
  
  %% GETTERS
  methods
    
    function v = get.Keys(obj)
      %% GET.KEYS
      
      
      
      v = {obj.DynamicProperties.Name};
      
    end
    
    
    function v = has(obj, k)
      %% HAS Check if a key exists
      
      
      
      v = any(strcmp(obj.makeValidName(k), obj.Keys));
      
    end
    
    
    function v = get(obj, k, d)
      %% GET Get value or default value if it cannot be found
      %
      % GET'ing an entry from the Configuration object returns its value or a
      % fallback default and retains in in the internal storage.
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
      %   DEFAULT     Default value to return if KEY is not found.
      %
      % Outputs:
      % 
      %   V           Value found for KEY or DEFAULT if not found.
      
      
      
      narginchk(1, 3);
      nargoutchk(0, 1);
      
      % GET(OBJ)
      if nargin < 2 || isempty(k)
        v = get@matlab.mixin.SetGetExactNames(obj);
      
      % GET(OBJ, NAME)
      % GET(OBJ, NAME, DEFAULT)
      else
      
        % Default value to return
        if nargin < 3
          d = [];
        end

        try
          % Dispatch to the parent's `get` method
          v = get@matlab.mixin.SetGetExactNames(obj, k);

        catch
          v = d;

        end
        
      end
      
    end
    
  end
  
  
  
  %% SETTERS
  methods
    
    function s = set(obj, varargin)
      %% SET
      
      
      
      % SET(OBJ, ___)
      narginchk(1, Inf);
      
      % SET(OBJ, S)
      % SET(OBJ, NAME, VALUE)
      % SET(OBJ, NAMEARRAY, VALUEARRAY)
      % SET(OBJ, NAME1, VALUE1, NAME2, VALUE2, ..., NAMEN, VALUEN)
      if nargin > 1
        p = varargin{1};
        % SET(OBJ, S)
        if isstruct(p)
          narginchk(2, 2);
          p = fieldnames(p);
          
        % SET(OBJ, NAME, VALUE)
        % SET(OBJ, NAME1, VALUE1, NAME2, VALUE2, ..., NAMEN, VALUEN)
        elseif ischar(p)
          narginchk(3, Inf);
          p = varargin(1:2:end);
          
        % SET(OBJ, NAMEARRAY, VALUEARRAY)
        elseif iscell(p)
          narginchk(3, 3);
          
        else
        end
        
        % Count properties
        np = numel(p);
        
        % Ensure all properties exist
        for ip = np:-1:1
          ensureprop(obj, p{ip});
        end
        
      end
      
      % Dispatch to parent SET method
      s_ = set@matlab.mixin.SetGetExactNames(obj, varargin{:});
      
      % S = SET(___)
      if nargout > 0
        s = s_;
      end
      
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
      nobj = mambo.simulator.Simulator(newargs{:});
      
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
      
      % Get class name
      cls = str2func(class(obj));
      
      % New object with new data
      nobj = cls(newargs{:});
      
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
      
      % Get class name
      cls = str2func(class(obj));
      
      % New object with new data
      nobj = cls(newargs{:});
      
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
      
      % Get class name
      cls = str2func(class(obj));
      
      % New object with new data
      nobj = cls(newargs{:});
      
    end
    
    
    function nobj = merge(obj, that)
      %% MERGE
      
      
      
      % Copy this object
      nobj = copy(obj);
      
      % Loop over the other body's data
      tkeys = that.Keys;
      ntkeys = numel(tkeys);
      
      % Loop over each of the other Configuration object's keys
      for ickey = ntkeys:-1:1
        % Get key and value
        k = tkeys{ickey};
        v = that.(k);
        % Ensure the property exists
        ensureprop(nobj, k);
        % And append the value
        nobj.(k) = v;
        
      end
      
    end
    
  end
  
  
  
  %% OVERRIDDEN METHODS
  methods ( Access = protected )
    
    function copbj = copyElement(obj)
      %% COPYELEMENT
      
      
      
      % Main copy
      copbj = copyElement@matlab.mixin.Copyable(obj);
      
      % Get all dynamic properties of the source object
      dps = obj.DynamicProperties;
      
      % Copy all dynamic properties
      for dp = dps
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
