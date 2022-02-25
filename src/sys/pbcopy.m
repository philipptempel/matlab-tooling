function pbcopy(data)
%% PBCOPY A unix-command like wrapper around CLIPBOARD
%
% PBCOPY(DATA) copies the value of DATA into the user's clipboard.
%
% PBCOPY DATA copies the 
%
% Inputs:
%
%   VARARGIN                Description of argument VARARGIN



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-25
% Changelog:
%   2022-02-25
%       * Initial release



%% Parse arguments

% PBCOPY(DATA)
narginchk(1, 1);

% PBCOPY
nargoutchk(0, 0);


%% Algorithm

try
  data = evalin('caller', data);
  
catch me
end

clipboard('copy', data);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
