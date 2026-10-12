function [neq, nTime, t0, tfinal, y0, htspan, dataType] = ode_arguments(solver, odefun, tspan, y0)
%% ODE_ARGUMENTS validates the inputs of the fixed-step solvers BDF and LEAPFROG
%
% [NEQ, NTIME, T0, TFINAL, Y0, HTSPAN, DATATYPE] = ODE_ARGUMENTS(SOLVER, ODEFUN,
% TSPAN, Y0) checks the arguments handed to the solver SOLVER and returns the
% quantities derived from them. ODEFUN is evaluated once at (T0, Y0) to check
% the size of its return value.
%
% Inputs:
%
%   SOLVER              Name of the calling solver. If it is 'leapfrog', Y0 is
%                       expected to be the stacked state [x; v] and NEQ is half
%                       its length, otherwise NEQ is the length of Y0.
%
%   ODEFUN              Function handle of the ODE function, called as
%                       ODEFUN(T, Y). It must return a column vector of length
%                       NEQ.
%
%   TSPAN               Vector of at least two strictly monotonic, finite time
%                       values.
%
%   Y0                  Vector of initial states.
%
% Outputs:
%
%   NEQ                 Number of equations.
%
%   NTIME               Number of elements in TSPAN.
%
%   T0                  First time value.
%
%   TFINAL              Last time value.
%
%   Y0                  Initial states as column vector.
%
%   HTSPAN              Absolute distance of the first two time values.
%
%   DATATYPE            Floating point class to use for the solution, i.e., the
%                       superior class of T0, Y0, and ODEFUN(T0, Y0).



%% File information
% Date: 2026-10-05
% Changelog:
%   2026-10-05
%       * Initial release as replacement for a copy of MATLAB's ODEARGUMENTS



%% Validate arguments

if ~isa(odefun, 'function_handle')
  error('PHILIPPTEMPEL:MATLAB_TOOLING:ODE_ARGUMENTS:InvalidOdefun', ...
    '%s: ODEFUN must be a function handle.', solver);
end

if ~isnumeric(tspan) || ~isvector(tspan) || numel(tspan) < 2 || ~isreal(tspan) || ~all(isfinite(tspan))
  error('PHILIPPTEMPEL:MATLAB_TOOLING:ODE_ARGUMENTS:InvalidTspan', ...
    '%s: TSPAN must be a vector of at least two finite, real values.', solver);
end

if isempty(y0) || ~isnumeric(y0)
  error('PHILIPPTEMPEL:MATLAB_TOOLING:ODE_ARGUMENTS:InvalidY0', ...
    '%s: Y0 must be a non-empty numeric vector.', solver);
end

tspan = tspan(:);
y0 = y0(:);

t0 = tspan(1);
tfinal = tspan(end);
nTime = numel(tspan);
htspan = abs(tspan(2) - t0);

tdir = sign(tfinal - t0);
if tdir == 0 || any(tdir*diff(tspan) <= 0)
  error('PHILIPPTEMPEL:MATLAB_TOOLING:ODE_ARGUMENTS:TspanNotMonotonic', ...
    '%s: Entries of TSPAN must be strictly monotonic.', solver);
end

if strcmp(solver, 'leapfrog')
  neq = numel(y0)/2;
  if neq ~= floor(neq)
    error('PHILIPPTEMPEL:MATLAB_TOOLING:ODE_ARGUMENTS:InvalidY0', ...
      '%s: Y0 must contain positions and velocities and thus have an even number of elements.', solver);
  end
else
  neq = numel(y0);
end



%% Check ODEFUN

f0 = odefun(t0, y0);
if ~isequal(size(f0), [neq, 1])
  error('PHILIPPTEMPEL:MATLAB_TOOLING:ODE_ARGUMENTS:InvalidOdefunSize', ...
    '%s: ODEFUN must return a column vector of length %d but returned an array of size %s.', ...
    solver, neq, mat2str(size(f0)));
end

% Superior floating point class of all quantities (single wins over double)
dataType = class(t0 + y0(1) + f0(1));


end
