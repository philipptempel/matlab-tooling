function dydt = odefun_1d(t, y)
%% ODEFUN_1D



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-23
% Changelog:
%   2022-02-23
%       * Initial release



%% Parse arguments

% ODEFUN_1D(T, Y)
narginchk(2, 2);
% ODEFUN_1D(___)
% DYDT = ODEFUN_1D(___)
nargoutchk(0, 1);



%% Algorithm

% dydt = -y + exp(-3 .* t);
[A, b] = specfun_1d(t);
dydt = A * y + b;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
