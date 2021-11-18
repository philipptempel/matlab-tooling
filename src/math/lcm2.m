function c = lcm2(x)
%% LCM2 Least common multiple of all elements.
%
% LCM2(X) is the least common multiple of all elements in X.
%
% See also
%   GCD LCM GCDALL



%% File information
% Author: Peter J. Acklam <pjacklam@online.no>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% URL: http://home.online.no/~pjacklam
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-03-03
%       * Initial release



%% Process

% Check input arguments.
narginchk(1, 1);

if ~isnumeric(x) || ~isreal(x)
    error( 'Argument must be numeric and real.' );
end

if ~isequal( round(x), x )
    error( 'Argument must contain integers only.' );
end

% Now find least common multiple.
n = numel(x);
c = x(1);
for i = 1:n
    if ( x(i) ~= 0 )
        c = c/gcd(c,x(i))*x(i);
    end
end

end
