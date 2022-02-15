function jac = jacobest(fun, x, options)%#codegen
%% JACOBEST Estimate Jacobian of a vector-valued function
%
% JAC = JACOBEST(FUN, X) estimates the Jacobian of function FUN at/around X.
%
% JACOBEST(FUN, X, OPTIONS) allows passing additional options to the algorithm
% for further adjustment of parameters.
%
% Inputs:
%
%   FUN                     Function handle for f(x) returning an Nx1 vector.
% 
%   X                       Mx1 value at/around which to calculate the Jacobian
% 
%   OPTIONS                 Structure of additional options.
%
% Options:
%
%   FiniteDifferenceStepSize  Step size to be used in finite differences
%                             approximation.
%                             Defaults: eps ^ (1/3)
%
%   FiniteDifferenceType      Type of finite differences. Can be either
%                             `forward` or `central`.
%                             Defaults: 'forward'
%
%   SingularityTolerance      Tolerance value after which values are assumed
%                             zero. This check is performed before returning the
%                             Jacobian.
%                             Default: 1e-3 * eps ^ (1/3)
%   UseParallel               Whether to calculate the Jacobian in parallel or
%                             not.
%                             Default: false
%
% Outputs:
%
%   JAC                     NxM array of Jacobian df(x)/dx



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-15
% Changelog:
%   2022-02-15
%       * Initial release



%% Parse arguments

% JACOBEST(FUN, X)
% JACOBEST(FUN, X, OPTIONS)
narginchk(2, 3);

% JACOBEST(___)
% JAC = JACOBEST(___)
nargoutchk(0, 1);

% JACOBEST(FUN, X)
if nargin < 3 || isempty(options)
  options = struct();
end



%% Algorithm

% Default options
defaultopt = struct( ...
    'FiniteDifferenceStepSize', eps() ^ ( 1 / 3 ) ....
  , 'FiniteDifferenceType', 'forward' ...
  , 'SingularityTolerance', 1e-3 * eps() ^ ( 1 / 3 ) ...
  , 'UseParallel', false ...
);

% Get user-defined options
options = mergestructs(defaultopt, options);

% Get some option values
h = options.FiniteDifferenceStepSize;
fjac = str2func(sprintf('finite_difference_%s', lower(options.FiniteDifferenceType)));
stol = options.SingularityTolerance;

% Evaluate at base point
f0 = feval(fun, x);

% Count variables
nf = numel(f0);
nx = numel(x);

% Initialize output
jac = zeros(nf, nx);

% Different handling if parallel execution or not
if options.UseParallel
  % Loop in parallel over component of X
  parfor ix = 1:nx
    jac(:,ix) = feval(fjac, fun, f0, x, h, ix);
    
  end

% No parallel execution
else
  % Loop over each component of X
  for ix = 1:nx
    jac(:,ix) = fjac(fun, f0, x, h, ix);
    
  end
  
end

% Remove singular values
jac(issingular(jac, stol)) = 0;


end


function jac = finite_difference_forward(fun, f0, x, h, idx)
%% FINITE_DIFFERENCE_FORWARD



x(idx) = x(idx) + h;

jac = ( feval(fun, x) - f0 ) / h;


end


function jac = finite_difference_central(fun, ~, x, h, idx)
%% FINITE_DIFFERENCE_CENTRAL



xf = x;
xf(idx) = xf(idx) + h;
xb = x;
xb(idx) = xb(idx) - h;

jac = ( feval(fun, xf) - feval(fun, xb) ) / 2 / h;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
