function content = pbpaste()
%% PBPASTE A unix-command like wrapper around CLIPBOARD
%
% CONTENT = PBPASTE() pastes whatever is in the 
%
% Outputs:
%
%   CONTENT                 Description of argument CONTENT



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-25
% Changelog:
%   2022-02-25
%       * Initial release



%% Parse arguments

% PBPASTE()
narginchk(0, 0);

% PBPASTE(___)
% CONTENT = PBPASTE(___)
nargoutchk(0, 1);



%% Algorithm

content = clipboard('paste');


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
