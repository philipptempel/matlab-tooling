function p = maxprime(n)%#codegen
%% MAXPRIME Return the largest prime number smaller than N
%
% P = MAXPRIME(N) returns the largest prime number P that is also smaller than
% N.
%
% Inputs:
%
%   N                   Description of argument N
%
% Outputs:
%
%   P                   Description of argument P



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-07-15
% Changelog:
%   2021-07-15
%       * Initial release



%% Do your code magic here

p = max(primes(n));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
