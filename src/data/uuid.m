function c = uuid()%#codegen
%% UUID Create a UUID
%
% C = UUID() creates a semi-random UUID. It does not check for duplicates
% though.
%
% Outputs:
%
%   C                       35 char long UUID.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-06
% Changelog:
%   2022-10-06
%       * Initial release



%% Parse arguments

% UUID()
narginchk(0, 0);

% UUID(___)
% C = UUID(___)
nargoutchk(0, 1);



%% Algorithm

c = char(matlab.lang.internal.uuid());


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
