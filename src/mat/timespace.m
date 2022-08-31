function ts = timespace(t0, tf, h)%#codegen
%% TIMESPACE creates a properly and evenly spaced vector
%
% TS = TIMESPACE(T0, TF) creates a properly and evenly spaced vector between T0
% and TF using a step size of 1e-2.
%
% TS = TIMESPACE(T0, TF, H) uses step size H to span the range from T0 to TF.
%
% Inputs:
%
%   T0                  Scalar value as the start of the time vector.
%
%   TF                  Scalar value as the end of the time vector.
%
%   H                   Step size. Defaults to 1e-2.
%
% Outputs:
%
%   TS                  Nx1 vector of evenly spaced time values.
%
% See also:
%   LINSPACE COLON



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-08-31
% Changelog:
%   2022-08-31
%       * Fix upper bound not being correctly included in created time vector
%   2022-01-27
%       * Fix wrong function name in H1 documentation
%       * Fix H1 documentation layout
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-30
%       * Fix bug that caused this function to not properly set the time
%       stepsize. `TIMESPACE` now uses the colon operator and ensures the final
%       is definitely included by appending it if it's not already included.
%   2021-11-17
%       * Rename to `timespace` to be more verbose in function name
%   2021-10-25
%       * Rename to `timspace` to avoid overloading local variables `tspan` and
%       to make it consistent with `linspace`
%       * Make output vector be same shape as the result of the underlying
%       `linspace` call
%   2019-02-22
%       * Round number of elements passed to `linspace` to be non-rational
%   2018-08-30
%       * Initial release



%% Parse arguments

% TIMESPACE(T0, TF)
% TIMESPACE(T0, TF, H)
narginchk(2, 3);

% TIMESPACE(___)
% T = TIMESPACE(___)
nargoutchk(0, 1);

% TIMESPACE(T0, TF)
if nargin < 3 || isempty(h)
  h = 1e-2;
end



%% Algorithm

% Simply pass the properly formatted values to linspace
ts = unique([t0:h:tf, tf]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
