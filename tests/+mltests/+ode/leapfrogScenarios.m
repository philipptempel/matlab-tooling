classdef leapfrogScenarios < matlab.unittest.TestCase
  % LEAPFROGSCENARIOS tests the interface of LEAPFROG on problems with known solutions
  %
  %   The solver is compared against analytic solutions of harmonic oscillators,
  %   so these tests are fast, deterministic, and need no figures.
  
  
  
  %% PROPERTIES
  properties
    
    % Time stamps used by most tests
    tsp = 0:1e-2:2;
    
  end
  
  
  
  %% TESTPARAMETERS
  properties ( TestParameter )
    
    % Number of the output function call that requests a stop
    stopcall = struct('c2', 2, 'c3', 3, 'c10', 10, 'c100', 100);
    
    % Invalid ODEFUN, TSPAN, X0, V0 and the error each of them throws
    invalid = struct( ...
        'odefunIsNotAHandle', {{'rhs', 0:1e-2:1, 1, 0, 'ODE_ARGUMENTS:InvalidOdefun'}} ...
      , 'tspanIsScalar', {{@(t, y) -y(1), 0, 1, 0, 'ODE_ARGUMENTS:InvalidTspan'}} ...
      , 'tspanContainsNaN', {{@(t, y) -y(1), [0, NaN, 1], 1, 0, 'ODE_ARGUMENTS:InvalidTspan'}} ...
      , 'tspanContainsInf', {{@(t, y) -y(1), [0, 1, Inf], 1, 0, 'ODE_ARGUMENTS:InvalidTspan'}} ...
      , 'tspanIsNotMonotonic', {{@(t, y) -y(1), [0, 0.2, 0.1, 0.3], 1, 0, 'ODE_ARGUMENTS:TspanNotMonotonic'}} ...
      , 'tspanHasEqualEntries', {{@(t, y) -y(1), [0, 0.1, 0.1, 0.3], 1, 0, 'ODE_ARGUMENTS:TspanNotMonotonic'}} ...
      , 'tspanHasEqualEndpoints', {{@(t, y) -y(1), [1, 1], 1, 0, 'ODE_ARGUMENTS:TspanNotMonotonic'}} ...
      , 'initialStatesAreEmpty', {{@(t, y) -y(1), 0:1e-2:1, [], [], 'ODE_ARGUMENTS:InvalidY0'}} ...
      , 'initialStatesAreNotNumeric', {{@(t, y) -y(1), 0:1e-2:1, 'a', 'b', 'ODE_ARGUMENTS:InvalidY0'}} ...
      , 'positionAndVelocityDiffer', {{@(t, y) -y(1), 0:1e-2:1, [1; 2], 0, 'ODE_ARGUMENTS:InvalidY0'}} ...
      , 'odefunReturnsRow', {{@(t, y) -y(1:end/2).', 0:1e-2:1, [1; 2], [0; 0], 'ODE_ARGUMENTS:InvalidOdefunSize'}} ...
      , 'odefunReturnsWrongLength', {{@(t, y) y, 0:1e-2:1, 1, 0, 'ODE_ARGUMENTS:InvalidOdefunSize'}} ...
    );
    
  end
  
  
  
  %% STATIC METHODS
  methods ( Static )
    
    function a = oscillator(~, y)
      %% OSCILLATOR is the acceleration of x'' = -x with the solution cos(t)
      
      
      a = -y(1);
      
    end
    
    
    function a = oscillators(~, y)
      %% OSCILLATORS are two decoupled oscillators with frequencies 1 and 2
      
      
      a = -[1; 4].*y(1:2);
      
    end
    
  end
  
  
  
  %% TESTS: ACCURACY
  methods ( Test )
    
    function positionHasSmallError(this)
      %% POSITIONHASSMALLERROR solves x'' = -x
      
      
      [t, x, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0);
      
      this.verifyEqual(x, cos(t), 'AbsTol', 1e-4);
      
    end
    
    
    function velocityHasSmallError(this)
      %% VELOCITYHASSMALLERROR solves x'' = -x
      
      
      [t, ~, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0);
      
      this.verifyEqual(v, -sin(t), 'AbsTol', 1e-3);
      
    end
    
    
    function nonzeroInitialVelocity(this)
      %% NONZEROINITIALVELOCITY solves x'' = -x with x(0) = 0 and v(0) = 1
      
      
      [t, x, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 0, 1);
      
      this.verifyEqual(x, sin(t), 'AbsTol', 1e-4);
      this.verifyEqual(v, cos(t), 'AbsTol', 1e-3);
      
    end
    
    
    function severalDegreesOfFreedom(this)
      %% SEVERALDEGREESOFFREEDOM solves decoupled oscillators with other frequencies
      
      
      [t, x, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0]);
      
      this.verifyEqual(x, [cos(t), cos(2*t)], 'AbsTol', 1e-3);
      this.verifyEqual(v, [-sin(t), -2*sin(2*t)], 'AbsTol', 1e-3);
      
    end
    
    
    function returnsRequestedTimeStamps(this)
      %% RETURNSREQUESTEDTIMESTAMPS returns the time stamps as column vector
      
      
      [t, ~, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0);
      
      this.verifyEqual(t, this.tsp(:), 'AbsTol', 1000*eps);
      
    end
    
    
    function firstPositionIsInitialPosition(this)
      %% FIRSTPOSITIONISINITIALPOSITION starts at X0
      
      
      [~, x, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [0.3; -0.7], [0; 0]);
      
      this.verifyEqual(x(1,:), [0.3, -0.7]);
      
    end
    
    
    function acceptsTwoTimeStamps(this)
      %% ACCEPTSTWOTIMESTAMPS integrates a single step
      
      
      [t, ~, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, [0, 0.5], 1, 0);
      
      this.verifyEqual(t, [0; 0.5], 'AbsTol', 1000*eps);
      
    end
    
  end
  
  
  
  %% TESTS: OUTPUTS
  methods ( Test )
    
    function threeOutputsAreTimePositionAndVelocity(this)
      %% THREEOUTPUTSARETIMEPOSITIONANDVELOCITY returns [T, X, V] with one row per time
      
      
      [t, x, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0]);
      
      this.verifySize(t, [numel(this.tsp), 1]);
      this.verifySize(x, [numel(this.tsp), 2]);
      this.verifySize(v, [numel(this.tsp), 2]);
      
    end
    
    
    function twoOutputsAreTimeAndStackedStates(this)
      %% TWOOUTPUTSARETIMEANDSTACKEDSTATES returns [T, [X, V]]
      
      
      [t, x, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0]);
      [t2, xv] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0]);
      
      this.verifyEqual(t2, t);
      this.verifySize(xv, [numel(this.tsp), 4]);
      this.verifyEqual(xv, [x, v]);
      
    end
    
    
    function oneOutputIsStruct(this)
      %% ONEOUTPUTISSTRUCT returns a solution structure
      %
      %   The positions are in field `y` and the velocities in field `z`.
      
      
      [t, x, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0]);
      sol = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0]);
      
      this.verifyClass(sol, 'struct');
      this.verifyEqual(sol.x, transpose(t));
      this.verifyEqual(sol.y, transpose(x));
      this.verifyEqual(sol.z, transpose(v));
      
    end
    
    
    function resultIsDouble(this)
      %% RESULTISDOUBLE returns double precision values
      
      
      [t, x, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0);
      
      this.verifyClass(t, 'double');
      this.verifyClass(x, 'double');
      this.verifyClass(v, 'double');
      
    end
    
  end
  
  
  
  %% TESTS: EXTRA PARAMETERS
  methods ( Test )
    
    function extraParametersReachOdefun(this)
      %% EXTRAPARAMETERSREACHODEFUN appends them to the arguments of ODEFUN
      
      
      [t, x, ~] = leapfrog(@(t, y, k) -k*y(1), this.tsp, 1, 0, odeset(), 4);
      
      this.verifyEqual(x, cos(2*t), 'AbsTol', 1e-3);
      
    end
    
    
    function multipleExtraParametersReachOdefunInOrder(this)
      %% MULTIPLEEXTRAPARAMETERSREACHODEFUNINORDER keeps their order
      
      
      [t, x, ~] = leapfrog(@(t, y, a, b) -(a - b)*y(1), this.tsp, 1, 0, odeset(), 5, 1);
      
      this.verifyEqual(x, cos(2*t), 'AbsTol', 1e-3);
      
    end
    
    
    function extraParametersReachMassFunction(this)
      %% EXTRAPARAMETERSREACHMASSFUNCTION calls M(t, [x; v], p1, ...)
      
      
      [t, x, ~] = leapfrog(@(t, y, k, m) -m*k.*y(1:2), this.tsp, [1; 1], [0; 0], odeset('Mass', @(t, y, k, m) m*eye(2)), [1; 4], 2);
      
      this.verifyEqual(x, [cos(t), cos(2*t)], 'AbsTol', 1e-3);
      
    end
    
    
    function extraParametersReachOutputFunction(this)
      %% EXTRAPARAMETERSREACHOUTPUTFUNCTION appends them to every call
      
      
      rec = mltests.ode.OutputRecorder();
      
      leapfrog(@(t, y, varargin) -varargin{1}*y(1), this.tsp, 1, 0, odeset('OutputFcn', @rec.call), 2, 'abc');
      
      this.verifyNotEmpty(rec.Extras);
      for iCall = 1:rec.numCalls()
        this.verifyEqual(rec.Extras{iCall}, {2, 'abc'});
      end
      
    end
    
  end
  
  
  
  %% TESTS: MASS MATRIX
  methods ( Test )
    
    function constantScalarMass(this)
      %% CONSTANTSCALARMASS solves 2*x'' = -2*x
      
      
      [t, x, ~] = leapfrog(@(t, y) -2*y(1), this.tsp, 1, 0, odeset('Mass', 2));
      
      this.verifyEqual(x, cos(t), 'AbsTol', 1e-4);
      
    end
    
    
    function constantMassMatrix(this)
      %% CONSTANTMASSMATRIX solves M*x'' = f with diagonal M
      
      
      [t, x, ~] = leapfrog(@(t, y) -[2; 16].*y(1:2), this.tsp, [1; 1], [0; 0], odeset('Mass', diag([2, 4])));
      
      this.verifyEqual(x, [cos(t), cos(2*t)], 'AbsTol', 1e-3);
      
    end
    
    
    function identityMassMatrixIsDefault(this)
      %% IDENTITYMASSMATRIXISDEFAULT behaves like an explicit identity matrix
      
      
      [~, xd, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0]);
      [~, xm, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0], odeset('Mass', eye(2)));
      
      this.verifyEqual(xm, xd, 'AbsTol', 1e-9);
      
    end
    
    
    function stateDependentMassMatrix(this)
      %% STATEDEPENDENTMASSMATRIX calls M(t, [x; v]) by default
      
      
      [t, x, ~] = leapfrog(@(t, y) -2*y(1), this.tsp, 1, 0, odeset('Mass', @(t, y) 2));
      
      this.verifyEqual(x, cos(t), 'AbsTol', 1e-4);
      
    end
    
    
    function stateDependentMassMatrixOfSeveralStates(this)
      %% STATEDEPENDENTMASSMATRIXOFSEVERALSTATES returns an NxN matrix
      
      
      [t, x, ~] = leapfrog(@(t, y) -[2; 16].*y(1:2), this.tsp, [1; 1], [0; 0], odeset('Mass', @(t, y) diag([2, 4])));
      
      this.verifyEqual(x, [cos(t), cos(2*t)], 'AbsTol', 1e-3);
      
    end
    
    
    function timeDependentMassMatrix(this)
      %% TIMEDEPENDENTMASSMATRIX calls M(t) if MSTATEDEPENDENCE is none
      
      
      [t, x, ~] = leapfrog(@(t, y) -2*y(1), this.tsp, 1, 0, odeset('Mass', @(t) 2, 'MStateDependence', 'none'));
      
      this.verifyEqual(x, cos(t), 'AbsTol', 1e-4);
      
    end
    
    
    function invalidMassThrowsError(this)
      %% INVALIDMASSTHROWSERROR rejects a mass that is neither matrix nor handle
      
      
      this.verifyError( ...
          @() leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0, odeset('Mass', 'M(t)')) ...
        , 'PHILIPPTEMPEL:MATLAB_TOOLING:ODE_MASS:InvalidMass' ...
      );
      
    end
    
  end
  
  
  
  %% TESTS: OUTPUT FUNCTION
  methods ( Test )
    
    function outputFcnIsInitializedFirst(this)
      %% OUTPUTFCNISINITIALIZEDFIRST calls the output function with init
      
      
      rec = mltests.ode.OutputRecorder();
      
      leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 0.5], [0; 0.25], odeset('OutputFcn', @rec.call));
      
      this.verifyEqual(rec.Flags{1}, 'init');
      this.verifyEqual(rec.Times{1}, this.tsp([1, end]), 'AbsTol', 1000*eps);
      this.verifyEqual(rec.States{1}, [1; 0.5; 0; 0.25]);
      
    end
    
    
    function outputFcnIsCalledOncePerStep(this)
      %% OUTPUTFCNISCALLEDONCEPERSTEP calls the output function init, steps, done
      
      
      rec = mltests.ode.OutputRecorder();
      
      leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0, odeset('OutputFcn', @rec.call));
      
      % init, one call for each time stamp but the first, and done
      this.verifyEqual(rec.numCalls(), numel(this.tsp) + 1);
      this.verifyTrue(all(cellfun(@isempty, rec.Flags(2:end-1))));
      
    end
    
    
    function outputFcnReceivesPositionAndVelocity(this)
      %% OUTPUTFCNRECEIVESPOSITIONANDVELOCITY passes both to each step
      
      
      rec = mltests.ode.OutputRecorder();
      
      leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0], odeset('OutputFcn', @rec.call));
      
      for iCall = 2:rec.numCalls()-1
        this.verifyNumElements(rec.States{iCall}, 4);
      end
      
    end
    
    
    function outputFcnIsFinalizedLast(this)
      %% OUTPUTFCNISFINALIZEDLAST calls the output function with done
      
      
      rec = mltests.ode.OutputRecorder();
      
      leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0, odeset('OutputFcn', @rec.call));
      
      this.verifyEqual(rec.Flags{end}, 'done');
      this.verifyEmpty(rec.Times{end});
      this.verifyEmpty(rec.States{end});
      
    end
    
    
    function stopRequestEndsIntegration(this, stopcall)
      %% STOPREQUESTENDSINTEGRATION stops with the call that requested it
      
      
      rec = mltests.ode.OutputRecorder();
      rec.StopAtCall = stopcall;
      
      [t, x, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0, odeset('OutputFcn', @rec.call));
      
      % Call n has produced time stamp n
      this.verifyEqual(t, this.tsp(1:stopcall).', 'AbsTol', 1000*eps);
      this.verifySize(x, [stopcall, 1]);
      % init, stopcall - 1 steps, and done
      this.verifyEqual(rec.numCalls(), stopcall + 1);
      this.verifyEqual(rec.Flags{end}, 'done');
      
    end
    
    
    function noPlotIfOutputsAreRequested(this)
      %% NOPLOTIFOUTPUTSAREREQUESTED does not call the default plot function
      
      
      figs = findall(groot(), 'Type', 'figure');
      
      [~, ~, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0);
      
      this.verifyEqual(numel(findall(groot(), 'Type', 'figure')), numel(figs));
      
    end
    
  end
  
  
  
  %% TESTS: INVALID ARGUMENTS
  methods ( Test )
    
    function invalidArgumentsThrowError(this, invalid)
      %% INVALIDARGUMENTSTHROWERROR rejects invalid arguments with an identifier
      
      
      [odefun, tspan, x0, v0, id] = invalid{:};
      
      this.verifyError( ...
          @() leapfrog(odefun, tspan, x0, v0) ...
        , ['PHILIPPTEMPEL:MATLAB_TOOLING:' , id] ...
      );
      
    end
    
  end
  
  
  
  %% TESTS: KNOWN ISSUES
  methods ( Test )
    
    function firstVelocityIsInitialVelocity(this)
      %% FIRSTVELOCITYISINITIALVELOCITY starts at V0
      
      
      [~, ~, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 0, 1);
      
      this.verifyEqual(v(1), 1, 'AbsTol', 1e-12);
      
    end
    
    
    function acceptsRowInitialStates(this)
      %% ACCEPTSROWINITIALSTATES treats row and column initial states the same
      
      
      this.assumeFail('Known issue: X0 and V0 are used as given in the solver loop, so row vectors fail with a size mismatch.');
      
      [~, xr, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1, 1], [0, 0]);
      [~, xc, ~] = leapfrog(@mltests.ode.leapfrogScenarios.oscillators, this.tsp, [1; 1], [0; 0]);
      
      this.verifyEqual(xr, xc);
      
    end
    
    
    function lastVelocityIsComputed(this)
      %% LASTVELOCITYISCOMPUTED returns the velocity at the final time
      
      
      [t, ~, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0);
      
      this.verifyEqual(v(end), -sin(t(end)), 'AbsTol', 1e-3);
      
    end
    
    
    function lastVelocityIsComputedAfterStopRequest(this)
      %% LASTVELOCITYISCOMPUTEDAFTERSTOPREQUEST returns the velocity at the stop
      
      
      rec = mltests.ode.OutputRecorder();
      rec.StopAtCall = 50;
      
      [t, ~, v] = leapfrog(@mltests.ode.leapfrogScenarios.oscillator, this.tsp, 1, 0, odeset('OutputFcn', @rec.call));
      
      this.verifyEqual(v, -sin(t), 'AbsTol', 1e-3);
      
    end
    
  end
  
end
