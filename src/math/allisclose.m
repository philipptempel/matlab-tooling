function f = allisclose(c, g, atol, rtol, varargin)%#codegen
%% ALLISCLOSE Check if elements are close to each other
%
% ALLISCLOSE(C, G) checks if all elements of A are close to respective elements
% of B. Here, "close to" means in the numeric sense and within floating point
% precision.
%
% ALLISCLOSE(C, G, ATOL) determine closeness with absolute tolerance ATOL.
%
% ALLISCLOSE(C, G, ATOL, RTOL) determine closeness with relative tolerance RTOL.
%
% ALLISCLOSE(___, ...) passes additional options to underlying `ALL` call.
%
% Inputs:
%
%   C                   NxM array of candidate values.
%
%   G                   NxM array of ground truth values.
%
%   ATOL                Absolute tolerance in comparing values. Defaults to
%                       `1e4 * eps(class(G))`.
%
%   RTOL                Relative tolerance in comparing values. Defaults to
%                       `1e-8`.
%
% Outputs:
%
%   F                   True/false flag denoting if all elements of C are close
%                       to or not close to G.
%
% See also:
%   ISCLOSE ALL



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-22
% Changelog:
%   2022-02-22
%     * Update argument order to match that of `ISCLOSE`
%   2021-11-17
%     * Update H1 to correct format
%   2021-11-04
%     * Update H1 documentation to include defaults of `ATOL` and `RTOL`
%   2021-04-23
%     * Rename arguments `A` to `G` and `B` to `C` for `G`round and `C`andidate
%     * Update H1 documentation accordingly
%     * Update algorithm to crunch down logicals to a single value independent
%     of the dimensions of A or B
%   2020-11-11
%     * Initial release



%% Parse arguments

% ISCLOSE(C, G);
% ISCLOSE(C, G, ATOL);
% ISCLOSE(C, G, ATOL, RTOL);
narginchk(2, 4);
% F = ISCLOSE(C, G, ...);
nargoutchk(0, 1);

% F = ISCLOSE(C, G)
if nargin < 3
  atol = [];
end

% F = ISCLOSE(C, G, ATOL)
if nargin < 4
  rtol = [];
end



%% Compare

f = all(isclose(c, g, atol, rtol), varargin{:});

while ~isscalar(f)
  f = all(f, varargin{:});
end



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
