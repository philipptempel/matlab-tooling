function dydt = odefun_2d(t, y)
%% ODEFUN_2D



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-23
% Changelog:
%   2022-02-23
%       * Initial release



%% Parse arguments

% ODEFUN_2D(T, Y)
narginchk(2, 2);
% ODEFUN_2D(___)
% DYDT = ODEFUN_2D(___)
nargoutchk(0, 1);



%% Algorithm

y = reshape(y, 2, []);

[A, b] = specfun_2d(t);
% dy(1)dt = -1 * y(1) + exp( -3 .* t);
% dy(2)dt = -3 * y(2) + exp(-10 .* t);
dydt = A * y + b;

dydt = reshape(dydt, [], 1);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
