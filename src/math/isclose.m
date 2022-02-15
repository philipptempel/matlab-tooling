function f = isclose(c, g, atol, rtol)%#codegen
%% ISCLOSE Determines whether two numbers are close to each other.
%
% A number C is close to a number G if the following equation holds:
% 
% $$\mathrm{abs}(C - G) \leq ( a_{tol} + r_{tol} \mathrm{abs}(G) )$$
% 
% ISCLOSE(C, G) checks if C is close to G with respect to an absolute and
% relative tolerance.
%
% ISCLCOSE(C, G, ATOL) compare using absolute tolerance ATOL.
%
% ISCLCOSE(C, G, ATOL, RTOL) compare using relative tolerance RTOL.
%
% Inputs:
%
%   C                       NxM array of candidate values.
%
%   G                       NxM array of ground truth values.
%
%   ATOL                    Absolute tolerance in comparing values. Defaults to
%                           `1e4 * eps(class(G))`.
%
%   RTOL                    Relative tolerance in comparing values. Defaults to
%                           `1e-8`.
%
% Outputs:
%
%   F                       NxM array of logical values where C is/are close to
%                           G.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-15
% Changelog:
%   2022-02-15
%     * Change order of arguments G and C to have a more fluent function
%     declaration
%     * Fix missing equal sign in comparison (change 'less than' to 'less than
%     or equal'
%   2021-11-17
%     * Update H1 to correct format
%   2021-11-04
%     * Update H1 documentation
%   2021-04-30
%     * Fix error when either `atol` or `rtol` are passed as vectors/arrays of
%     relative tolerances
%   2021-04-23
%     * Revert previous commit and now assume `A` to be the gorund truth for
%     comparison
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

% ISCLOSE(C, G);
% ISCLOSE(C, G, ATOL);
% ISCLOSE(C, G, ATOL, RTOL);
narginchk(2, 4);
% F = ISCLOSE(___);
nargoutchk(0, 1);

% F = ISCLOSE(C, G)
if nargin < 3 || isempty(atol)
  atol = 1e4 * eps(class(g));
  
end

% F = ISCLOSE(C, G, ATOL)
if nargin < 4 || isempty(rtol)
  rtol  = 1e-8;
  
end



%% Algorithm

% @see https://numpy.org/doc/stable/reference/generated/numpy.isclose.html?highlight=isclose#numpy.isclose
f = abs(g - c) <= ( atol + rtol * abs(g) );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
