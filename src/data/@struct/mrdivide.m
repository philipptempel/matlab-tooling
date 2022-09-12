function c = mrdivide(a, b)%#codegen
%% MRDIVIDE Matrix right division of two structures
%
% C = MRDIVIDE(A, B) right divides structure A by structure B leaving distinct
% fields of structures A and B in C with values of B.
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
% Date: 2022-09-12
% Changelog:
%   2022-09-12
%       * Initial release



%% Parse arguments

% MRDIVIDE(A, B)
narginchk(2, 2);

% MRDIVIDE(___)
% C = MRDIVIDE(___)
nargoutchk(0, 1);



%% Algorithm

% Get field names of both structures
fna = fieldnames(a);
fnb = fieldnames(b);

% Get values of data
va = struct2cell(a);
vb = struct2cell(b);

% Find differences in fields
[ca, ia] = setdiff(fna, fnb);
[cb, ib] = setdiff(fnb, fna);

% Constructor arguments of new structure
sargs = [ ca , cb ; va(ia) , vb(ib) ];

% Make new structure
c = struct(sargs{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
