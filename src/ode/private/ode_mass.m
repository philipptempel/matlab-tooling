function massfcn = ode_mass(options, neq, extras)
%% ODE_MASS creates the mass matrix callback for the solvers BDF and LEAPFROG
%
% MASSFCN = ODE_MASS(OPTIONS, NEQ, EXTRAS) returns a function handle
% MASSFCN(T, Y) that returns the mass matrix at time T and state Y, according to
% the options 'Mass' and 'MStateDependence' in OPTIONS (see ODESET). All mass
% matrix types are wrapped to the same two-argument call signature.
%
% Inputs:
%
%   OPTIONS             Structure as created by ODESET.
%
%   NEQ                 Number of equations. This is the size of the identity
%                       matrix returned if OPTIONS does not define a mass matrix.
%
%   EXTRAS              Cell array of additional parameters that are appended to
%                       calls of a mass matrix function.
%
% Outputs:
%
%   MASSFCN             Function handle MASSFCN(T, Y). It returns
%                       * speye(NEQ), if no mass matrix is defined,
%                       * the matrix M, if 'Mass' is a numeric matrix,
%                       * M(T, EXTRAS{:}), if 'Mass' is a function handle and
%                         'MStateDependence' is 'none',
%                       * M(T, Y, EXTRAS{:}), if 'Mass' is a function handle and
%                         'MStateDependence' is 'weak' (default) or 'strong'.
%
% The 'MvPattern' option for 'strong' state dependence is not used because the
% solvers do not compute Jacobians of the mass matrix.



%% File information
% Date: 2026-10-05
% Changelog:
%   2026-10-05
%       * Initial release as replacement for a copy of MATLAB's ODEMASS



%% Algorithm

mass = odeget(options, 'Mass', []);

if isempty(mass)
  massfcn = @(~, ~) speye(neq);
  
elseif isnumeric(mass)
  massfcn = @(~, ~) mass;
  
elseif isa(mass, 'function_handle')
  dependence = validatestring(odeget(options, 'MStateDependence', 'weak'), {'none', 'weak', 'strong'});
  if strcmp(dependence, 'none')
    massfcn = @(t, ~) mass(t, extras{:});
  else
    massfcn = @(t, y) mass(t, y, extras{:});
  end
  
else
  error('PHILIPPTEMPEL:MATLAB_TOOLING:ODE_MASS:InvalidMass', ...
    'Option ''Mass'' must be empty, a numeric matrix, or a function handle.');
  
end


end
