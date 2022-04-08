function varargout = cmdwinsize()%#codegen
%% CMDWINSIZE Return the current command window size
%
% SZ = CMDWINSIZE() returns command window size SZ.
%
% [W, H] = CMDWINSIZE() returns width W and height H in separate variables.
%
% Outputs:
%
%   SZ                      1x2 vector of command window width X height.
%
%   W                       Scalar command window width.
%
%   H                       Scalar command window height.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-04-08
% Changelog:
%   2022-04-08
%       * Initial release



%% Parse arguments

narginchk(0, 0);

% CMDWINSIZE(___)
% SZ = CMDWINSIZE(___)
% [W, H] = CMDWINSIZE(___)
nargoutchk(0, 2);



%% Algorithm

% Get command window size
sz = matlab.desktop.commandwindow.size();

% [W, H] = CMDWINSIZE(___)
if nargout > 1
  varargout = num2cell(sz);
  
% CMDWINSIZE(___)
% SZ = CMDWINSIZE(___)
else
  varargout = {sz};
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
