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
% Date: 2022-08-05
% Changelog:
%   2022-08-05
%       * Initial release



%% Parse arguments

% HSLICE(A, DIM, IND)
narginchk(3, 3);

% HSLICE(___)
% B = HSLICE(___)
nargoutchk(0, 1);



%% Algorithm

% Build cell array of ':' selectors the same size as A
subses = repmat({ ':' }, [ 1 , ndims(A) ]);

% Place the requested indices at the DIM-th entry
% subses(dim) = mat2cell(ind, 1);
subses(dim) = {ind};

% Extract
b = A(subses{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
