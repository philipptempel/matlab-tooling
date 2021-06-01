function f = first(mixed, off)
% FIRST gets the first element of the given argument
%
%   Inputs:
%
%   MIXED               Can be a MATLAB variable of any content. This function
%                       tries its best to handle getting the "last" item
%                       correctly. Depending on the class of the argument, the
%                       last item is differently defined:
%                         double: last(mixed) => mixed(end)
%                         cell:   last(cell) => cell{end}
%
%   OFF                 Offset from start to retrieve. Defaults to 0.
%
%   Outputs:
%
%   F                   The first item in the given arguument



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2020-11-20
% Changelog:
%   2020-11-20
%     * Add support for an offset to retrieve (last - offset)-th item.
%   2019-03-18
%     * Initial release



%% Parse arguments

% FIRST(MIXED)
% FIRST(MIXED, OFF)
narginchk(1, 2);

% FIRST(...)
% L = FIRST(...)
nargoutchk(0,  1);

% Determine offset
if nargin < 2 || isempty(off)
  off = 0;
end



%% Do your code magic here
switch class(mixed)
  case 'double'
    f = mixed(1 + off);
  case 'cell'
    f = mixed{1 + off};
  otherwise
    f = builtin('first', mixed);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
