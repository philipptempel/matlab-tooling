function ev = evec2(cord)%#codegen
%% EVEC2 Create a planar unit vector
%
% EVEC2(CORD) creates a planar 2x1 unit vector with its CORD-th coordinate set
% to 1.
%
% Inputs:
%
%   CORD                Coordinate to set to 1.
%
% Outputs:
%
%   EV                  2x1 vector with its CORD-th entry set to 1.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-13
% Changelog:
%   2020-11-13
%       * Initial release



%% Do your code magic here

ev = evecn(2, cord);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
