function [c, idx] = cfdcoeffs(d, a)
%% CFDCOEFFS Calculate the Central Finite-Differences Coefficients
%
% C = CFDCOEFFS(D, A) calculates the coefficients of the central
% finite-difference matrix for a given derivative degree D and accuracy A.
%
% [C, IDX] = CFDCOEFFS(D, A) also returns the indices for creating the
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
%   C                   1xK array of central finite-differences coefficients.
%
%   IDX                 1x(A + D - 1) array of off-diagonal indices to create
%                       the finite-differences matrix.
%
% See also:
%   SPDIAGS BFDCOEFFS FFDCOEFS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-05-31
% Changelog:
%   2021-05-31
%       * Initial release



%% Parse arguments

% CFDCOEFFS(D, A)
narginchk(2, 2);
% CFDCOEFFS(___);
% C = CFDCOEFFS(___)
% [C, IDX] = CFDCOEFFS(___)
nargoutchk(0, 2);

% Ensure a is multiple of 2 starting at 2
a = max(floor(a / 2), 1);

n = a + floor((d - 1) / 2);

c = fdcoeffs(d, -n:n, 0);

if nargout > 1
  idx = -n:n;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
