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
% Date: 2022-02-01
% Changelog:
%   2022-02-01
%       * Update inline documentation
%       * Fix logic so that P will always be larger than N
%   2021-11-17
%       * Update H1 to correct format
%   2021-07-15
%       * Initial release



%% Parse arguments

% NEXTPRIME(N)
narginchk(1, 1);

% NEXTPRIME(___)
% P = NEXTPRIME(___)
nargoutchk(0, 1);



%% Algorithm


% Initialize counter
n_ = n;

% Set flag for `while` loop
found = false;

% While prime not found
while ~found
  % Incresaase counter
  n_ = n_ + 1;
  
  % Evaluate prime number
  p = max(primes(n_));
  
  % And flag if found or not
  found = p > n;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
