function d = pages2blkdiag(a)%#codegen
%% PAGES2BLKDIAG Turn pages of matrix into block-diagonal blocks.
%
% D = PAGES2BLKDIAG(A) turns pages of matrix A into blocks of block-diagonal
% matrix D.
%
% This function is an implementation of the MATLAB Answers post by Andrei Bobrov
% @see
% https://nl.mathworks.com/matlabcentral/answers/481632-how-to-create-a-block-diagonal-matrix-without-using-cell-array#answer_393043
%
% Inputs:
%
%   A                   NxMxK matrix of which pages should become blocks of
%                       block-diagonal matrix.
%
% Outputs:
%
%   D                   (N*K)x(M*K) block-diagonal matrix where the B-th block
%                       is the B-th page of A.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Author: Andrei Bobrov <https://nl.mathworks.com/matlabcentral/profile/authors/2823630>
% URL: https://nl.mathworks.com/matlabcentral/answers/481632-how-to-create-a-block-diagonal-matrix-without-using-cell-array#answer_393043
% Date: 2021-11-23
% Changelog:
%   2021-11-23
%       * Initial release



%% Parse arguments

% PAGES2BLKDIAG(A)
narginchk(1, 1);

% PAGES2BLKDIAG(___)
% D = PAGES2BLKDIAG(___)
nargoutchk(0, 1);



%% Algorithm

% Count dimensions of A
[m, n, k] = size(a, [1, 2, 3]);

% Kronecker delta for quicker outer-matrix product
d = kron(eye(k), ones(m, n));

% And parsing
d(d > 0) = a;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
