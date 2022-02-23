function varargout = odespec(ode, tspan, y0, options, varargin)
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
% Date: 2022-02-23
% Changelog:
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

% Turn Y0 into a column vector
[nf, nv] = size(y0);
y0 = y0(:);
ny = numel(y0);



%% Algorithm

% Eye-matrix of state system
nyEye = eye(ny, ny);

% Number of nodes
nout = options.Nodes;

% Get interval of integration
ab = tspan;
% Span vector of spectral nodes, must be flipped along the columns as the
% Chebyshev-Lobatto points are on the interval [+1, -1] for an interval. Thus,
% without flip, for an increasing interval [a,b] with a < b, tout would be on
% [b, a] thus decreasing
tout = flip(chebpts2(nout - 1, ab), 2);

% Dimension of extended system
ns = ny * nout;

% Chebyshev differentation matrix on TSPAN's interval
Dn = chebdiffmtx(nout - 1, ab);

% Check ODE arguments and get the ODE function in a common format
f = parse_ode(ode, tout, y0, options);

sol = [];
if output_sol
  sol = struct();
  sol.solver = 'odespec';
  sol.extdata.odefun = ode;
  sol.extdata.options = options;
  sol.extdata.varargin = varargin;

end

% Build differentiation matrix D for all of the ODE's degrees of freedom
D = kron( ...
    nyEye ...
  , Dn ...
);

% Evaluate ODE at all nodes
% A_ = YxYxN
% B_ = YxN
[A_, b_] = feval(f, tout);

% Index of initial state in global state vector
idxY = 1:ny;
idxX0 = idxY * nout;

% Build global A matrix which is composed of node-wise entries of the ODE
% system's Ai matrices
A = zeros(ns, ns);
b = zeros(ns, 1);
idxYN = (idxY - 1) * nout;
nvEye = eye(nv, nv);

% Looping over every node
for in = 1:nout
  % Push the i-th node's constant A matrix values in
  A(in + idxYN,in + idxYN) = kron(nvEye, A_(:,:,in));
  
  % Push the i-th node's constant b vector values in
  b(in + idxYN) = repmat(b_(1:nf,in), nv, 1);
  
end

% Matrix to map each state into the right block-segment of its differential part
P = sparse(eye(ns, ns));
P(idxY,idxY) = 0;
P(idxX0,idxX0) = 0;
P(idxY,idxX0) = nyEye;
P(idxX0,idxY) = nyEye;
Pt = transpose(P);

% Apply transformation of initial condition onto ODE's matrices
A = Pt * A * P;
b = Pt * b;
D = Pt * D * P;

% New indices for quicker array indexing
idxX0 = 1:ny;
idxY = (ny + 1):ns;

% Calculation of B0
b0 = ( D(:,idxX0) - A(:,idxX0) ) * y0;

% Calculation of solution
yn = ( D(idxY,idxY) - A(idxY,idxY) ) \ ( b(idxY) - b0(idxY) );

% Reshape solution of ODE to be TxY
yout = reshape(P * [ y0 ; yn ], nout, ny);

% Finalize result
solver_output = odespec_finalize(tout, yout, sol);

% Assign outputs
if nargout > 0
  varargout = solver_output;
end


end


function f = parse_ode(ode, tout, y0, options)
%% PARSE_ODE Parse ODE function and return it in a unified form
%
% PARSE_ODE(ODE, TOUT, Y0)



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
y = y0;
if isvector(y)
  y = y(:);
end
% Number of states of the system
ny = size(y, 1);

% Evaluate function
try
  [A, b] = feval(ode, t);
catch me
  % Wrong number of input arguments
  if strcmp(me.identifier, 'MATLAB:TooManyInputs')
    throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidNArgin', 'Invalid number of input arguments to ODE function. Must take 1 (t), but takes %d.', nargin(ode)));
    
  % Wrong number of output arguments
  elseif strcmp(me.identifier, 'MATLAB:TooManyOutputs')
    throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidNArgout', 'Invalid number of output arguments to ODE function. Must return 2 (A, B), but returns %d.', nargout(ode)));
    
  end
  
  % Any other case
  throwAsCaller(addCause(MException('COSSEROOTS:ODESPEC:ErrorEvaluatingODE', 'Error evaluating ODE function at initial step.'), me));
  
end

% Check size of matrix A is correct
if size(A, 1) ~= size(A, 2) && size(A, 1) ~= ny
  throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidSizeA', 'Invalid shape of matrix A. Expected (%d %d) but got (%s).', ny, ny, num2str(size(A))));
end

% Check size of matrix A is correct
if size(b, 1) ~= ny && size(b, 2) ~= 1
  throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidSizeB', 'Invalid shape of vector B. Expected (%d %d) but got (%s).', ny, 1, num2str(size(b))));
end

% Lastly, check if function allows for vectorized input
f = ode;
try
  [~, ~] = feval(ode, [t, t]);
  
catch
  f = @(t) ode_vectorized(ode, nf, nt, t, options.UseParallel);
  
end

f = @(t) flip_wrapper(f, t);


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
if size(b, 1) == size(A, 3) && size(b, 2) == size(A, 1)
  b = permute(b, [2, 1]);
end
% Flip columns i.e., node points
A = flip(A, 3);
b = flip(b, 2);


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
      'Nodes', 25 ...
    , 'UseParallel', false ...
  );
end

% Merge defaults structure with options given
oopts = mergestructs(defaults, iopts);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
