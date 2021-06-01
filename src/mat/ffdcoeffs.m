function [c, idx] = ffdcoeffs(d, a)
%% FFDCOEFFS Calculate the Forward Finite-Differences Coefficients
%
% C = FFDCOEFFS(D, A) calculates the coefficients of the forward
% finite-difference matrix for a given derivative degree D and accuracy A.
%
% [C, IDX] = FFDCOEFFS(D, A) also returns the indices for creating the
% band-diagonal finite difference matrix.
% The finite difference matrix can be calculated using E = ones(N, 1) .* C via
%
%   L = spdiags(E, IDX, N, N);
%
% Inputs:
%
%   D                   Derivative degree to approximate. Must be larger than or
%                       equal to 1.
%
%   A                   Desired accuracy of finite-differences approximation.
%                       Must be larger than or equal to 1.
%
% Outputs:
%
%   C                   1xK array of forward finite-differences coefficients.
%
%   IDX                 1x(A + D - 1) array of off-diagonal indices to create
%                       the finite-differences matrix.
%
% See also:
%   SPDIAGS BFDCOEFFS CFDCOEFFS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-05-31
% Changelog:
%   2021-05-31
%       * Initial release



%% Parse arguments

% FFDCOEFFS(D, A)
narginchk(2, 2);
% FFDCOEFFS(___);
% C = FFDCOEFFS(___)
% [C, IDX] = FFDCOEFFS(___)
nargoutchk(0, 1);

n = a + d - 1;

c = fdcoeffs(d, 0:n, 0);

if nargout > 1
  idx = 0:n;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
