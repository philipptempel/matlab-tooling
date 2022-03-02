function s = bool2str(b)%#codegen
%% BOOL2STR Turn a boolean value into its string form
%
% S = BOOL2STR(B) turns boolean value(s) B into strings.
%
% Inputs:
%
%   B                       NxM array of boolean values.
%
% Outputs:
%
%   S                       Cell array of strings.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-02
% Changelog:
%   2022-03-02
%       * Initial release



%% Parse arguments

% S = BOOL2STR(B)
narginchk(1, 1);

% BOOL2STR(B)
nargoutchk(0, 1);



%% Algorithm

% Ensure everything is boolean
b = logical(b);

% Supported string values for false and true, respectively
sv = {'false', 'true'};

% And convert
s = sv(1 + b);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
