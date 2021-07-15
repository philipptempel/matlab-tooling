function p = minprime(n)%#codegen
%% MINPRIME Return the smallest prime number smaller than N
%
% P = MINPRIME(N) returns the smallest prime number P that is also smaller than
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
