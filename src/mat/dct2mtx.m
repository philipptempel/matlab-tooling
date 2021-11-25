function D = dct2mtx(N)%#codegen
%% DCT2MTX Calculate the matrix of the Discrete Cosine Transform Type 2
%
% Inputs:
%
%   N                   Number of real numbers that DCT-II will be applied onto.
%
% Outputs:
%
%   D                   NxN DCT-II matrix.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-18
% Changelog:
%   2021-11-18
%       * Initial release



%% Parse arguments

% DCT2MTX(N)
narginchk(1, 1);

% DCT2MTX(___)
% D = DCT2MTX(___)
nargoutchk(0, 1);



%% Algorithm

% Row index
k = transpose(1:N);

% Column index
n = 1:N;

% Factors of all entries
xf = cos( pi / N .* ((n - 1) + 1 / 2) .* ( k - 1 ) );

% Scaling factor of all values
s      = repmat(sqrt(2 / N), N, N);
% Scaling factor of Y1
s(1,:) = s(1,:) .* repmat(1 / sqrt(2), 1, N);

% Build total DCT-II matrix
D = s .* xf;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
