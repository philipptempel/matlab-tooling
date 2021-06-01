function x = xaxis()%#codegen
%% XAXIS Return a 3D X-axis vector
%
% Outputs:
%
%   X                   3x1 vector for 3D x-axis



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-13
% Changelog:
%   2020-11-13
%       * Update to use `evecn`
%   2020-11-12
%       * Initial release



%% Do your code magic here

x = evecn(3, 1);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
