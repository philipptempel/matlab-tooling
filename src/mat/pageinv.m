function Y = pageinv(X)%#codegen
%% PAGEINV Page-wise matrix inverse
%
% Y = PAGEINV(X) calculates the inverses Y of each page of N-D array X. This is
% a custom implementation of PAGEINV found in MATLAB R2022a and later.
%
% Inputs:
%
%   X                       NxMxP array.
%
% Outputs:
%
%   Y                       MxNxP array of inverses.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-22
% Changelog:
%   2022-09-22
%       * Initial release



%% Parse arguments

% PAGEINV(X)
narginchk(1, 1);

% Y = PAGEINV(___)
nargoutchk(0, 1);



%% Algorithm

% Count pages
np = size(X, 3);

% Initialize cell array to hold inverses
y = cell(np, 1);

% Loop over each page
for ip = 1:np
  y{ip} = inv(X(:,:,ip));
end

% And concatenate along pages again
Y = cat(3, y{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
