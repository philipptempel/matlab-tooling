function [c, ia, ib] = setdiff(a, b, varargin)%#codegen
%% SETDIFF Set difference of two structures
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
% 
%   IA                      Description of argument IA
% 
%   IB                      Description of argument IB



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-09
% Changelog:
%   2022-09-09
%       * Initial release



%% Parse arguments

% SETDIFF(A, B)
% SETDIFF(A, B, ___)
narginchk(2, Inf);

% SETDIFF(___)
% C = SETDIFF(___)
% [C, IA, IB] = SETDIFF(___)
nargoutchk(0, 3);



%% Algorithm

% Get field names of A and B
fna = fieldnames(a);
fnb = fieldnames(b);

% Get calues of A and B
va = struct2cell(a);
vb = struct2cell(b);

% Intersect the field names
[~, ia] = setdiff(fna, fnb, varargin{:});

% Count matching fields
nia = numel(ia);

% Create a new sturcture with the 
sargs = cell(2, nia);
if nia > 0
  % Populate fields
  sargs(1,:) = fna(ia);
  sargs(2,:) = va(ia);
  sargs(2,:) = vb(ib);
end

% And create a new matching structure
c = struct(sargs{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
