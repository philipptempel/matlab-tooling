function p = minprime(n)%#codegen
%% MINPRIME Return the smallest prime number smaller than N
%
% P = MINPRIME(N) returns the smallest prime number P that is also smaller than
% N.
%
% Inputs:
%
%   N                   Scalar value used to calculate all prime values until N.
%
% Outputs:
%
%   P                   Smallest prime number in all prime numbers until N.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-07-15
%       * Initial release



%% Algorithm

if n < 2
  p = zeros(1, 0);
  
else
  p = 2;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
