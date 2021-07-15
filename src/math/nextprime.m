function p = nextprime(n)%#codegen
%% NEXTPRIME Return the first prime number larger than integer N
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


n_ = n;

p = [];

while isempty(p) || p < n
  p = max(primes(n_));
  n_ = n_ + 1;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
