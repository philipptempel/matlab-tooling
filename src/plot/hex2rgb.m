function r = hex2rgb(h)
%% HEX2RGB 
%
%   Inputs:
%
%   H                   Nx1 cell array of HEX values
%
%   Outputs:
%
%   R                   Nx3 array of RGB valuse in range of [0, 1]



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2020-06-23
%       * Initial release



%% Validate arguments

% HEX2RGB(H)
narginchk(1, 1);

% HEX2RGB(H)
% R = HEX2RGB(H);
nargoutchk(0, 1);



%% Do your code magic here

% If h is a Nx1 cell array, make it a regular array
if iscell(h)
    h = cell2mat(h);
end

% now we should remove any '#' if there are some
if h(1,1) == '#'
    h(:,1) = [];
end

% And convert it to RGB values in the range of [0, 1]
r = transpose(reshape(sscanf(transpose(h), '%2x'), 3, []) ./ 255);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
