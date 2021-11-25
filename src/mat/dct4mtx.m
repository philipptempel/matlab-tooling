function D = dct4mtx(N)%#codegen
%% DCT4MTX Calculate the matrix of the Discrete Cosine Transform Type 4
%
% Inputs:
%
%   N                   Number of real numbers that DCT-IV will be applied onto.
%
% Outputs:
%
%   D                   NxN DCT-IV matrix.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-18
% Changelog:
%   2021-11-18
%       * Initial release



%% Parse arguments

% DCT4MTX(N)
narginchk(1, 1);

% DCT4MTX(___)
% D = DCT4MTX(___)
nargoutchk(0, 1);



%% Algorithm

% Row index
k = transpose(1:N);

% Column index
n = 1:N;

% Factor of all entries
xf = cos( pi / N .* ( (n - 1) + 1 / 2 ) .* ( (k - 1) + 1 / 2 ) );

% Overall scaling factor
s = repmat(sqrt(2 / N), N, N);

% Build total DCT-I matrix
D = s .* xf;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
