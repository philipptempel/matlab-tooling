function ts = timspace(t0, tf, h)%#codegen
% TIMSPACE creates a properly and evenly spaced vector
%
%   TS = TIMSPACE(T0, TF) creates a properly and evenly spaced vector between T0
%   and TF using a step size of 1e-2.
%
%   TS = TIMSPACE(T0, TF, H) uses step size H to span the range from T0 to TF.
%
%   Inputs:
%
%   T0                  Scalar value as the start of the time vector.
%
%   TF                  Scalar value as the end of the time vector.
%
%   H                   Step size. Defaults to 1e-2.
%
%   Outputs:
%
%   TS                  Nx1 vector of evenly spaced time values.
%
%   See also:
%   LINSPACE COLON



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-11-17
% Changelog:
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

if nargin < 3 || isempty(h) || 0 == exist('h', 'var')
  h = 1e-2;
end



%% Perform creation of TS

% Simply pass the properly formatted values to linspace
ts = linspace( ...
    t0 ...
  , tf...
  , round( ( tf - t0 ) / h + 1 ) ...
);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
