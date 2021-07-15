function c = collatz(n)
%% COLLATZ Return the Collatz number of N
%
% C = COLLATZ(N) calculates the Collatz number for number N
%
% Inputs:
%
%   N                   Description of argument N
%
% Outputs:
%
%   C                   Description of argument C



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-07-15
% Changelog:
%   2021-07-15
%       * Initial release



%% Do your code magic here

c = zeros(size(n));

% Find indices of even numbers
idxE = mod(n, 2) == 0;

% Collatz conjecture
c(idxE)  = n ./ 2;
c(~idxE) = 3 .* n + 1;



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
