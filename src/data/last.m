function l = last(mixed, off)
% LAST gets the last element of the given argument
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
%   OFF                 Offset from end to retrieve. Defaults to 0.
%
%   Outputs:
%
%   L                   The last item in the given arguument



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2020-11-20
% Changelog:
%   2020-11-20
%     * Add support for an offset to retrieve (last - offset)-th item.
%   2019-03-18
%     * Update to use `BUILTIN` when an unsupported data type is passed as input
%     argument.
%   2017-09-19
%     * Initial release



%% Parse arguments

% LAST(MIXED)
% LAST(MIXED, OFF)
narginchk(1, 2);

% LAST(...)
% L = LAST(...)
nargoutchk(0,  1);

% Determine offset
if nargin < 2 || isempty(off)
  off = 0;
end



%% Retrieve last element based on its class

switch class(mixed)
  case 'double'
    l = mixed(end - off);
  case 'cell'
    l = mixed{end - off};
  otherwise
    l = builtin('last', mixed);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
