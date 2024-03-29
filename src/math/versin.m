function v = versin(th)%#codegen
%% VERSIN calculates the versine of the argument
%
% VERSIN(TH) calculates versine of value TH.
%
% Inputs:
%
%   TH                  NxM array of values to calculate versine of.
%
% Outputs:
%
%   V                   NxM array of versines of Z.



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

try
    validateattributes(th, {'numeric'}, {'nonempty', 'finite', 'nonnan', 'nonsparse'}, mfilename, 'th');
catch me
    throwAsCaller(me);
end



%% Calculate versine

v = 1 - cos(th);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
