function f = isclose(a, b, atol, rtol)%#codegen
%% ISCLOSE Determines whether two numbers are close to each other.
%
% A number A is close to a number B if the following equation holds:
% 
% $$\mathrm{abs}(a - b) \leq atol + rtol \, \mathrm{abs}(a)$$
% 
% ISCLOSE(A, B) checks if A and B are close to each other with respect to an
% absolute and relative tolerance.
%
% ISCLCOSE(A, B, ATOL) compare using absolute tolerance ATOL.
%
% ISCLCOSE(A, B, ATOL, RTOL) compare using relative tolerance RTOL.
%
% Inputs:
%
%   A                   NxM array of values to coampare.
%
%   B                   NxM array of values to compare against.
%
%   ATOL                Absolute tolerance to compare with. Defaults to 1e4*eps.
%
%   RTOL                Relative tolerance to compare with. Defaults to 1e-8.
%
% Outputs:
%
%   F                   Flag whether A is close to B or not.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-03-16
% Changelog:
%   2021-03-16
%     * Use data type/class of `A` to determine the appropriate value of `EPS`
%   2020-11-11
%     * Initial release



%% Parse arguments

% ISCLOSE(A, B);
% ISCLOSE(A, B, ATOL);
% ISCLOSE(A, B, ATOL, RTOL);
narginchk(2, 4);
% F = ISCLOSE(A, B, ...);
nargoutchk(0, 1);

% F = ISCLOSE(A, B)
if nargin < 3 || isempty(atol)
  atol = 1e4 * eps(class(a));
end

% F = ISCLOSE(A, B, ATOL)
if nargin < 4 || isempty(rtol)
  rtol  = 1e-8;
end



%% Check

f = abs(a - b) < atol + rtol * abs(a);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
