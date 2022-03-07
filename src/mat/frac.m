function f = frac(v, s)
%% FRAC Return the fractional part of a number
%
% F = FRAC(V) returns the fractional part F (the digits after the decimal
% separator) from the number(s) V.
%
% F = FRAC(V, S) scales the fractional by S decimals.
%
% Inputs:
%
%   V                       NxMx...xK array of numbers.
%
%   S                       NxMx...xK array of scaling factors to scale decimals
%                           by. For example, S == 2 shifts the decimal point by
%                           two points to the right i.e.,
%                           FRAC(1.2345, 2) = 23.45
%
% Outputs:
%
%   F                       NxMx...xK array of fractional parts.
%
% See also:
%   FIX



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-07
% Changelog:
%   2022-03-07
%       * Initial release



%% Parse arguments

% FRAC(V)
% FRAC(V, S)
narginchk(1, 2);

% F = FRAC(___)
nargoutchk(0, 1);

% FRAC(V)
if nargin < 2 || isempty(s)
  s = 0;
end



%% Algorithm

% Simple like that
f = ( v - fix(v) ) * ( 10 ^ s );



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
