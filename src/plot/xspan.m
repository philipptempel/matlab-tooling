function varargout = xspan(varargin)
%% XSPAN Return the current axes data span over the X-Axis
%
% Inputs:
%
%   HAX                 Description of argument HAX
%
% Outputs:
%
%   XS                  Description of argument XS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-04
% Changelog:
%   2021-11-04
%       * Initial release



%% Process

[varargout{1:nargout}] = spans('x', varargin{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
