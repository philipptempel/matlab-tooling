function l = limit(v, vmin, vmax)%#codegen
% LIMIT the given value between minimum and maximum
%
% LIMIT(V, VMIN) limits all values in V to be at larger or equal to VMIN.
%
% LIMIT(V, VMIN, VMAX) additionally limits all values in V to be at most VMAX
% large.
%
% Inputs:
%
%   V                       MxN array or values to limit.
%
%   VMIN                    Lower limit of each value.
%
%   VMAX                    Upper limit of each value.
%
% Outputs:
%
%   L                       MxN array of limited values of V.
%
% See also:
%   MIN MAX



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-10-24
% Changelog:
%   2022-10-24
%       * Fix H1 documentation
%       * Inline documentation fixes
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-06-21
%       * Add codegen support, remove try/catch block
%   2018-02-06
%       * Initial release



%% Parse Arguments

% LIMIT(V, VMIN)
% LIMIT(V, VMIN, VMAX)
narginchk(2, 3);

% LIMIT(___)
% L = LIMIT(___);
nargoutchk(0, 1);

% LIMIT(V)
if nargin < 2 || isempty(vmin)
  vmin = -Inf;
end

% LIMIT(V, VMIN)
if nargin < 3 || isempty(vmax)
  vmax = +Inf;
end



%% Algorithm

% Limit v by the upper boundary, then by the lower boundary.
l = min(vmax, max(v, vmin));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
