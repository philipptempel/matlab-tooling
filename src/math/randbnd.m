function r = randbnd(sz, bnd, varargin)
%% RANDBND Create uniformly distributed pseudorandom numbers on an interval
%
% R = RANDBND(N, BND) creates an NxN array of pseudorandom numbers using RAND in
% the interval defined by BND.
%
% R = RANDBND([N, M, P, ...], BND) creates an NxMxPx... array of pseudorandom
% numbers.
%
% R = RANDBND(SZ, BND, ...) passes additional parameters through to the
% underlying call to RAND.
%
% Inputs:
%
%   SZ                      Scalar of NxMxPx... array of dimensions of array of
%                           pseudorandom numbers.
% 
%   BND                     1x2 array of interval boundaries in which the
%                           pseudorandom numbers should lie.
%
% Outputs:
%
%   R                       Array of size SZ of pseudorandom numbers in the
%                           interval defined through BND.
%
% See also:
%   RAND



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-07-21
% Changelog:
%   2022-07-21
%       * Initial release



%% Parse arguments

% RANDBND(N, BND)
% RANDBND(N, BND, CLASSNAME)
% RANDBND(N, BND, 'like', Y)
narginchk(2, Inf);

% RANDBND(___)
% R = RANDBND(___)
nargoutchk(0, 1);

% RANDBND(N, BND, CLASSNAME)
% RANDBND(N, BND, 'like', Y)
if nargin < 2 || isempty(bnd)
  bnd = [ 0.0 , 1.0 ];
  
end



%% Algorithm

% Extract interval boundaries
a = bnd(1);
b = bnd(2);

% And get the pseudorandom numbers
r = ( b - a ) .* rand(sz, varargin{:}) + a;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
