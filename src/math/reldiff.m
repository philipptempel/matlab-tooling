function r = reldiff(x, y)%#codegen
%% RELDIFF Calculate relative difference of X and Y
%
% R = RELDIFF(X, Y) calulcates the relative difference of X and Y based on
% R = |X - Y| / (0.5 * ( |X| + |Y| ) );
%
% Inputs:
%
%   X                   1xN vector of values.
%
%   Y                   1xK vector values.
%
% Outputs:
%
%   RD                  NxK matrix of relative differences of all values.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%   2019-01-04
%       * Initial release



%% Validate arguments

validateattributes(x, {'numeric'}, {'matrix', 'nonempty', 'finite'}, mfilename, 'x');

validateattributes(y, {'numeric'}, {'matrix', 'nonempty', 'finite'}, mfilename, 'y');



%% Calculate

% R = |X - Y| / (0.5 * ( |X| + |Y| ) );
r = abs(x - y) ./ ( 0.5 .* ( abs(x) + abs(y) ) );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
