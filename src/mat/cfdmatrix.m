function s = cfdmatrix(d, a, m, n)%#codegen
%% CFDMATRIX 
%
% S = CFDMATRIX(D, A)
%
% S = CFDMATRIX(D, A, M)
%
% S = CFDMATRIX(D, A, M, N)
%
% Inputs:
%
%   D                   Description of argument D
%
%   A                   Description of argument A
%
%   M                   Description of argument M
%
%   N                   Description of argument N
%
% Outputs:
%
%   S                   Description of argument S
%
% See also:
%   CFDCOEFFS SPDIAGS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-06-01
% Changelog:
%   2021-06-01
%       * Initial release



%% Parse arguments

% CFDMATRIX(D, A)
% CFDMATRIX(___, M)
% CFDMATRIX(___, M, N)
narginchk(2, 4);
% CFDMATRIX(___)
% S = CFDMATRIX(___)
nargoutchk(0, 1);

% Default number of variables M
if nargin < 3 || isempty(m)
  m = d + a - 1;
end

% Default number of variables N
if nargin < 4 || isempty(n)
  n = m;
end



%% Calculation

e = ones(m, 1);

[C, idx] = cfdcoeffs(d, a);

s = spdiags(e .* C, idx, m, n);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
