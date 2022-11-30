function rgbd = rgbdarker(rgb, lfactor, asint)
%% RGBDARKER 
%
% RGBDARKER(RGB, FACTOR) turns the RGB-triplet RGB darker by factor FACTOR.
%
% RGBDARKER(RGB, FACTOR, ASINT) allows returning the RGB-triplet as integers in
% the range 0...255
%
% Inputs:
%
%   RGB                     Nx3 array of RGB triplets in the range of 0...1.
%
%   FACTOR                  Factor to darken the RGB triplet to. Must be between
%                           0 and 1. With 1, the triplet will be darkened by
%                           100% (becoming black), with 0, the triplet will not
%                           be darkened at all.
%
%   ASINT                   Flag to indicate whether darker color should be
%                           returned as integer between 0...255.
%
% Outputs:
%
%   DARKER                  Nx3 array of darkened RGB values in the range of
%                           0...1



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-11-30
% Changelog:
%   2022-11-30
%       * Change algorithm to use `RGBBLEND`
%       * Remove Name/Value pair and turn it into a single flag
%   2022-09-29
%       * Fix deprecated call to `PARSESWITCHARG` with `ONOFFSTATE`
%   2021-12-13
%       * Update to new signature of `PARSESWITCHARG`
%   2020-11-16
%       * Copy from my old MATLAB package
%       * Change email domain to `ls2n.fr`
%       * Rename to `rgbdarker`
%   2018-05-14
%       * Remove `fix` to keep original precision
%   2017-08-01
%       * Add option 'AsInteger' to allow returning the darker RGB as integer
%       values
%       * Add help block text
%   2017-02-24
%       * Initial release



%% Parse arguments

% RGBDARKER(RGB, FACTOR)
% RGBDARKER(RGB, FACTOR, ASINT)
narginchk(2, 3);

% RGBDARKER(___)
% RGBL = RGBDARKER(___)
nargoutchk(0, 1);

% RGBDARKER(RGB, FACTOR)
if nargin < 3 || isempty(asint)
  asint = false;
end

% Convert ASINT flag to a proper matlab.lang.OnOffSwitchState object
asint = onoffstate(asint);



%% Algorithm

% Blend color with black to get it darker
rgbd = rgbblend(rgb, [ 0.000 , 0.000 , 0.000 ], lfactor);

% Convert to full integers?
if asint == matlab.lang.OnOffSwitchState.on
  rgbd = round(rgbd .* 255);
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
