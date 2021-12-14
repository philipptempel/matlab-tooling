function b = bump(x)
%% BUMP Bump function
%
%   B = BUMP(X) is the bump function over the space of X.
%
%   See: https://en.wikipedia.org/wiki/Bump_function
%
%   Inputs:
%
%   X                   1xK vector at which to evaluate the bump function.
%
%   Outputs:
%
%   B                   Kx1 vector of the evaluated bump function



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2018-11-27
%       * Initial release



%% Validate arguments
try
  narginchk(1, 1);
  nargoutchk(0, 1);
  
  validateattributes(x, {'numeric'}, {'nonempty', 'vector', 'nondecreasing', 'finite', 'nonnan', 'nonsparse'}, mfilename, 'x');
  
catch me
  throwAsCaller(me);
end



%% Calculate bump
% Selector vector of x \in (-1,1)
idxX = -1 < x & x < 1;

% Init bump
b = zeros(size(x));

% Calculate bump for the inner area
b(idxX) = exp(-1 ./ ( 1 - x(idxX).^ 2 ) );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
