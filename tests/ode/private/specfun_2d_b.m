function b = specfun_2d_b(t)
%% SPECFUN_2D_B



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-23
% Changelog:
%   2022-02-23
%       * Initial release



%% Parse arguments

% SPECFUN_2D_B(T)
narginchk(1, 1);
% SPECFUN_2D_B(___)
% B = SPECFUN_2D_B(___)
nargoutchk(0, 1);



%% Algorithm

b = permute(reshape(exp([-3 , -2.5] .* t(:)), [], 2), [2, 1]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
