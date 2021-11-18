function g = gcd2(x)
%% GCD2 Greatest common divisor of all elements.
%
% GCD2(X) is the greatest common divisor of all elements in X.
%
% See also
%   GCD LCM LCMALL



%% File Information
% Author: Peter J. Acklam <pjacklam@online.no>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% URL: http://home.online.no/~pjacklam
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-02-09
%       * Initial release



% Check number of input arguments.
narginchk(1, 1);

% Check array values.
if ~isreal(x)
    error('Argument must be a numeric and real array.');
end

% Any NaN or +/-Inf in input gives NaN output.
if any(~isfinite(x))
    g = NaN;
    return;
end

% Check the finite elements.
if ~isequal(x, round(x))
    error('All finite elements must be real integers.');
end

% Now find greatest common divisor.
n = numel(x);
g = 0;
for i = 1 : n
    g = gcd(g, x(i));
    if g == 1
        break
    end
end

end
