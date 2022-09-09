function c = plus(a, b)%#codegen
%% PLUS Add two structures
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

% PLUS(A, B)
narginchk(2, 2);

% PLUS(___)
% C = PLUS(___)
nargoutchk(0, 1);



%% Algorithm

% Get field names of all structures
fna = fieldnames(a);
fnb = fieldnames(b);

% Get values of both structures
va = struct2cell(a);
vb = struct2cell(b);

% Get unique field names
fn = unique([ fna ; fnb ]);

% Find indices of the new fields in the fold field
[~, indAS, indAV] = intersect(fn, fna);
[~, indBS, indBV] = intersect(fn, fnb);

% % Create arguments to create a new structure with combined data
sargs = cell(2,numel(fn));
sargs(1,:) = fn;
sargs(2,indAS) = va(indAV);
sargs(2,indBS) = vb(indBV);

% And create new structure
c = struct(sargs{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
