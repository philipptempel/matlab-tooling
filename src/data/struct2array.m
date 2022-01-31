function a = struct2array(s)%#codegen
%% STRUCT2ARRAY Convert a structure to an array i.e., get all values from structure
%
% A = STRUCT2ARRAY(S) converts structure S to an array A.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-12-03
% Changelog:
%   2021-12-03
%       * Initial release



%% Parse arguments

% A = STRUCT2ARRAY(S)
narginchk(1, 1);

% STRUCT2ARRAY(___)
% A = STRUCT2ARRAY(___)
nargoutchk(0, 1);



%% Algorithm

% Convert struture to a cell array, then each field in the structure to an array
c = cellfun(@(v) v(:), struct2cell(s), 'UniformOutput', false);
% And concat the cell array into a numeric array
a = [c{:}];


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
