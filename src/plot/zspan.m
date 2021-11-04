function varargout = zspan(varargin)
%% ZSPAN Return the current axes data span over the Z-Axis
%
% Inputs:
%
%   HAX                 Description of argument HAX
%
% Outputs:
%
%   ZS                  Description of argument ZS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-04
% Changelog:
%   2021-11-04
%       * Initial release



%% Process

[varargout{1:nargout}] = spans('z', varargin{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
