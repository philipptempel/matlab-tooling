function f = allisclose(a, b, atol, rtol, varargin)%#codegen
%% ALLISCLOSE Check if elements are close to each other
%
% ALLISCLOSE(A, B) checks if all elements of A are close to respective elements
% of B. Here, "close to" means in the numeric sense and within floating point
% precision.
%
% ALLISCLOSE(A, B, ATOL) determine closeness with absolute tolerance ATOL.
%
% ALLISCLOSE(A, B, ATOL, RTOL) determine closeness with relative tolerance RTOL.
%
% ALLISCLOSE(___, ...) passes additional options to underlying `ALL` call.
%
% Inputs:
%
%   A               Array of appropriate dimensions to check whether it is close
%                   to B or not. Array A contains the candidates.
%
%   B               Array of appropriate dimenions that are the reference
%                   values.
%
%   ATOL            Absolute tolerance to use in comparing values of A and B.
%
%   RTOL            Relative toleraance to use in comparing values of A and B.
%
% Outputs:
%
%   F               Array of common dimensions.
%
% See also:
%   ISCLOSE ALL



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-11
% Changelog:
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
if nargin < 3
  atol = [];
end

% F = ISCLOSE(A, B, ATOL)
if nargin < 4
  rtol = [];
end



%% Compare

f = all(isclose(a, b, atol, rtol), varargin{:});



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
