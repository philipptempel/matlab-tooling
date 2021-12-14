function w = f2w(f)%#codegen
%% F2W turns ordinary frequency into angular frequency
%
% W = F2W(F) turns ordinary frequency F in hertz into angular frequency W in
% rad/s.
%
% Inputs
%
%   F                   Ordinary frequency measured in hertz.
%
% Outputs
%
%   W                   Angular frequency measured in radians per second.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%   2016-06-27
%       * Initial release



%% Magic

w = 2 * pi .* f;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
