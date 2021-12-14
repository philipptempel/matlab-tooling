function r = cmyk2rgb(c)
%% CMYK2RGB convert CMYK colors to RGB colors
%
%   Inputs:
%
%   C                   Nx4 array of corresponding CMYK values
%
%   Outputs:
%
%   R                   Nx3 array of RGB values.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% See: http://mooring.ucsd.edu/software/matlab/doc/toolbox/graphics/color/CMYK2RGB.html
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2020-06-23
%       * Rename argument RGB to R to not collide with method `rgb`
%   2018-11-23
%       * Initial release



%% Validate arguments

% CMYK2RGB(C)
narginchk(1, 1);

% CMYK2RGB(C)
% R = CMYK2RGB(C);
nargoutchk(0, 1);

% Validate
validateattributes(c, {'numeric'}, {'nonempty', 'ncols', 4, 'finite', 'nonnegative', '<=', 100}, mfilename, 'c');



%% Conversion

% Check if input was uint8
lonorm = any(c > 1);

% Get class of original input data
cc = class(c);

% Convert to doubles
c = double(c);

% Normalize CMYK to [0, 1]
if lonorm
   c = c/100;
end

% Conversion
r = ( 1 - c(:,[1,2,3]) ) .* ( 1 - c(:,4) );

% Typecast back into the original data type
r = cast(r, cc);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
