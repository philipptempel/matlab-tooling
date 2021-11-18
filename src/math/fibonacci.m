function y = fibonacci(n)
%% FIBONACCI Fibonacci numbers.
%
% FIBONACCI(N) returns the N-th Fibonacci number.
%
% The Fibonacci numbers satisfy the relations
%
% Fib(N) = Fib(N-1) + Fib(N-2)    with    Fib(1) = 1, Fib(0) = 0
%
% Fib(N-1)/Fib(N) -> (sqrt(5)-1)/2    as    N -> infinity



%% File information
% Author: Peter J. Acklam <pjacklam@online.no>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr
% URL: http://home.online.no/~pjacklam
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2004-02-09
%       * Initial release


% Check number of input arguments.
narginchk(1, 1);

% Use explicit function.
y = sqrt(1 / 5) * (((1 + sqrt(5)) / 2).^n - ((1 - sqrt(5)) / 2).^n);

% Integer input should give integer output.
k = (n == round(n));
y(k) = round(y(k));


end
