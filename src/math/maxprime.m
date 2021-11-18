function p = maxprime(n)%#codegen
%% MAXPRIME Return the largest prime number smaller than N
%
% P = MAXPRIME(N) returns the largest prime number P that is also smaller than
% N.
%
% Inputs:
%
%   N                   Scalar value used to calculate all prime values until N.
%
% Outputs:
%
%   P                   Largest prime number in all prime numbers until N.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-07-15
%       * Initial release



%% Algorithm

p = max(primes(n));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
