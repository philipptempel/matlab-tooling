function c = struct2varargin(s)%#codegen
%% STRUCT2VARARGIN Turn a structure into a VARARGIN-like cell
%
% C = STRUCT2VARARGIN(S) converts structure S to cell array C like MATLAB's
% built-in STRUCT2CELL, but it retains the fieldnames of S.
%
% Inputs:
%
%   S                       Structure to convert.
%
% Outputs:
%
%   C                       1x2N cell array.
%
% See also:
%   FIELDNAMES ONOFFSTATE



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-04
% Changelog:
%   2022-03-04
%       * Initial release



%% Parse arguments

% STRUCT2VARARGIN(S)
narginchk(1, 1);

% C = STRUCT2VARARGIN(___)
nargoutchk(0, 1);



%% Algorithm

% Simple one-liner
c = reshape([ fieldnames(s).' ; struct2cell(s).' ], 1, []);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
