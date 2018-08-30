function varargout = leapfrog(odefun, tsp, x0, v0, options, varargin)%#codegen
% LEAPFROG implements Leapfrog integration of ODEs
%
%   SOL = LEAPFROG(ODEFUN, TSPAN, X0, V0) performs Leapfrog integration of the
%   ODE given in ODEFUN over the time span given in TSPAN with initial position
%   states X0 and initial velocity states V0.
%
%   [T, XV] = LEAPFROG(...) returns the Kx1 time vector, the Kx2N position
%   and velocity vector.
%
%   [T, X, V] = LEAPFROG(...) returns the Kx1 time vector, the KxN position
%   vector, and the KxN velocity vector.
%
%   Inputs:
%
%   ODEFUN              Function handle to the ODE's right-hand side.
%
%   TSPAN               2x1 vector of [t_start, t_end] or Kx1 vector of time
%                       values at which to integrate the ODE for.
%
%   X0                  Nx1 vector of initial position states for t == t_start.
%
%   V0                  Nx1 vector of initial velocity states for t == t_n-1/2
%
%   OPTIONS             Structure array of options to be passed to the ODE
%                       integrator obtained from ODESET.
%
%   Outputs:
%
%   T                   Kx1 vector of time stamps at which the ODE was
%                       evaluated.
%
%   X                   KxN vector of the solution position states.
%
%   V                   KxN vector of the solution velocity states.
%
%   XV                  Kx2N vector of the solution position and velocity
%                       states.
%
%   See also
%
%   ODESET



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2018-08-30
% Changelog:
%   2018-08-30
%       * Code cleanup
%       * Fix step size calculation such that final value of T matches the given
%       final time value
%       * Also fix missing the last time step value in the integration process
%   2018-08-23
%       * Initial release



%% No validation of arguments to support %#codegen
% If only three arguments are given, or OPTIONS is empty or OPTIONS does not
% exist as variable, create a default value for it
if nargin < 5 || isempty(options) || exist('options', 'var') == 0
  options = [];
end



%% Parse arguments
% Default ODE options
stDefaultOptions = odeset({});

% Make sure we have all default ODE options
stOptions = odeset(stDefaultOptions, options);

% Set solver name
chSolverName = 'leapfrog';

% Check if ODEFUN is a function handle or points to a file
loFHUsed = isa(odefun, 'function_handle');

% Number of function evaluations
nFuncEval = 0;

% Parse the ODE arguments using MATLAB's built-in ODEARGUMENTS function
[nEquations, vTspan, nTime, next, dTime_0, dTime_T, dTime_Dirn, y0, f0, odeArgs, odefun, ...
 stOptions, threshold, rtol, normcontrol, normy, hmax, htry, htspan, dataType] = ...
    odearguments(loFHUsed, chSolverName, odefun, tsp, x0, stOptions, {v0});

% ODE function was once evaluated inside ODEARGUMENTS
nFuncEval = nFuncEval + 1;

% Get step size from options
dStepsize = odeget(stOptions, 'MaxStep', -1, 'fast');

% No step size given in options, so infer it from vTspan
if dStepsize == -1
  % Get the default step size from the call to `ODEARGUMENTS`
  dStepsize = htspan;
end
% Pre-calculate half of the step size
dStepsizeHalf = 1/2*dStepsize;
% Pre-calculate double of the step size
dStepsizeDouble = 2*dStepsize;

% Handle mass matrix
% nMass_Type == 0: no mass matrix
% nMass_Type == 1: M
% nMass_Type == 2: M(t)
% nMass_Type == 3: M(t, y)
[nMass_Type, aMass_0, fhMass, ceMass_arg, stMass_Options] = odemass(loFHUsed, odefun, dTime_0, x0, stOptions, {v0});
% Stucture containing information on the mass matrix
stMass = struct( ...
    'Type', nMass_Type ...
  , 'Value', aMass_0 ...
  , 'Function', fhMass ...
  , 'Arguments', {{}} ...
  , 'Options', [] ...
);
if ~isempty(ceMass_arg)
  stMass.Arguments = ceMass_arg;
end
if isa(stMass_Options, 'struct')
  stMass.Options = stMass_Options;
end

% Determine value of mass matrix
switch stMass.Type
  case 0 % []
    stMass.Function = @(t, x, v) 1;
  case 1 % M
    stMass.Function = @(t, x, v) stMass.Value;
  case 2 % M(t)
    stMass.Function = @(t, x, v) stMass.Function(tn);
  case {3, 4} % M(t, x, v)
%     M = stMass.Function(tn, xn, vn);
end

% Make sure we have a column vector
x0 = x0(:);
v0 = v0(:);



%% Init output
% Don't refine output values: we already sample at a fixed step size
refine = 1;
% Calculation of 
nChunk = min(max(100,50*refine), refine+floor((2^11)/nEquations));

% Options for fsolve
stOptsFsolve = optimoptions( ...
    'fsolve' ...
    , 'Algorithm', 'levenberg-marquardt' ...
    , 'Display', 'off' ...
);

% Output time
tFull = zeros(1, nChunk, dataType);
% States at full time steps
xFull = zeros(nEquations, nChunk, dataType);
vFull = zeros(nEquations, nChunk, dataType);
aFull = zeros(nEquations, nChunk, dataType);
% States at half time steps
vHalf = zeros(nEquations, nChunk, dataType);

% Set initial values
nout = 1;
tFull(nout) = dTime_0;
xFull(:,nout) = x0;
vFull(:,nout) = v0;
% Calculate initial acceleration to determine the velocity at half a time step
% in the past
[aFull(:,nout), ~, ~, output] = fsolve( ...
  @(aTest) leapfrog_acceleration(odefun, dTime_0, x0, v0, aTest, stMass) ...
  , v0 ...
  , stOptsFsolve ...
);
% Calculate the velocity at (n-1/2)
vHalf(:,nout) = vFull(:,nout) - dStepsizeHalf*aFull(:,nout);  
% Advance function evaluation counter by the number of function evaluations
% inside `fsolve`
nFuncEval = nFuncEval + output.funcCount;

% Keep track of if we're done integrating or not
done = false;

while ~done
  
  % Current time value
  tN = round((nout - 1)*dStepsize, 1/dStepsize);
%   tN = tFull(nout);
  % Next time value
  tNp1 = round(nout*dStepsize, 1/dStepsize);
%   tNp1 = tN + dStepsize;
  
  % Current position x_n
  xN = xFull(:,nout);
  % Current acceleration
  aN = aFull(:,nout);
  % Previous position x_(n - 1)
  xNm1 = xFull(:,max([1, nout - 1]));
  % Previous velocity v_(n - 1/2)
  vNm12 = vHalf(:,nout);
  
  %%% Calculate the corrected acceleration at the current time step a_n
  % Predict an acceleration for the current time step based on solving the ODE
  % M*a = f for the current position but the previous velocity
  [aNPred, ~, ~, output] = fsolve( ...
      @(atest) leapfrog_acceleration(odefun, tN, xN, vNm12, atest, stMass) ...
    , aN ...
    , stOptsFsolve ...
  );
  % Advance function evaluation counter by the number of function evaluations
  % inside `fsolve`
  nFuncEval = nFuncEval + output.funcCount;

  % Calculate a predicted velocity \hat{v}_(n + 1/2)
  vNp12Pred = vNm12 + dStepsize*aNPred;

  % Calculate a predicted position x_(n + 1)
  xNp1Pred = xN + dStepsize*vNp12Pred;

  % Correct the velocity through the central difference of previous and next
  % state
  vN = (xNp1Pred - xNm1)/dStepsizeDouble;

  % And determine a corrected acceleration a_n knowing the corrected current
  % acceleration and the corrected current velocity
  [aN, ~, ~, output] = fsolve( ...
      @(atest) leapfrog_acceleration(odefun, tN, xN, vN, atest, stMass) ...
      , aNPred ...
      , stOptsFsolve ...
    );
  % Advance function evaluation counter by the number of function evaluations
  % inside `fsolve`
  nFuncEval = nFuncEval + output.funcCount;
  
  % Calculate next velocity v_(n + 1/2)
  vNp12 = vNm12 + dStepsize*aN;
  
  % Calculate next position x_(n + 1)
  xNp1 = xN + dStepsize*vNp12;
  
  % Update time step counter
  nout = nout + 1;
  
  % Enlarge time and solution storage if it's insufficiently small
  if nout > length(tFull)
    tFull = [tFull, zeros(1, nChunk, dataType)];
    xFull = [xFull, zeros(nEquations, nChunk, dataType)];
    vFull = [vFull, zeros(nEquations, nChunk, dataType)];
    aFull = [aFull, zeros(nEquations, nChunk, dataType)];
    vHalf = [vHalf, zeros(nEquations, nChunk, dataType)];
  end
  
  % Update next time value
  tFull(:,nout) = tNp1;
  
  % Update next position
  xFull(:,nout) = xNp1;
  
  % Update current velocity
  vFull(:,nout - 1) = vN;
  
  % Update next velocity
  vHalf(:,nout) = vNp12;
  
  % Update current acceleration
  aFull(:,nout - 1) = aN;
  
  % We are done if the new time value is the final time value
  done = tNp1 > dTime_T;
  
end

% Finalize data
tFull = tFull(1:(nout-1));
xout = xFull(:,1:(nout-1));
vout = vFull(:,1:(nout-1));



%% Assign output quantities

% LEAPFROG(...)
% SOL = LEAPFROG(...)
if nargout < 2
  varargout{1} = struct( ...
      'x', tFull ...
    , 'y', xout ...
    , 'z', vout ...
  );
end

% [T, [X, V]] = LEAPFROG(...)
if nargout < 3
  varargout{1} = transpose(tFull);
  varargout{2} = [transpose(xout), transpose(vout)];
end

% [T, X, V] = LEAPFROG(...)
if nargout < 4
  varargout{1} = transpose(tFull);
  varargout{2} = transpose(xout);
  varargout{3} = transpose(vout);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header
