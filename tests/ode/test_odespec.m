function test_odespec()
%% TEST_ODESPEC
%
% Compare integration of a simple ODE using ODE45 with the results obtained from
% ODESPEC.
%
% See also:
%   ODE45 ODESPEC COMPARE_ODESPEC COMPARE_ODE_RESULTS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-12-13
% Changelog:
%   2021-12-13
%       * Split code into two functions `VERIFY_ODESPEC` and `COMPARE_ODESPEC`
%       * Refactor and outsource functions to share with `COMPARE_ODESPEC`
%   2021-11-26
%       * Initial release



%% Set-up

% Number of spectral integration nodes
N = 79;



%% Integration of a 1D system

% Number of states
ny = 1;

% Forward integration
ab = [ 0 , 5 ];
[ode, spec] = ode45_and_odespec(ny, ab, N);
compare_ode_results( ...
    ab ...
  , ode ...
  , spec ...
);

% Backward integration
ya = permute(ode(end,2:end), [2, 1]);
ab = [ 5 , 0 ];
[ode, spec] = ode45_and_odespec(ny, ab, N, ya);
compare_ode_results( ...
    ab ...
  , ode ...
  , spec ...
);



%% Integration of a 2D system

% Number of states
ny = 2;

% Forward integration
ab = [ 0 , 5 ];
[ode, spec] = ode45_and_odespec(ny, ab, N);
compare_ode_results( ...
    ab ...
  , ode ...
  , spec ...
);

% Backward integration
ya = permute(ode(end,2:end), [2, 1]);
ab = [ 5 , 0 ];
[ode, spec] = ode45_and_odespec(ny, ab, N, ya);
compare_ode_results( ...
    ab ...
  , ode ...
  , spec ...
);



%% Integration of a 2D matrix system

% Number of states
ny = [2, 4];

% Forward integration
ab = [ 0 , 5 ];
[ode, spec] = ode45_and_odespec(ny, ab, N);
compare_ode_results( ...
    ab ...
  , ode ...
  , spec ...
);

% Backward integration
ya = reshape(ode(end,2:end), ny);
ab = [ 5 , 0 ];
[ode, spec] = ode45_and_odespec(ny, ab, N, ya);
compare_ode_results( ...
    ab ...
  , ode ...
  , spec ...
);



%% Integration of a 2D matrix system

% Number of states
ny = [6, 13];

% Forward integration
ab = [ 0 , 5 ];
[ode, spec] = ode45_and_odespec(ny, ab, N);
compare_ode_results( ...
    ab ...
  , ode ...
  , spec ...
);

% Backward integration
ya = reshape(ode(end,2:end), ny);
ab = [ 5 , 0 ];
[ode, spec] = ode45_and_odespec(ny, ab, N, ya);
compare_ode_results( ...
    ab ...
  , ode ...
  , spec ...
);


end



function [ode, spec] = ode45_and_odespec(ny, ab, nn, ya)
%% ODE45_AND_ODESPEC
%
% ODE45_AND_ODESPEC(NY, AB, NN)
%
% ODE45_AND_ODESPEC(NY, AB, NN, YA)



if isscalar(ny)
  ny = [ny, 1];
end

% Initial state
if nargin < 4 || isempty(ya)
  ya = rand(ny) - 0.5;
end

nf = ny(1);

% Convert state count into function handles
odefun  = str2func(sprintf('odefun_%dd', nf));
specfun = str2func(sprintf('specfun_%dd', nf));

% Obtain solution using MATLAB's numerical integrators
solode = ode45(odefun, ab, ya, odeset('AbsTol', 1e-6, 'RelTol', 1e-9, 'MaxStep', 1e-3));
% [xode, yode] = ode45(odefun, ab, ya, odeset('AbsTol', 1e-6, 'RelTol', 1e-6, 'MaxStep', 1e-3));

% Obtain solution using my implementation of spectral integration
% solspec = odespec(specfun, ab, ya, struct('Nodes', nn));
[xspec, yspec] = odespec(specfun, ab, ya, struct('Nodes', nn));

% Abscissae and data for DEVAL of Newton integration result
xode = xspec;
yode = permute(deval(solode, xode), [2, 1]);

% Abscissae and data for DEVAL of spectral integration result
% xspec = xspec;
% yspec = permute(deval(solspec, xspec), [2, 1]);

% Evaluate ODE solution at nodes and stack in columns
ode  = [ xode  , yode  ];
% Also stack ODESPEC solution in columns
spec = [ xspec , yspec ];


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
