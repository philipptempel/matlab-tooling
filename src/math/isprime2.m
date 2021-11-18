function isp = isprime2(X)
%% ISPRIME2 True for prime numbers.
%
% ISPRIME2(X) is 1 for the elements of X which are prime, 0 otherwise.
%
% See also
%   FACTOR PRIMES ISPRIME



%% File information
% Author: Peter J. Acklam <pjacklam@online.no>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% URL: http://home.online.no/~pjacklam
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-10-03
%       * Initial release

% check number of input arguments
narginchk(1, 1);

if isempty(X)
    isp = false(size(X));
    return
end

isp = logical(X);
n = max(X(:));
maxfact = floor( sqrt(n) );                  % Maximum possible factor.
p = primes( maxfact );                         % All possible factors.
for k = 1:numel(isp)
    if X(k) <= maxfact
        isp(k) = any( X(k) == p );            % Is it among the primes?
    else
        isp(k) = all( rem( X(k), p ) );     % Is it divisible by any prime?
    end
end

end
