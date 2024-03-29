function res = leapfrog_acceleration(odefun, tn, xn, vn, ane, h, mass, varargin)
% LEAPFROG_ACCELERATION solves the non-linear ODE for the current acceleration
%
%   Inputs:
%
%   ODEFUN              ODE function callback.
%
%   TN                  Current time value.
%
%   XN                  Kx1 vector of the current positions.
%
%   VN                  Kx1 vector of the current velocities.
%
%   ANE                 Kx1 vector of the estimate of the current time step
%                       acceleration.
%
%   MASS                Structure containing information on the mass matrix.
%
%   Outputs:
%
%   RES                 Residual of the estimate for an



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2018-08-29
%       * Initial release



%% Initialize variables


% Calculate residual value
res = mass.Function(tn, [xn; vn])*ane - odefun(tn, [xn; vn]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
