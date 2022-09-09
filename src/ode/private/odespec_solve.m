function [tout, yout] = odespec_solve(A, b, tspan, y0, options)%#codegen
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
%   2022-09-09
%       * Initial release



%% Parse arguments

% ODESPEC_SOLVE(A, B, TSPAN, Y0)
% ODESPEC_SOLVE(A, B, TSPAN, Y0, OPTIONS)
narginchk(4, 5);

% [T, Y] = ODESPEC_SOLVE(___)
nargoutchk(2, 2);

% ODESPEC_SOLVE(A, B, TSPAN, Y0)
if nargin < 5 || isempty(options)
  options = struct();
end



%% Algorithm

% Count functions and variables
[nf, nv] = size(y0);
ny = numel(y0);

% Eye-matrix of state system
nfEye = speye(nf, nf);

% Number of nodes
nout = options.Nodes;

% Span vector of spectral nodes, must be flipped along the columns as the
% Chebyshev-Lobatto points are on the interval [+1, -1] for an interval. Thus,
% without flip, for an increasing interval [a,b] with a < b, tout would be on
% [b, a] thus decreasing
tout = flip(chebpts2(nout - 1, tspan), 2);

% Dimension of extended system
ns = nf * nout;

% Chebyshev differentation matrix on TSPAN's interval
Dn = chebdiffmtx(nout - 1, tspan);

% Build differentiation matrix D for all of the ODE's degrees of freedom
D = kron( ...
    nfEye ...
  , Dn ...
);

% Index of initial state in global state vector
idxY = 1:nf;
idxX0 = idxY * nout;

% Build global A matrix which is composed of node-wise entries of the ODE
% system's Ai matrices
Aspec = zeros(ns, ns);
bspec = zeros(ns, nv);
idxYN = (idxY - 1) * nout;

% Ensure b is of size YxYxN as well if it isn't already
if size(b, 2) == 1
  b = repmat(b, 1, nv, 1);
end

% Looping over every node
for in = 1:nout
  % Push the i-th node's constant A matrix values in
  Aspec(in + idxYN,in + idxYN) = A(:,:,in);
  
  % Push the i-th node's constant b vector values in
  bspec(in + idxYN,:) = b(:,:,in);
  
end
Aspec = sparse(Aspec);
bspec = sparse(bspec);

% Matrix to map each state into the right block-segment of its differential part
P = speye(ns, ns);
P(idxY,idxY) = 0;
P(idxX0,idxX0) = 0;
P(idxY,idxX0) = nfEye;
P(idxX0,idxY) = nfEye;
Pt = transpose(P);

% Apply transformation of initial condition onto ODE's matrices
Aspec = Pt * Aspec * P;
bspec = Pt * bspec;
D = Pt * D * P;

% New indices for quicker array indexing
idxX0 = 1:nf;
idxY = (nf + 1):ns;

% Calculation of B0
b0 = ( D(:,idxX0) - Aspec(:,idxX0) ) * y0;

% Calculation of solution
yn = ( D(idxY,idxY) - Aspec(idxY,idxY) ) \ ( bspec(idxY,:) - b0(idxY,:) );

% Reshape solution of ODE to be TxY
yout = reshape(P * [ y0 ; yn ], nout, ny);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
