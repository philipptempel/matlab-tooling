function [s, p, n] = siprefix(v, b)
%% SIPREFIX Returns the SI prefix for V.
%
% S = SIPREFIX(V) returns the SI prefix symbol S for each value in V.
%
% [S, P] = SIPREFIX(V) also returns the SI prefix power P for each value in V.
%
% [S, P, N] = SIPREFIX(V) also returns the SI prefix name N for each value in V.
%
% Inputs:
%
%   V                   NxM array of numbers to the return the SI prefix for.
%
% Outputs:
%
%   S                   NxM cell array of SI prefix symbols.
%
%   P                   NxM array of SI prefix powers.
%
%   N                   NxM cell array of SI prefix names.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-02-11
% Changelog:
%   2021-02-11
%       * Initial release



%% Parse arguments

% SIPREFIX(V)
% SIPREFIX(V, B)
narginchk(1, 2);
% SIPREFIX(V)
% S = SIPREFIX(...)
% [S, P] = SIPREFIX(...)
% [S, P, N] = SIPREFIX(...)
nargoutchk(0, 3);

% Default base: 10
if nargin < 2 || isempty(b)
  b = 10;
end



%% Parse

persistent prefixes

if isempty(prefixes)
  % Powers
  powers = num2cell(-24:3:24);
  
  % Names
  names = { ...
      'yocto' ...
    , 'zepto' ...
    , 'atto' ...
    , 'femto' ...
    , 'pico' ...
    , 'nano' ...
    , 'micro' ...
    , 'milli' ...
    , '' ...
    , 'kilo' ...
    , 'Mega' ...
    , 'Giga' ...
    , 'Tera' ...
    , 'Peta' ...
    , 'Exa' ...
    , 'Yetta' ...
    , 'Yotta' ...
  };

  % Symbols
  symbols = cell(size(names));
  for iname = 1:numel(names)
    if ~isempty(names{iname})
      symbols{iname} = names{iname}(1);
      
    else
      symbols{iname} = '';
      
    end
    
  end
  
  % Combined prefixes
  prefixes = struct( ...
      'name', names ...
    , 'symbol', symbols ...
    , 'power', powers ...
  );

end

% Get value's power in the respective base
powers = log(v) ./ log(b);
powers(powers == -Inf) = 0;
powers = uint64(powers);

% And select the prefixes
m = arrayfun(@(pwr) prefixes(pwr == [prefixes.power]), powers);

% S = SIPREFIX(...)
s = [m.symbol];

% [S, P] = SIPREFIX(...)
if nargout > 1
  p = [m.power];
  
end

% [S, P, N] = SIPREFIX(...)
if nargout > 2
  n = [m.name];
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
