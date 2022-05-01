function a = struct2array(s)%#codegen
%% STRUCT2ARRAY Convert a structure to an array i.e., get all values from structure
%
% A = STRUCT2ARRAY(S) converts structure S to an array A.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-04-26
% Changelog:
%   2022-04-26
%       * Change algorithm to use `CELL2MAT` and `STRUCT2CELL`
%   2021-12-03
%       * Initial release



%% Parse arguments

% A = STRUCT2ARRAY(S)
narginchk(1, 1);

% STRUCT2ARRAY(___)
% A = STRUCT2ARRAY(___)
nargoutchk(0, 1);



%% Algorithm

% Convert struture to a cell array, then into a matrix
a = cell2mat(struct2cell(s));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
