function r = randnbnd(sz, bnd, varargin)
%% RANDNBND Create normally distributed pseudorandom numbers on an interavl
%
% R = RANDNBND(N, BND) creates an NxN array of pseudorandom numbers sing RANDN
% in the interval defined by BND.
%
% R = RANDNBND([N, M, P, ...], BND) creates an NxMxPx... array of pseudorandom
% numbers.
%
% R = RANDNBND(SZ, BND, ...) passes additional parameters through to the
% underlying call to RANDN.
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
%   RANDN



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-07-21
% Changelog:
%   2022-07-21
%       * Initial release



%% Parse arguments

% RANDNBND(N, BND)
% RANDNBND(N, BND, CLASSNAME)
% RANDNBND(N, BND, 'like', Y)
narginchk(2, Inf);

% RANDNBND(___)
% R = RANDNBND(___)
nargoutchk(0, 1);

% RANDNBND(N, BND, CLASSNAME)
% RANDNBND(N, BND, 'like', Y)
if nargin < 2 || isempty(bnd)
  bnd = [ 0.0 , 1.0 ];
  
end



%% Algorithm

% Extract interval boundaries
a = bnd(1);
b = bnd(2);

% And get the pseudorandom numbers
r = ( b - a ) .* randn(sz, varargin{:}) + a;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
