function p = pack(varargin)%#codegen
%% PACK 
%
% Outputs:
%
%   P                   Description of argument P



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-09
% Changelog:
%   2021-11-09
%       * Initial release



%% Parse arguments

% PACK(A1, ...)
narginchk(1, Inf);

% PACK(A1, ...)
% P = PACK(A1, ...)
nargoutchk(0, 1);



%% Pack it

% Copy inputs
p = varargin;

% Loop over all inputs and turn matrices into column vectors
for ip = 1:numel(p)
  p{ip} = p{ip}(:);
end

% Put into column vector
p = vertcat(p{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
