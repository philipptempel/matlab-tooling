function p = nextprime(n)%#codegen
%% NEXTPRIME Return the first prime number larger than integer N
%
% NEXTPRIME(N) returns the next prime number larger than N.
%
% Inputs:
%
%   N                   Start point to calculate next prime from.
%
% Outputs:
%
%   P                   Next prime number larger than N.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-07-15
%       * Initial release



%% Parse arguments

narginchk(1, 1);
nargoutchk(0, 1);



%% Algorithm


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
