function f = inside(v, l, u, flopen)%#codegen
%% INSIDE Check if value inside an interval
%
% INSIDE(VALUE, LOWER, UPPER) checks if VALUE is inside the interval defined
% through LOWER and UPPER boundary.
%
% INSIDE(___, FLOPEN) checks if VALUE is inside the open interval.
%
% Inputs:
%
%   VALUE                   NxK array of values.
% 
%   LOWER                   NxK array of lower interval boundaries.
% 
%   UPPER                   NxK array of upper interval boundaries.
%
%   FLOPEN                  Flag whether VALUE should be contained in the closed
%                           (FLOPEN == false) or the open (FLOPEN == true)
%                           interval.
%
% Outputs:
%
%   F                       NxK array where VALUE is inside the closed/open
%                           interval defiend by LOWER and UPPER.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-09
% Changelog:
%   2022-03-09
%       * Fix algorithm for checking if a value is inside the interval
%       * Update H1 documentation
%       * Add argument `FLOPEN`
%   2022-01-26
%       * Initial release



%% Parse arguments

% INSIDE(VALUE, LOWER, UPPER)
% INSIDE(VALUE, LOWER, UPPER, FLOPEN)
narginchk(3, 4);

% INSIDE(___)
% F = INSIDE(___)
nargoutchk(0, 1);

% INSIDE(VALUE, LOWER, UPPER)
if nargin < 4 || isempty(flopen)
  flopen = matlab.lang.OnOffSwitchState.off;
end



%% Algorithm

% Parse open-interval flag
flopen = onoffstate(flopen);

% Check on the open interval
if flopen == matlab.lang.OnOffSwitchState.on
  f = l < v & v < u;
  
% Check on the closed interval
else
  f = l <= v & v <= u;
  
end



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
