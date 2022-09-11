function c = minus(a, b)%#codegen
%% MINUS Subtract two structures
%
% C = MINUS(A, B) subtracts fields of structure B from fields structure A.
%
% Inputs:
%
%   A                       Description of argument A
% 
%   B                       Description of argument B
%
% Outputs:
%
%   C                       Description of argument C



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-09
% Changelog:
%   2022-09-09
%       * Initial release



%% Parse arguments

% MINUS(A, B)
narginchk(2, 2);

% MINUS(___)
% C = MINUS(___)
nargoutchk(0, 1);



%% Algorithm

% Get field names of all structures
fna = fieldnames(a);
fnb = fieldnames(b);

% Get values of original strucutre
va = struct2cell(a);

% Find out the difference between A's fields and B's fields
[fnc, inda] = setdiff(fna, fnb);

% Build a list of arguments to create a new structure
sargs = cell(2, numel(fnc));
sargs(1,:) = fnc;
sargs(2,:) = va(inda);

% And create a new structure
c = struct(sargs{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
