function D = dct3mtx(N)%#codegen
%% DCT3MTX Calculate the matrix of the Discrete Cosine Transform Type 3
%
% Inputs:
%
%   N                   Number of real numbers that DCT-III will be applied onto.
%
% Outputs:
%
%   D                   NxN DCT-I matrix.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-18
% Changelog:
%   2021-11-18
%       * Initial release



%% Parse arguments

% DCT3MTX(N)
narginchk(1, 1);

% DCT3MTX(___)
% D = DCT3MTX(___)
nargoutchk(0, 1);



%% Algorithm

% Row index
k = transpose(1:N);

% Column index
n = 2:N;

% Factor of first entry of x
x0 = zeros(N, N);
x0(:,1) = repmat(1 / 2, N, 1);
% Factors of x(2:end)
xe = zeros(N, N);
xe(:,2:end) = cos( pi / N .* (n - 1) .* ( (k - 1) + 1 / 2) );

% Overall scaling factor
s          = repmat(2 * sqrt(1 / N), N, N);
% Scaling factor of X2...XN
s(:,2:end) = s(:,2:end) .* repmat(1 / sqrt(2), N, N-1);

% Build total DCT-III matrix
D = s .* (x0 + xe);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
