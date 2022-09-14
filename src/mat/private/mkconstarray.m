function out = mkconstarray(cls, val, sz)%#codegen
%% MKCONSTARRAY



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-14
% Changelog:
%   2022-09-14
%       * Initial release



%% Parse arguments



%% Algorithm

out = repmat(feval(cls, val), sz);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
