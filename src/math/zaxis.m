function z = zaxis()%#codegen
%% YAXIS Return a 3D Z-axis vector
%
% Outputs:
%
%   Z                   3x1 vector for 3D z-axis



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-13
% Changelog:
%   2020-11-13
%       * Update to use `evecn`
%   2020-11-12
%       * Initial release



%% Do your code magic here

z = evecn(3, 3);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
