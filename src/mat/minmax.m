function mm = minmax(a, dim, varargin)%#codegen
%% MINMAX Get Minimum and Maximum of an arra
%
% MM = MINMAX(A) returns the minimum and maximum value of array A.
%
% Inputs:
%
%   A                       Description of argument A
%
% Outputs:
%
%   MM                      Description of argument MM



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-09
% Changelog:
%   2022-09-09
%       * Initial release



%% Parse arguments

% MINMAX(A)
% MINMAX(A, 'all')
narginchk(1, Inf);

% MINMAX(___)
% MM = MINMAX(___)
nargoutchk(0, 1);

% MINMAX(A)
% MINMAX(A, [])
if nargin < 2 || isempty(dim)
  dim = find(size(a, 1:ndims(a)) > 1, 1, 'first');
end



%% Algorithm

% Concatenate along the dimension that was used to search
mm = cat( ...
    dim ...
  , min(a, [], dim, varargin{:}) ...
  , max(a, [], dim, varargin{:}) ...
);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
