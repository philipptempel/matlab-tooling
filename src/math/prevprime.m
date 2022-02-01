function p = prevprime(n)%#codegen
%% PREVPRIME Return the first prime number smaller than integer N
%
% PREVPRIME(N) returns the first prime number smaller than N.
%
% Inputs:
%
%   N                   Start point to calculate previous prime from.
%
% Outputs:
%
%   P                   Previous prime number smaller than N.



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

% PREVPRIME(N)
narginchk(1, 1);

% PREVPRIME(___)
% P = PREVPRIME(___)
nargoutchk(0, 1);



%% Algorithm


% Initialize counter
n_ = n;

% Set flag for `while` loop
found = false;

% While prime not found
while ~found
  % Decrease counter
  n_ = n_ - 1;
  
  % Evaluate prime number
  p = max(primes(n_));
  
  % And flag if found or not
  found = p < n;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
