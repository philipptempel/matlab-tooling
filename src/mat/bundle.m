function b = bundle(varargin)%#codegen
%% BUNDLE Bundle variable arguments together
%
% B = BUNDLE(A, B, ...) bundles variables A, B, etc. together into one column
% vector.
%
% Outputs:
%
%   B                   Nx1 vector of bundle variables where N is the product of
%                       all dimensions of the arguments.
%
% See also:
%   UNBUNDLE



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-18
% Changelog:
%   2021-11-18
%       * Rename from `PACK` to `BUNDLE`
%   2021-11-09
%       * Initial release



%% Parse arguments

% BUNDLE(A1, ...)
narginchk(1, Inf);

% BUNDLE(A1, ...)
% B = BUNDLE(A1, ...)
nargoutchk(0, 1);



%% Pack it

% Copy inputs
b = varargin;

% Loop over all inputs and turn matrices into column vectors
for ip = 1:nargin
  b{ip} = reshape(b{ip}, [], 1);
end

% Put into column vector
b = vertcat(b{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
