function [t, y] = odespec(ode, tspan, y0, options)
%% ODESPEC Spectral integration of first-order linear ODEs
%
% ODESPEC solves first-order linear ordinary differential equations using
% spectral integration with Chebyshev differentation matrix and
% Chebyshev-Lobatto points. A first-order linear ODE is given by the equation
% $\dot{y} = A y + b$ over interval $t = [ t_{0} , t_{f} ]$ with initial
% condition $y(t_{0}) = y_{0}$.
%
% [T, Y] = ODESPEC(ODE, TSPAN, Y0)
%
% [T, Y] = ODESPEC(ODE, TSPAN, Y0, OPTIONS)
%
% Inputs:
%
%   ODE                 Function handle to the ODE's linear right-hand side.
%                       `ODE` must return two arguments, matrix A and vector B.
%                       `ODE` can be written in vectorized form, then A must be
%                       an NxNxK array and B must be a NxK vector where K is the
%                       number of knots and N the number of states of the ODE.
%
%   TSPAN               2-element vector defining the interval of spectral
%                       integration. Can be either increasing (forward
%                       integration) or decreasing (backward increasing).
%
%   Y0                  NYx1 vector defining the initial state
%
%   OPTIONS             Structure of options to use for spectral integration.
%
% Options:
%
%   NNodes              Number of integration nodes to use.
%                       Default: 25.
%
% Outputs:
%
%   T                   NTx1 vector of Chebyshev-Lobatto points used as node
%                       points in spectral integration.
%
%   Y                   NTxNY vector of solutions of Y at node points.



%% File information
% * Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% * Date: 2021-11-23
% Changelog:
%   2021-11-23
%       * Initial release



%% Parse arguments

% ODESPEC(ODE, TSPAN, Y0)
% ODESPEC(ODE, TSPAN, Y0, OPTIONS)
narginchk(3, 4);
% ODESPEC(___)
% [T, Y] = ODESPEC(___)
nargoutchk(2, 2);

% ODESPEC(ODE, TSPAN, Y0)
if nargin < 4 || isempty(options)
  options = struct();
end

% Parse user-defined options
options = parse_options(options);

% Turn Y0 into a column vector
y0 = y0(:);
ny = numel(y0);



%% Algorithm

% Eye-matrix of state system
nyEye = eye(ny, ny);

% Number of nodes
nn = options.Nodes;

% Get interval of integration
ab = tspan;
% Direction of integration
tdir = sign(tspan(2) - tspan(1));
% Span vector of spectral nodes
tspan = chebpts2(nn - 1, ab);

% Dimension of extended system
ns = ny * nn;

% Chebyshev differentation matrix on TSPAN's interval
Dn = chebdiffmtx(nn - 1, ab);

% Check ODE arguments and get the ODE function in a common format
f = parse_ode(ode, tspan, y0);

% Build differentiation matrix D for all of the ODE's degrees of freedom
D = kron( ...
    nyEye ...
  , Dn ...
);

% Evaluate ODE at all nodes
[A_, b_] = feval(f, tspan, y0);

% Index of initial state in global state vector
idxY = 1:ny;
%{
I THINK THIS IS THE DEAL:

If we integrate on [a, b] with y(a) given, then the initial condition is
reflected in the last entries of D because D is D([b,a]).

Thus, if tdir > 0 must be idxY * nn and tdir < 0 must be (idxY-1) * nn + 1

%}
% if tdir > 0
%   idxX0 = (idxY - 1) * nn + 1;
% else
  idxX0 = idxY * nn;
% end

% Build global A matrix which which is composed of node-wise entries of the ODE
% system's Ai matrices
A = zeros(ns, ns);
b = zeros(ns, 1);
idxOff = (idxY - 1) * nn;
% Looping over every node
for it = 1:nn
  % Push the i-th node's constant A matrix values in
  A(it + idxOff,it + idxOff) = A_(:,:,it);
  
  % Push the i-th node's constant b vector values in
  b(it + idxOff) = b_(1:ny,it);
  
end

% Matrix to map intial values onto solution
P = eye(ns, ns);
P(idxY,idxY) = 0;
P(idxX0,idxX0) = 0;
P(idxY,idxX0) = nyEye;
P(idxX0,idxY) = nyEye;
Pt = transpose(P);

% Apply transformation of initial condition onto ODE's matrices
A = Pt * A * P;
D = Pt * D * P;
b = Pt * b;

% New indices for quicker array indexing
idxX0 = 1:ny;
idxY = (ny + 1):ns;

% Calculation of B0
b0 = ( D(:,idxX0) - A(:,idxX0) ) * y0;

% Calculation of solution
yn = ( D(idxY,idxY) - A(idxY,idxY) ) \ ( b(idxY) - b0(idxY) );

% assignin('base', 'a', A);
% assignin('base', 'b', b);
% assignin('base', 'd', D);
% assignin('base', 'p', P);
% assignin('base', 'cl', b0);
% assignin('base', 'res', yn);

% Reshape solution of ODE to be TxY
y = reshape(P * [ y0 ; yn ], nn, ny);

% Turn node points into a column vector
t = tspan(:);

% If the interval ab was increasing i.e., a < b, then the nodes and values at
% the nodes are in decreasing order since the Chebyshev-nodes are in decreasing
% order. Thus, we need to sort T and Y in reverse row order; in other words
% flip row 1 and N, row 2 and N-1, etc.
if tdir > 0
  t = flip(t, 1);
  y = flip(y, 1);
end


end


function f = parse_ode(ode, tspan, y0)
%% PARSE_ODE Parse ODE function and return it in a unified form
%
% PARSE_ODE(ODE, TSPAN, Y0)



% Check type of ODE: Allowed types are function handles of (t, y) or strings to
% function names
fhUsed = isa(ode, 'function_handle');

% In case of string arguments, check the function exists (either as M-file (==2)
% or as MEX file (==3)).
if ~fhUsed && any(exist(ode, 'file') == [2, 3])
  throwAsCaller(MException('COSSEROOTS:ODESPEC:ODENotFound', 'ODE function with name %s not found.', funcstring(ode)));
end

% First, check if ODE takes two arguments (t, y)
if nargin(ode) ~= 2
  throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidNArgin', 'Invalid number of input arguments to ODE function. Must take 2 (t, y), but takes %d.', nargin(ode)));
end
% Next, check if ODE returns two arguments (A, b)
if nargout(ode) ~= 2
  throwAsCaller(MException('COSSEROOTS:ODESPEC:InvalidNArgout', 'Invalid number of output arguments to ODE function. Must return 2 (A, B), but takes %d.', nargout(ode)));
end

% Values to test function
t = tspan(1);
nt = numel(tspan);
y = y0;
ny = numel(y);

% Evaluate function
try
  [A, b] = feval(ode, t, y);
catch me
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
  [~, ~] = feval(ode, [t, t], [y, y]);
  
catch
  f = @(t, y) ode_vectorized(ode, ny, nt, t, y);
  
end


end


function [A, b] = ode_vectorized(ode, ny, nt, t, y)
%% ODE_VECTORIZED creates a vectorized version of the ODE function
%
% [A, B] = ODE_VECTORIZED(ODEF, NY, NT, T, Y) vectorizes ODE function ODEF to
% allow T and Y to be XxN vectors and return A and B of appropriate size.
%
% Inputs:
%
%   ODEF                ODE function callback that takes two arguments (T, Y)
%                       and returns matrix A and vector B at a given spectral
%                       node T.
%
%   NY                  Number of states of the ODE system. Value only needed
%                       for quickly allocating A and B of right size.
%
%   NT                  Number of time nodes at which spectral integration is
%                       being performed. Value only needed for quickly
%                       allocating A and B of right size.
% 
%   T                   1xNT vector of node values.
%
%   Y                   NYxNT array of states at each node.
%
% Outputs:
%
%   A                   NYxNYxNT array of constant terms at each node NT.
%
%   B                   NYxNT array of of constant terms at each node NT.



% Init outputs
A = zeros(ny, ny, nt);
b = zeros(ny, nt);

% Loop over each time step and evaluate ODE
for it = 1:nt
  [ A(:,:,it) , b(:,it) ] = feval(ode, t(it), y(:,it));
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
  defaults = struct('Nodes', 25);
end

% Merge defaults structure with options given
oopts = mergestruct(defaults, iopts);


end


%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
