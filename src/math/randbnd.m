function r = randbnd(ab, varargin)
%% RANDBND Create uniformly distributed pseudorandom numbers on an interval
%
% R = RANDBND(AB, N) creates an NxN array of pseudorandom numbers using RAND in
% the interval defined by AB.
%
% R = RANDBND(AB, [N, M, P, ...]) creates an NxMxPx... array of pseudorandom
% numbers.
%
% R = RANDBND(AB, SZ, ...) passes additional parameters through to the
% underlying call to RAND.
%
% Inputs:
% 
%   AB                      1x2 array of interval boundaries in which the
%                           pseudorandom numbers should lie.
%
%   SZ                      Scalar of NxMxPx... array of dimensions of array of
%                           pseudorandom numbers.
%
% Outputs:
%
%   R                       Array of size SZ of pseudorandom numbers in the
%                           interval defined through AB.
%
% See also:
%   RAND



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-07-27
% Changelog:
%   2022-07-27
%       * Change function declaration and move interval boundaries to first
%       argument slot
%   2022-07-21
%       * Initial release



%% Parse arguments

% RANDBND(AB)
% RANDBND(AB, N)
% RANDBND(AB, N, CLASSNAME)
% RANDBND(AB, N, 'like', Y)
narginchk(1, Inf);

% RANDBND(___)
% R = RANDBND(___)
nargoutchk(0, 1);



%% Algorithm

% Extract interval boundaries
a = ab(1);
b = ab(2);

% And get the pseudorandom numbers
r = ( b - a ) .* rand(varargin{:}) + a;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
