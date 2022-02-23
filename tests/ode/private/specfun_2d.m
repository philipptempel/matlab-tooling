function [A, b] = specfun_2d(t)
%% SPECFUN_2D



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-23
% Changelog:
%   2022-02-23
%       * Initial release



%% Parse arguments

% SPECFUN_2D(T)
narginchk(1, 1);
% [A, B] = SPECFUN_2D(___)
nargoutchk(2, 2);



%% Algorithm

% dy(1)dt = -1 * y(1) + exp(  -3 .* t);
% dy(2)dt = -3 * y(2) + exp(-0.2 .* t);
A = specfun_2d_A(t);
b = specfun_2d_b(t);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
