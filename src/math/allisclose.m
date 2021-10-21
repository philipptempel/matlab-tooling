function f = allisclose(g, c, atol, rtol, varargin)%#codegen
%% ALLISCLOSE Check if elements are close to each other
%
% ALLISCLOSE(G, C) checks if all elements of A are close to respective elements
% of B. Here, "close to" means in the numeric sense and within floating point
% precision.
%
% ALLISCLOSE(G, C, ATOL) determine closeness with absolute tolerance ATOL.
%
% ALLISCLOSE(G, C, ATOL, RTOL) determine closeness with relative tolerance RTOL.
%
% ALLISCLOSE(___, ...) passes additional options to underlying `ALL` call.
%
% Inputs:
%
%   G                 NxM array of ground truth values.
%
%   C                 NxM array of candidate values.
%
%   ATOL              Absolute tolerance to use in comparing values of A and B.
%
%   RTOL              Relative toleraance to use in comparing values of A and B.
%
% Outputs:
%
%   F                 True/false flag denoting if all elements of C are close to
%                     or not close to G.
%
% See also:
%   ISCLOSE ALL



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-04-23
% Changelog:
%   2021-04-23
%     * Rename arguments `A` to `G` and `B` to `C` for `G`round and `C`andidate
%     * Update H1 documentation accordingly
%     * Update algorithm to crunch down logicals to a single value independent
%     of the dimensions of A or B
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
if nargin < 3
  atol = [];
end

% F = ISCLOSE(G, C, ATOL)
if nargin < 4
  rtol = [];
end



%% Compare

f = all(isclose(g, c, atol, rtol), varargin{:});

while ~isscalar(f)
  f = all(f, varargin{:});
end



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
