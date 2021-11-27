function b = wraprad(a)%#codegen
%% WRAPRAD Map angles measured in radians to the interval [-pi,pi).
%
% B = WRAPRAD(A) maps the angles in A to their equivalent in the interval
% [-pi,pi) by adding or subtracting the appropriate multiple of 2*pi.
%
% See also
%   WRAPDEG WRAPGRAD UNWRAPDEG UNWRAP



%% File information
% Author: Peter J. Acklam <pjacklam@online.no>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% URL: http://home.online.no/~pjacklam
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2003-10-13
%       * Initial release



%% Algorithm

% check number of input arguments
narginchk(1, 1);

TWOPI = 2 * pi;

b = a - TWOPI * floor((a + pi) / TWOPI);


end
