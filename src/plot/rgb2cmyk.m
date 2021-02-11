function c = rgb2cmyk(r)
%% RGB2CMYK convert RGB colors to CMYK colors
%
%   Inputs:
%
%   R                   Nx3 array of RGB values.
%
%   Outputs:
%
%   C                   Nx4 array of corresponding CMYK values



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% See: http://mooring.ucsd.edu/software/matlab/doc/toolbox/graphics/color/rgb2cmyk.html
% Date: 2020-06-23
% Changelog:
%   2020-06-23
%       * Rename argument RGB to R to not collide with method `rgb`
%   2018-11-23
%       * Initial release



%% Validate arguments

% RGB2CMYK(R)
narginchk(1, 1);

% RGB2CMYK(R)
% C = RGB2CMYK(R);
nargoutchk(0, 1);

% Validate
validateattributes(r, {'numeric'}, {'nonempty', 'ncols', 3, 'finite', 'nonnegative', '<=', 255}, mfilename, 'r');



%% Conversion

% Check if input was uint8
lonorm = any(r > 1);

% Get class of original input data
cr = class(r);

% Convert to doubles
r = double(r);

% Normalize RGB to [0, 1]
if lonorm
   r = r ./ 255;
end

% Init CMYK array
c = zeros(size(r, 1), 4);

% Get kern/black color
c(:,4) = min(1 - r, [], 2);

% Get cyan, magneta, and yellow
c(:,1:3) = (1 - r - c(:,4)) ./ ( 1 - c(:,4) );

% Typecast back into the original data type
c = cast(round(c*100), cr);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
