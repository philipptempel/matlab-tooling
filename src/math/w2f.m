function f = w2f(w)
%% W2F turns angular frequency into ordinary frequency
%
% F = W2F(W) turns angular frequency W in rad/s into ordinary frequency F in
% hertz.
%
% Inputs
%
%   W                   Angular frequency measured in radians per second.
%
% Outputs
%
%   F                   Ordinary frequency measured in hertz.



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

f = w ./ (2 * pi);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
