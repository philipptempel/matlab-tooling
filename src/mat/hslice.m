function b = hslice(A, dim, ind)%#codegen
%% HSLICE Hyperslice an array of unknown dimensions
%
% B = HSLICE(A, DIM, IND) extracts inddices IND from array A along the DIM-th
% dimension.
%
% Inputs:
%
%   A                       Arbitrarily sized arrray.
%
%   DIM                     Scalar dimension index from which to slecet indices
%                           IND.
%
%   IND                     1xN array of indices to extract from A-th DIM
%                           dimension.
%
% Outputs:
%
%   B                       A(:,:,:,IND,:,:,:) where IND is located at dimension
%                           DIM.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-08
% Changelog:
%   2022-09-08
%       * Update implementation to be codegen compatible
%   2022-08-05
%       * Initial release



%% Parse arguments

% HSLICE(A, DIM, IND)
narginchk(3, 3);

% HSLICE(___)
% B = HSLICE(___)
nargoutchk(0, 1);

% HSLICE(A, DIM, IND)
if ~iscell(ind)
  ind = { ind };
end



%% Algorithm

% Get maximum of number of dimensions and the requested dimension index
ndim = max(ndims(A), max(dim));

% Create cell array of subscript indices
subes = cell(1, ndim);

% Mark all dimensions we don't extract with ':' (colon)
[subes{all((1:ndim) ~= dim(:), 1)}] = deal(':');

% Mark dimension to extract
subes(dim) = ind;

% Extract data
b = A(subes{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
