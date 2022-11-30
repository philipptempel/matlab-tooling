function rgbb = rgbblend(rgb1, rgb2, bf)
%% RGBBLEND Blend two RGB triplets
%
% RGBB = RGBBLEND(RGB1, RGB2, BLENDFACTOR) blends RGB triplets RGB1 and RGB2
% with a blend factor of BLENDFACTOR. If BLENDFACTOR is 0.5, then RGBB is at
% half way between RGB1 and RGB2. The closer BLENDFACTOR is to 0, the closer
% RGBB will be to RGB1, the closer BLENDFACTOR is to 1, the closer RGBB will be
% to RGB2.
%
% Inputs:
%
%   RGB1                    Nx3 array of RGB triplets in range 0...1.
% 
%   RGB2                    Nx3 array of RGB triplets in range 0...1.
% 
%   BLENDFACTOR             Blending factor in the range 0...1.
%
% Outputs:
%
%   RGBB                    Nx3 array of blended RGB triplets in the range of
%                           0...1.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-11-30
% Changelog:
%   2022-11-30
%       * Initial release



%% Parse arguments

% RGBBLEND(RGB1, RGB2, BLENDFACTOR)
narginchk(3, 3);

% RGBBLEND(___)
% RGBB = RGBBLEND(___)
nargoutchk(0, 1);



%% Algorithm

% Blend in RGB's non-linear scale
rgbb = limit(( ( 1 - bf ) * rgb1 .^ 2 + bf * rgb2 .^ 2 ), 0, 1);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
