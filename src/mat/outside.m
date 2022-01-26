function f = outside(v, l, u)%#codegen
%% OUTSIDE Check if value is outside of an interval
%
% OUTSIDE(VALUE, LOWER, UPPER) checks if VALUE is outside the interval defined
% through LOWER and UPPER boundary.
%
% Inputs:
%
%   VALUE                   Description of argument VALUE
% 
%   LOWER                   Description of argument LOWER
% 
%   UPPER                   Description of argument UPPER
%
% Outputs:
%
%   F                       Description of argument F



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-01-26
% Changelog:
%   2022-01-26
%       * Initial release



%% Parse arguments

% OUTSIDE(V, L, U)
narginchk(3, 3);

% OUTSIDE(___)
% F = OUTSIDE(___)
nargoutchk(0, 1);



%% Algorithm

f = v < l | u < v;



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
