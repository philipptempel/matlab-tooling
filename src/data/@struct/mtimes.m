function c = mtimes(a, b)%#codegen
%% MTIMES Combine two structures by updating the first with values of the second
%
% C = AND(A, B) combines arrays A and B in such ways that only common fields are
% found in C.
%
% Inputs:
%
%   A                       Structure.
% 
%   B                       Structure.
%
% Outputs:
%
%   C                       Structure with fields in both A and B.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-09
% Changelog:
%   2022-09-09
%       * Initial release



%% Parse arguments

% AND(A, B)
narginchk(2, 2);

% AND(___)
% C = AND(___)
nargoutchk(0, 1);



%% Algorithm

% Get field names of A and B
fna = fieldnames(a);
fnb = fieldnames(b);

% Get calues of A and B
va = struct2cell(a);
vb = struct2cell(b);

% Intersect the field names
[~, ia, ib] = intersect(fna, fnb);

% Build arguments for `STRUCT` to create a new merged structure
cfields = fna;
cvalues = va;
cvalues(ia) = vb(ib);

% And create a new matching structure
c = cell2struct(cvalues, cfields, 1);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
