function f = isclose(g, c, atol, rtol)%#codegen
%% ISCLOSE Determines whether two numbers are close to each other.
%
% A number B is close to a number A if the following equation holds:
% 
% $$\mathrm{abs}(a - b) \leq atol + rtol \, \mathrm{abs}(b)$$
% 
% ISCLOSE(G, C) checks if C is close to G with respect to an absolute and
% relative tolerance.
%
% ISCLCOSE(G, C, ATOL) compare using absolute tolerance ATOL.
%
% ISCLCOSE(G, C, ATOL, RTOL) compare using relative tolerance RTOL.
%
% Inputs:
%
%   G                 NxM array of ground truth values.
%
%   C                 NxM array of candidate values.
%
%   ATOL              Absolute tolerance to compare with. Defaults to 1e4*eps.
%
%   RTOL              Relative tolerance to compare with. Defaults to 1e-8.
%
% Outputs:
%
%   F                 NxM array of logical values where C is/are close to G.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-04-30
% Changelog:
%   2021-04-30
%     * Fix error when either `atol` or `rtol` are passed as vectors/arrays of
%     relative tolerances.
%   2021-04-23
%     * Revert previous commit and now assume `A` to be the gorund truth for
%     comparison.
%     * Rename arguments `A` to `G` and `B` to `C` for `G`round and `C`andidate
%     * Update H1 documentation accordingly
%   2021-04-22
%     * Update comparison to use maximum of either |A| or |B| when determining
%     relative equality of data
%   2021-03-16
%     * Use data type/class of `A` to determine the appropriate value of `EPS`
%   2020-11-11
%     * Initial release



%% Parse arguments

% ISCLOSE(G, C);
% ISCLOSE(G, C, ATOL);
% ISCLOSE(G, C, ATOL, RTOL);
narginchk(2, 4);
% F = ISCLOSE(G, C, ...);
nargoutchk(0, 1);

% F = ISCLOSE(G, C)
if nargin < 3 || isempty(atol)
  atol = 1e4 * eps(class(g));
end

% F = ISCLOSE(G, C, ATOL)
if nargin < 4 || isempty(rtol)
  rtol  = 1e-8;
end



%% Check

f = abs(g - c) < atol + rtol .* abs(g);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
