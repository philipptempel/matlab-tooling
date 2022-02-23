function [A, b] = specfun_1d(t)
%% SPECFUN_1D



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-23
% Changelog:
%   2022-02-23
%       * Initial release



%% Parse arguments

% SPECFUN_1D(T)
narginchk(1, 1);
% [A, B] = SPECFUN_1D(___)
nargoutchk(2, 2);



%% Algorithm

A = specfun_1d_A(t);
b = specfun_1d_b(t);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
