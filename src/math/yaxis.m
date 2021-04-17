function y = yaxis()%#codegen
%% YAXIS Return a 3D Y-axis vector
%
% Outputs:
%
%   Y                   3x1 vector for 3D y-axis



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-13
% Changelog:
%   2020-11-13
%       * Update to use `evecn`
%   2020-11-12
%       * Initial release



%% Do your code magic here

y = evecn(3, 2);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
