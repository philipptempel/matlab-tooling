function v = optsget(options, name, default, flag)
%% OPTSGET Get an options value from an options structure
%
% V = OPTSGET(OPTIONS, NAME, DEFAULT)
%
% Inputs:
%
%   OPTIONS                 Description of argument OPTIONS
% 
%   NAME                    Description of argument NAME
% 
%   DEFAULT                 Description of argument DEFAULT
% 
%   FLAG                    Description of argument FLAG
%
% Outputs:
%
%   V                       Description of argument V



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-28
% Changelog:
%   2022-02-28
%       * Initial release



%% Parse arguments

% OPTSGET(OPTIONS, NAME, DEFAULT)
% OPTSGET(OPTIONS, NAME, DEFAULT, FLAG)
narginchk(3, 4);

% V = OPTSGET(___)
nargoutchk(0, 1);

% Undocumented way of quickly getting a value from the options structure
if nargin > 3 && isequal(char(flag), 'fast')
  v = optsgetfast(options, name, default);
  return
end



%% Algorithm

% Initialize return value
v = [];

% No options given?
if isempty(options)
  % Default value returned
  v = default;
  return;
  
end

% Get allowed names and requested name in lower case
names = fieldnames(options);
names_low = lower(names);
name_low = lower(name);

j = strmatch(name_low, names_low);

% If no matches
if isempty(j)
  v = default;
  
  return

% Or more than one match
elseif length(j) > 1
  % Check for any exact matches (in case any names are subsets of others)
  k = strmatch(name_low, names, 'exact');
  
  if length(k) == 1
    j = k;
  else
    
    matches = strjoin(names(j), ', ');
    
    error(message('MATLAB:odeget:AmbiguousPropName',name,matches));
    
  end
  
end

% Get the value
v = options.(names{j});

% Last but not least, check if the value found is empty, in which case we will
% return the default
if isempty(v)
  v = default;
  
end


end



function v = optsgetfast(options, name, default)
%% OPTSGETFAST



if isfield(options, name) && ~isempty(options.(name))
  v = options.(name);
  
else
  v = default;
  
end

end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
