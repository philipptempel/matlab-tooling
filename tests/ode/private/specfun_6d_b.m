function b = specfun_6d_b(t)
%% SPECFUN_6D_B



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-23
% Changelog:
%   2022-02-23
%       * Initial release



%% Parse arguments

% SPECFUN_6D_B(T)
narginchk(1, 1);
% SPECFUN_6D_B(___)
% B = SPECFUN_6D_B(___)
nargoutchk(0, 1);



%% Algorithm

c = linspace(-3, -1.1, 6);
b = permute(reshape(exp(c .* t(:)), [], 6), [2, 1]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
