function D = dct1mtx(N)%#codegen
%% DCT1MTX Calculate the matrix of the Discrete Cosine Transform Type 1
%
% Inputs:
%
%   N                   Number of real numbers that DCT-I will be applied onto.
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

% DCT1MTX(N)
narginchk(1, 1);

% DCT1MTX(___)
% D = DCT1MTX(___)
nargoutchk(0, 1);



%% Algorithm

% Row index
k = transpose(1:N);

% Column index
n = 2:(N - 1);

% Factor of first entry of x
x0 = zeros(N, N);
x0(:,1) = ones(1, N);
% Factor of last entry of x
xn = zeros(N, N);
xn(:,end) = repmat(-1, N, 1) .^ (k - 1);
% Factors of x(2:end-1)
xm = zeros(N, N);
xm(:,2:end-1) = cos( pi / ( N - 1 ) .* (n - 1) .* (k - 1) );
% Overall scaling factor
s            = ones(N, N);
% Scaling of Y1
s(1,:)       = repmat(sqrt(1 / (N - 1)), 1, N);
% Scaling of YN
s(end,:)     = repmat(sqrt(1 / (N - 1)), 1, N);
% Scaling of Y2...YN-1
s(2:end-1,:) = repmat(sqrt(2 / (N - 1)), N - 2, N);

% Build total DCT-I matrix
D = s .* ( repmat(1 / sqrt(2), N, N) .* (x0 + xn) + xm );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
