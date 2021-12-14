function h = halfversin(z)%#codegen
%% HALFVERSIN creates the half versine value
%
% HALFVERSIN(Z) calculates the half of the Versine value of Z.
%
% Inputs:
%
%   Z                   NxM matrix of values to calculate the half versine of.
%
% Outputs:
%
%   H                   NxM matrix of halfs of versine values.
%
% See also:
%   VERSIN



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%   2017-10-10
%       * Initial release



%% Validate arguments

narginchk(1, 1);
nargoutchk(0, 1);

validateattributes(z, {'numeric'}, {'nonempty', 'finite', 'nonnan', 'nonsparse'}, mfilename(), 'z');



%% Calculate half versine

h = 1 / 2 .* versin(z);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
