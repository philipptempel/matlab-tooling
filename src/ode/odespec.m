function [t, y] = odespec(ode, tspan, y0, options, varargin)%#codegen
%% ODESPEC Spectral integration of first-order linear ODEs
%
% ODESPEC solves first-order linear ordinary differential equations using
% spectral integration with Chebyshev differentation matrix and
% Chebyshev-Lobatto points. A first-order linear ODE is given by the equation
% $\dot{y}(t) = A(t) y(t) + b(t)$ over interval $t = [ t_{a} , t_{b} ]$ with
% initial condition $y(t_{a}) = y_{a}$.
%
% ODESPEC also supports solving matrix ODEs i.e., where Y is a matrix of size
% NYxNV. Simply provide Y0 of the right dimensions (and of course A and B for
% this to work.
%
% [T, Y] = ODESPEC(ODEFUN, TSPAN, Y0) calculates the solution Y(T) for the
% linear ODE defined in ODEFUN over integration interval TSPAN with initial
% condition Y0.
%
% [T, Y] = ODESPEC(ODEFUN, TSPAN, Y0, OPTIONS) allows passing additional options
% as structure array to the spectral integration algorithm.
%
% Inputs:
%
%   ODE                 Function handle to the ODE's linear right-hand side.
%                       `ODE` must take one argument, independent variable `T`,
%                       and return two arguments, matrix `A` and vector `B`.
%                       `ODE` can be written in vectorized form, then A must be
%                       an NxNxK array and B must be a NxK vector where K is the
%                       number of knots and N the number of states of the ODE.
%
%   TSPAN               2-element vector defining the interval of spectral
%                       integration. Can be either increasing (forward
%                       integration) or decreasing (backward increasing).
%
%   Y0                  NYxNV vector defining the initial state
%
%   OPTIONS             Structure of options to use for spectral integration.
%                       See below for available options.
%
% Options:
%
%   Nodes               Number of integration nodes to use.
%                       Default: 29.
%
% Outputs:
%
%   T                   NTx1 vector of Chebyshev-Lobatto points used as node
%                       points in spectral integration. This vector is always in
%                       increasing order.
%
%   Y                   NTxNY vector of solutions of Y at node points. The
%                       values in the i-th row Y(i,:) are the values at the i-th
%                       node T(i).



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-08-01
% Changelog:
%   2022-08-01
%       * Add support to skip checking the function handle passed `ODE` in order
%       to speed up spectral integration
%   2022-05-01
%       * Add support for solving matrix-ODEs where the B vector now can also be
%       a matrix
%   2022-02-24
%       * Fix implementation of solving matrix ODEs as this was buggy in some
%       cases and created a system with too many DOF. The new implementation
%       solves the linear equation Y = (D-A) \ B where Y is a matrix directly
%   2022-02-23
%       * Add support for parallel calculation of A and B matrices in case
%       callback is not vectorized
%       * Add support for handling matrix ODEs i.e., where Y, respectively Y',
%       are matrices of size NYxNV
%   2022-02-02
%       * Fix major error in how output node points are calculated and how the
%       spectral integration is performed. This reduces the number of flips and
%       transposes respectively puts them in a more central place
%   2022-01-18
%       * Add support for returning a `DEVAL`-compatible result structure from
%       `ODESPEC`
%       * Require function `ODE` to only take one argument, independent variable
%       `T`, rather than two arguments. This renders `ODESPEC` to only be
%       suitable for the case of linear, time-(in)variant ODEs
%   2021-12-13
%       * Fix H1 documentation
%       * Change default node count to 29 (the next prime number after 25)
%   2021-11-23
%       * Initial release



%% Parse arguments

% ODESPEC(ODE, TSPAN, Y0)
% ODESPEC(ODE, TSPAN, Y0, OPTIONS)
narginchk(3, 4);
% ODESPEC(___)
% SOL = ODESPEC(___)
% [T, Y] = ODESPEC(___)
nargoutchk(0, 2);

% SOL = ODESPEC(___)
output_sol = nargout == 1;

% ODESPEC(ODE, TSPAN, Y0)
if nargin < 4 || isempty(options)
  options = struct();
end

% Parse user-defined options
options = parse_options(options);



%% Algorithm

% Number of nodes
nout = options.Nodes;

% Span vector of spectral nodes, must be flipped along the columns as the
% Chebyshev-Lobatto points are on the interval [+1, -1] for an interval. Thus,
% without flip, for an increasing interval [a,b] with a < b, tout would be on
% [b, a] thus decreasing
tout = flip(chebpts2(nout - 1, tspan), 2);

% ODESPEC(@(t) fun, ___)
if ~iscell(ode)
  % Check ODE arguments and get the ODE function in a common format
  f = parse_ode(ode, tout, y0, options);

  % Evaluate ODE at all nodes
  % A_ = YxYxN
  % B_ = YxN
  [A_, b_] = feval(f, tout);

end

% If B is YxN, turn it into Yx1xN
if size(b_, 2) == size(A_, 3)
  b_ = permute(b_, [1, 3, 2]);
end

% Solve ODE function
% Since spectral integration always works on the reverse abscissae of
% integration, we need to also flip the values as their are assumed to be
% provided on the forward abscissae
yout = odespec_solve(flip(A_, 3), flip(b_, 3), tout, y0, options);

% Create solution structure
sol = [];
if output_sol
  sol = struct();
  sol.solver = 'odespec';
  sol.extdata.odefun   = ode;
  sol.extdata.options  = options;
  sol.extdata.varargin = varargin;

end

% Flip direction of state vector as it is always calculated on the interval [b,
% a] rather than [a, b]
yout = flip(yout, 1);

% SOL = ODESPEC(...)
if output_sol
  sol.x = tout;
  sol.y = transpose(yout);
  
  t = { sol };

% [T, Y] = ODESPEC(...)
else
  % Turn data into column-major
  tout = transpose(tout);
  
  t = tout;
  y = yout;
  
end


end


function f = parse_ode(ode, tout, y0, options)
%% PARSE_ODE Parse ODE function and return it in a unified form
%
% PARSE_ODE(ODE, TOUT, Y0)



% Check if user asked to not perform any tests, then we will skip out here
if onoffstate(optsget(options, 'SkipChecks', false, 'fast')) == matlab.lang.OnOffSwitchState.on
  % Just use the given function as the ODE function
  f = ode;
  
% Perform full suite of tests
else
  
  % Check type of ODE: Allowed types are function handles of (t, y) or strings to
  % function names
  fhUsed = isa(ode, 'function_handle');

  % In case of string arguments, check the function exists (either as M-file (==2)
  % or as MEX file (==3)).
  if ~fhUsed && any(exist(ode, 'file') == [2, 3])
    throwAsCaller(MException('COSSEROOTS:ODESPEC:ODENotFound', 'ODE function with name %s not found.', funcstring(ode)));
  end

  % Values to test-evaluate function at
  t = tout(1);
  nt = numel(tout);
  [nf, nv] = size(y0, [1, 2]);

  nIn  = nargin(ode);
  nOut = nargout(ode);

  % Check number of input arguments is 1: `ODE(T)`
  if nIn ~= 1
    throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidNArgin', 'Invalid number of input arguments to ODE function. Must take 1 (t), but takes %d.', nargin(ode)));
  end

  % Check number of output arguments is 2: `[A, B] = ODE(T)`
  if nOut ~= 2 && nOut ~= -1
    throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidNArgout', 'Invalid number of output arguments to ODE function. Must return 2 (A, B), but returns %d.', nargout(ode)));
  end

  % Evaluate function
  [A, b] = feval(ode, t);

  % % Evaluate function
  % try
  %   [A, b] = feval(ode, t);
  % catch me
  %   % Wrong number of input arguments
  %   if strcmp(me.identifier, 'MATLAB:TooManyInputs')
  % 
  %     
  %   % Wrong number of output arguments
  %   elseif strcmp(me.identifier, 'MATLAB:TooManyOutputs')
  %     
  %     
  %   end
  %   
  %   % Any other case
  %   throwAsCaller(addCause(MException('COSSEROOTS:ODESPEC:ErrorEvaluatingODE', 'Error evaluating ODE function at initial step.'), me));
  %   
  % end

  % Check size of matrix A is correct
  if size(A, 1) ~= size(A, 2) && size(A, 1) ~= nf
    throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidSizeA', 'Invalid shape of matrix A. Expected (%d %d) but got (%s).', nf, nf, num2str(size(A))));
  end

  % Check size of matrix A is correct
  if size(b, 1) ~= nf && size(b, 2) ~= 1
    throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidSizeB', 'Invalid shape of vector B. Expected (%d %d) but got (%s).', nf, 1, num2str(size(b))));
  end

  % Lastly, check if function allows for vectorized input
  f = ode;
  try
    [~, ~] = feval(ode, [t, t]);

  catch me
    f = @(t) ode_vectorized(ode, nf, nt, t, options.UseParallel);

  end
  
end

% % Lastly, for reasons of usability, the flip-wrapper must always be added
% f = @(t) flip_wrapper(f, t);


end


function [A, b] = flip_wrapper(f, t)
%% FLIP_WRAPPER
%
% [A, B] = FLIP_WRAPPER(FUN, T) wraps function FUN such that its returned
% arguments A and B are correctly flipped along their last dimension
%
% Inputs:
%
%   FUN                 ODE function callback
%
%   T                   1xN array of node point(s)
%
% Outputs:
%
%   A                   YxYxN array of constant terms at each node T.
%
%   B                   YxN array of of constant terms at each node T.



% Evaluate ODE function
[A, b] = feval(f, t);
% Ensure B is YxN, if not, transpose it
if size(b, 2) == size(A, 3)
  b = permute(b, [1, 3, 2]);
end
% if size(b, 1) == size(A, 3) && size(b, 2) == size(A, 1)
%   b = permute(b, [2, 1]);
% end
% Flip columns i.e., node points
A = flip(A, 3);
b = flip(b, 3);


end


function [A, b] = ode_vectorized(ode, nf, nt, t, useprlll)
%% ODE_VECTORIZED creates a vectorized version of the ODE function
%
% [A, B] = ODE_VECTORIZED(ODEF, NF, NT, T) vectorizes ODE function ODEF to allow
% T and Y to be XxN vectors and return A and B of appropriate size.
%
% Inputs:
%
%   ODEF                ODE function callback that takes one argument (T) and
%                       returns matrix A and vector B at a given spectral node
%                       T.
%
%   NF                  Number of functions of the ODE system i.e., number of
%                       rows. Value only needed for quickly allocating A and B
%                       of right size.
%
%   NT                  Number of spectral time nodes at which spectral
%                       integration is being performed. Value only needed for
%                       quickly allocating A and B of right size.
% 
%   T                   1xN vector of node values.
%
%   USEPRLLL            True/false flag wheter to use a parallel for loop or not
%                       when calculating A and B matrices.
%
% Outputs:
%
%   A                   NFxNFxN array of constant state terms at each node T.
%
%   B                   NFxN array of of constant terms at each node T.



% Init outputs
A = zeros(nf, nf, nt);
b = zeros(nf, nt);

% Parallel branch
if useprlll
  % Loop over each time step and evaluate ODE
  parfor it = 1:nt
    [ A(:,:,it) , b(:,it) ] = feval(ode, t(it));
  end
  
% Non-parallel branch
else
  % Loop over each time step and evaluate ODE
  for it = 1:nt
    [ A(:,:,it) , b(:,it) ] = feval(ode, t(it));
  end
  
end


end


function oopts = parse_options(iopts)
%% PARSE_OPTIONS Parse user-defined options with defaults
%
% O = PARSE_OPTIONS(I) merges user-defined options structure I with defaults and
% returns options structure O
%
% Inputs:
%
%   I                   Structure with user-defined options
%
% Outputs:
% 
%   O                   Structure with default options merged with user-defined
%                       options.
%
% See also:
%   MERGESTRUCTS



persistent defaults

% Default defaults
if isempty(defaults)
  defaults = struct( ...
      'Nodes'      , 25 ...
    , 'UseParallel', false ...
    , 'SkipChecks' , false ...
  );
  
end

% Merge defaults structure with options given
oopts = defaults * iopts;



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
