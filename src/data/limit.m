function l = limit(v, mi, ma)%#codegen
% LIMIT the given value between minimum and maximum
%
% LIMIT(V, MI) limits all values in V to be at larger or equal to MI.
%
% LIMIT(V, MI, MA) additionally limits all values in V to be at most MA large.
%
% Inputs:
%
%   V                   MxN array or values to limit.
%
%   MI                  Lower limit of each value.
%
%   MA                  Upper limit of each value.
%
% Outputs:
%
%   L                   MxN array of limited values of V.
%
% See also:
%   MIN
%   MAX



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-06-21
% Changelog:
%   2021-06-21
%       * Add codegen support, remove try/catch block
%   2018-02-06
%       * Initial release



%% Valdiate arguments

% LIMIT(V, MI)
% LIMIT(V, MI, MA)
narginchk(2, 3);
% LIMIT(___)
% L = LIMIT(___);
nargoutchk(0, 1);

if nargin < 2 || isempty(mi)
  mi = -Inf;
end

if nargin < 3 || isempty(ma)
  ma = +Inf;
end



%% Do your code magic here

% Limit v by the lower boundary, then by the upper boundary.
l = min(ma, max(v, mi));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
