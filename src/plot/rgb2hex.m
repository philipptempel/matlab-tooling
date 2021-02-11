function h = rgb2hex(r)
%% RGB2HEX 
%
%   Inputs:
%
%   R                   Nx3 array of RGB values.
%
%   Outputs:
%
%   H                   Nx1 array of corresponding HEX values.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2020-06-23
% Changelog:
%   2020-06-23
%       * Initial release



%% Validate arguments

% RGB2HEX(R)
narginchk(1, 1);

% RGB2HEX(R)
% H = RGB2HEX(R);
nargoutchk(0, 1);

% Validate
validateattributes(r, {'numeric'}, {'nonempty', 'ncols', 3, 'finite', 'nonnegative', '<=', 255}, mfilename, 'r');



%% Conversion

% Check if input was uint8
lonorm = any(r > 1);

% Normalize RGB to [0, 255]
if ~ lonorm
   r = r .* 255;
end

% Convert to doubles
r = uint8(r);

% Each row to hex format
h = transpose(arrayfun(@(ir) sprintf('%02X', r(ir, :)), 1:size(r, 1), 'UniformOutput', false));

% Append pound sign to each row
h = cellfun(@(r) sprintf('#%s', r), h, 'UniformOutput', false);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
