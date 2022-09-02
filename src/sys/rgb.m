function mrgb = rgb(r, g, b)%#codegen
%% RGB converts a conventional RGB representation into MATLAB RGB format
%
% LRGB = RGB(R, G, B) converts RGB values in range of [0, 255] to values between
% 0 and 1.
%
% Inputs:
%
%   R                   Nx1 matrix of Red values from 0...255.
%
%   G                   Nx1 matrix of Green values from 0...255.
%
%   B                   Nx1 matrix of Blue values form 0...255.
%
% Outputs:
%
%   MRGB                Nx3 matrix of RGB values scaled between 0...1.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-09-02
% Changelog:
%   2022-09-02
%       * Fix H1 documentation
%       * Ensure that R, G, and B are all column vectors
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2018-09-12
%       * Initial release



%% Do your code magic here

% Simple, but efficient
mrgb = [ r(:) , g(:) , b(:) ] ./ 255;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
