function A = specfun_2d_A(t)
%% SPECFUN_2D_A



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-23
% Changelog:
%   2022-02-23
%       * Initial release



%% Parse arguments

% SPECFUN_2D_A(T)
narginchk(1, 1);
% SPECFUN_2D_A(___)
% A = SPECFUN_2D_A(___)
nargoutchk(0, 1);



%% Algorithm

A = repmat(diag([-1, -3]), 1, 1, numel(t));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
