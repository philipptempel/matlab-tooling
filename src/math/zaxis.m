function z = zaxis()%#codegen
%% ZAXIS Return a 3D Z-axis vector
%
% Outputs:
%
%   Z                   3x1 vector for 3D z-axis



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2020-11-13
%       * Update to use `evecn`
%   2020-11-12
%       * Initial release



%% Do your code magic here

z = evecn(3, 3);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
