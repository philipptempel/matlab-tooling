function s = ffdmatrix(d, a, m, n)%#codegen
%% FFDMATRIX 
%
% S = FFDMATRIX(D, A)
%
% S = FFDMATRIX(D, A, M)
%
% S = FFDMATRIX(D, A, M, N)
%
% Inputs:
%
%   D                   Description of argument D
%
%   A                   Description of argument A
%
%   N                   Description of argument M
%
%   N                   Description of argument N
%
% Outputs:
%
%   S                   Description of argument S
%
% See also:
%   FFDCOEFFS SPDIAGS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-06-01
% Changelog:
%   2021-06-01
%       * Initial release



%% Parse arguments

% FFDMATRIX(D, A)
% FFDMATRIX(___, M)
% FFDMATRIX(___, M, N)
narginchk(2, 4);
% FFDMATRIX(___)
% S = FFDMATRIX(___)
nargoutchk(0, 1);

% Default number of variables M
if nargin < 3 || isempty(m)
  m = d + a;
end

if nargin < 4 || isempty(n)
  n = m;
end



%% Calculation

e = ones(m, 1);

[C, idx] = ffdcoeffs(d, a);

s = spdiags(e .* C, idx, m, n);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
