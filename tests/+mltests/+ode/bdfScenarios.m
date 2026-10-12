classdef bdfScenarios < matlab.unittest.TestCase
  % BDFSCENARIOS tests the interface of BDF on problems with known solutions
  %
  %   The solver is not compared against MATLAB's solvers but against analytic
  %   solutions, so these tests are fast, deterministic, and need no figures.
  
  
  
  %% PROPERTIES
  properties
    
    % Time stamps used by most tests
    tsp = 0:1e-2:1;
    
  end
  
  
  
  %% TESTPARAMETERS
  properties ( TestParameter )
    
    % Order of BDF
    ordr = struct('o1', 1, 'o2', 2, 'o3', 3, 'o4', 4, 'o5', 5, 'o6', 6);
    
    % Number of the output function call that requests a stop: the first four
    % calls are in the start-up phase of BDF3, the others in the main phase
    stopcall = struct('c2', 2, 'c3', 3, 'c4', 4, 'c10', 10, 'c50', 50);
    
    % Invalid ODEFUN, TSPAN, Y0 and the error each of them throws
    invalid = struct( ...
        'odefunIsNotAHandle', {{'rhs', 0:1e-2:1, 1, 'ODE_ARGUMENTS:InvalidOdefun'}} ...
      , 'tspanIsScalar', {{@(t, y) -y, 0, 1, 'ODE_ARGUMENTS:InvalidTspan'}} ...
      , 'tspanContainsNaN', {{@(t, y) -y, [0, NaN, 1], 1, 'ODE_ARGUMENTS:InvalidTspan'}} ...
      , 'tspanContainsInf', {{@(t, y) -y, [0, 1, Inf], 1, 'ODE_ARGUMENTS:InvalidTspan'}} ...
      , 'tspanIsComplex', {{@(t, y) -y, [0, 1i, 1], 1, 'ODE_ARGUMENTS:InvalidTspan'}} ...
      , 'tspanIsNotMonotonic', {{@(t, y) -y, [0, 0.2, 0.1, 0.3], 1, 'ODE_ARGUMENTS:TspanNotMonotonic'}} ...
      , 'tspanHasEqualEntries', {{@(t, y) -y, [0, 0.1, 0.1, 0.3], 1, 'ODE_ARGUMENTS:TspanNotMonotonic'}} ...
      , 'tspanHasEqualEndpoints', {{@(t, y) -y, [1, 1], 1, 'ODE_ARGUMENTS:TspanNotMonotonic'}} ...
      , 'y0IsEmpty', {{@(t, y) -y, 0:1e-2:1, [], 'ODE_ARGUMENTS:InvalidY0'}} ...
      , 'y0IsNotNumeric', {{@(t, y) -y, 0:1e-2:1, 'a', 'ODE_ARGUMENTS:InvalidY0'}} ...
      , 'odefunReturnsRow', {{@(t, y) -y.', 0:1e-2:1, [1; 2], 'ODE_ARGUMENTS:InvalidOdefunSize'}} ...
      , 'odefunReturnsWrongLength', {{@(t, y) [y; y], 0:1e-2:1, [1; 2], 'ODE_ARGUMENTS:InvalidOdefunSize'}} ...
    );
    
  end
  
  
  
  %% STATIC METHODS
  methods ( Static )
    
    function dydt = decay(~, y)
      %% DECAY is y' = -y with the solution y = exp(-t)
      
      
      dydt = -y;
      
    end
    
    
    function dydt = oscillator(~, y)
      %% OSCILLATOR is the harmonic oscillator with the solution [cos(t); -sin(t)]
      
      
      dydt = [y(2); -y(1)];
      
    end
    
  end
  
  
  
  %% TESTS: ACCURACY
  methods ( Test )
    
    function decayHasSmallErrorForEveryOrder(this, ordr)
      %% DECAYHASSMALLERRORFOREVERYORDER solves y' = -y with every BDF order
      
      
      [t, y] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1, odeset('MaxOrder', ordr));
      
      % The first order is only first-order accurate: error is about h/2
      tol = 3e-3;
      if ordr > 1
        tol = 3e-4;
      end
      
      this.verifyEqual(y, exp(-t), 'AbsTol', tol);
      
    end
    
    
    function oscillatorHasSmallError(this)
      %% OSCILLATORHASSMALLERROR solves a system with two states
      
      
      [t, y] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0], odeset('MaxOrder', 3));
      
      this.verifyEqual(y, [cos(t), -sin(t)], 'AbsTol', 5e-4);
      
    end
    
    
    function returnsRequestedTimeStamps(this, ordr)
      %% RETURNSREQUESTEDTIMESTAMPS returns the time stamps as column vector
      
      
      [t, ~] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1, odeset('MaxOrder', ordr));
      
      this.verifyEqual(t, this.tsp(:), 'AbsTol', 1000*eps);
      
    end
    
    
    function firstStateIsInitialState(this)
      %% FIRSTSTATEISINITIALSTATE starts at Y0
      
      
      [~, y] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [0.3; -0.7]);
      
      this.verifyEqual(y(1,:), [0.3, -0.7]);
      
    end
    
    
    function acceptsColumnTspan(this)
      %% ACCEPTSCOLUMNTSPAN treats row and column time vectors the same
      
      
      [tr, yr] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1);
      [tc, yc] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp(:), 1);
      
      this.verifyEqual(tc, tr);
      this.verifyEqual(yc, yr);
      
    end
    
    
    function acceptsRowY0(this)
      %% ACCEPTSROWY0 treats row and column initial states the same
      
      
      [~, yr] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1, 0]);
      [~, yc] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0]);
      
      this.verifyEqual(yr, yc);
      
    end
    
  end
  
  
  
  %% TESTS: OPTIONS
  methods ( Test )
    
    function defaultOrderIsThree(this)
      %% DEFAULTORDERISTHREE uses BDF3 if no order is given
      
      
      [~, yd] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1);
      [~, y3] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1, odeset('MaxOrder', 3));
      
      this.verifyEqual(yd, y3);
      
    end
    
    
    function orderBelowOneIsClampedToOne(this)
      %% ORDERBELOWONEISCLAMPEDTOONE uses BDF1 if order is smaller than 1
      
      
      [~, y0] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1, odeset('MaxOrder', 0));
      [~, y1] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1, odeset('MaxOrder', 1));
      
      this.verifyEqual(y0, y1);
      
    end
    
    
    function orderAboveSixIsClampedToSix(this)
      %% ORDERABOVESIXISCLAMPEDTOSIX uses BDF6 if order is larger than 6
      
      
      [~, y9] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1, odeset('MaxOrder', 9));
      [~, y6] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1, odeset('MaxOrder', 6));
      
      this.verifyEqual(y9, y6);
      
    end
    
  end
  
  
  
  %% TESTS: OUTPUTS
  methods ( Test )
    
    function twoOutputsAreTimeAndStateColumns(this)
      %% TWOOUTPUTSARETIMEANDSTATECOLUMNS returns [T, Y] with one row per time
      
      
      [t, y] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0]);
      
      this.verifySize(t, [numel(this.tsp), 1]);
      this.verifySize(y, [numel(this.tsp), 2]);
      
    end
    
    
    function oneOutputIsStruct(this)
      %% ONEOUTPUTISSTRUCT returns a solution structure with time and states
      
      
      [t, y] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0]);
      sol = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0]);
      
      this.verifyClass(sol, 'struct');
      this.verifyTrue(isfield(sol, 'x'));
      this.verifyTrue(isfield(sol, 'y'));
      this.verifyEqual(sol.x, transpose(t));
      this.verifyEqual(sol.y, transpose(y));
      
    end
    
    
    function resultIsDouble(this)
      %% RESULTISDOUBLE returns double precision values
      
      
      [t, y] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1);
      
      this.verifyClass(t, 'double');
      this.verifyClass(y, 'double');
      
    end
    
  end
  
  
  
  %% TESTS: EXTRA PARAMETERS
  methods ( Test )
    
    function extraParametersReachOdefun(this)
      %% EXTRAPARAMETERSREACHODEFUN appends them to the arguments of ODEFUN
      
      
      [t, y] = bdf(@(t, y, k) -k*y, this.tsp, 1, odeset(), 2);
      
      this.verifyEqual(y, exp(-2*t), 'AbsTol', 3e-4);
      
    end
    
    
    function multipleExtraParametersReachOdefunInOrder(this)
      %% MULTIPLEEXTRAPARAMETERSREACHODEFUNINORDER keeps their order
      
      
      [t, y] = bdf(@(t, y, a, b) -(a - b)*y, this.tsp, 1, odeset(), 3, 1);
      
      this.verifyEqual(y, exp(-2*t), 'AbsTol', 3e-4);
      
    end
    
    
    function extraParametersReachStateDependentMassFunction(this)
      %% EXTRAPARAMETERSREACHSTATEDEPENDENTMASSFUNCTION calls M(t, y, p1, ...)
      
      
      [t, y] = bdf(@(t, y, k) -k*y, this.tsp, 1, odeset('Mass', @(t, y, k) k/2), 2);
      
      this.verifyEqual(y, exp(-2*t), 'AbsTol', 3e-4);
      
    end
    
    
    function extraParametersReachTimeDependentMassFunction(this)
      %% EXTRAPARAMETERSREACHTIMEDEPENDENTMASSFUNCTION calls M(t, p1, ...)
      
      
      [t, y] = bdf(@(t, y, k) -k*y, this.tsp, 1, odeset('Mass', @(t, k) k/2, 'MStateDependence', 'none'), 2);
      
      this.verifyEqual(y, exp(-2*t), 'AbsTol', 3e-4);
      
    end
    
    
    function extraParametersReachOutputFunction(this)
      %% EXTRAPARAMETERSREACHOUTPUTFUNCTION appends them to every call
      
      
      rec = mltests.ode.OutputRecorder();
      
      bdf(@(t, y, varargin) -varargin{1}*y, this.tsp, 1, odeset('OutputFcn', @rec.call), 2, 'abc');
      
      this.verifyNotEmpty(rec.Extras);
      for iCall = 1:rec.numCalls()
        this.verifyEqual(rec.Extras{iCall}, {2, 'abc'});
      end
      
    end
    
  end
  
  
  
  %% TESTS: MASS MATRIX
  methods ( Test )
    
    function identityMassMatrixIsDefault(this)
      %% IDENTITYMASSMATRIXISDEFAULT behaves like an explicit identity matrix
      
      
      [~, yd] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0]);
      [~, ym] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0], odeset('Mass', eye(2)));
      
      this.verifyEqual(ym, yd, 'AbsTol', 1e-9);
      
    end
    
    
    function constantMassMatrixScalesTheSolution(this)
      %% CONSTANTMASSMATRIXSCALESTHESOLUTION solves 2*y' = -2*y
      
      
      [t, y] = bdf(@(t, y) -2*y, this.tsp, 1, odeset('Mass', 2));
      
      this.verifyEqual(y, exp(-t), 'AbsTol', 3e-4);
      
    end
    
    
    function constantMassMatrixOfSeveralStates(this)
      %% CONSTANTMASSMATRIXOFSEVERALSTATES solves M*y' = f with diagonal M
      
      
      [t, y] = bdf(@(t, y) [2*y(2); -4*y(1)], this.tsp, [1; 0], odeset('Mass', diag([2, 4])));
      
      this.verifyEqual(y, [cos(t), -sin(t)], 'AbsTol', 5e-4);
      
    end
    
    
    function timeDependentMassMatrix(this)
      %% TIMEDEPENDENTMASSMATRIX calls M(t) if MSTATEDEPENDENCE is none
      
      
      [t, y] = bdf(@(t, y) -2*y, this.tsp, 1, odeset('Mass', @(t) 2, 'MStateDependence', 'none'));
      
      this.verifyEqual(y, exp(-t), 'AbsTol', 3e-4);
      
    end
    
    
    function timeVaryingMassMatrix(this)
      %% TIMEVARYINGMASSMATRIX evaluates M(t) at every step
      
      
      % (1 + t)*y' = -y has the solution y = 1/(1 + t)
      [t, y] = bdf(@(t, y) -y, this.tsp, 1, odeset('Mass', @(t) 1 + t, 'MStateDependence', 'none'));
      
      this.verifyEqual(y, 1./(1 + t), 'AbsTol', 3e-4);
      
    end
    
    
    function weaklyStateDependentMassMatrix(this)
      %% WEAKLYSTATEDEPENDENTMASSMATRIX calls M(t, y) by default
      
      
      [t, y] = bdf(@(t, y) -2*y, this.tsp, 1, odeset('Mass', @(t, y) 2));
      
      this.verifyEqual(y, exp(-t), 'AbsTol', 3e-4);
      
    end
    
    
    function stronglyStateDependentMassMatrix(this)
      %% STRONGLYSTATEDEPENDENTMASSMATRIX calls M(t, y) for strong dependence
      
      
      [t, y] = bdf(@(t, y) -2*y, this.tsp, 1, odeset('Mass', @(t, y) 2, 'MStateDependence', 'strong'));
      
      this.verifyEqual(y, exp(-t), 'AbsTol', 3e-4);
      
    end
    
    
    function invalidMassThrowsError(this)
      %% INVALIDMASSTHROWSERROR rejects a mass that is neither matrix nor handle
      
      
      this.verifyError( ...
          @() bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1, odeset('Mass', 'M(t)')) ...
        , 'PHILIPPTEMPEL:MATLAB_TOOLING:ODE_MASS:InvalidMass' ...
      );
      
    end
    
  end
  
  
  
  %% TESTS: OUTPUT FUNCTION
  methods ( Test )
    
    function outputFcnIsInitializedFirst(this)
      %% OUTPUTFCNISINITIALIZEDFIRST calls the output function with init
      
      
      rec = mltests.ode.OutputRecorder();
      
      bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0], odeset('OutputFcn', @rec.call));
      
      this.verifyEqual(rec.Flags{1}, 'init');
      this.verifyEqual(rec.Times{1}, this.tsp([1, end]), 'AbsTol', 1000*eps);
      this.verifyEqual(rec.States{1}, [1; 0]);
      
    end
    
    
    function outputFcnIsCalledOncePerStep(this)
      %% OUTPUTFCNISCALLEDONCEPERSTEP calls the output function init, steps, done
      
      
      rec = mltests.ode.OutputRecorder();
      
      bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0], odeset('OutputFcn', @rec.call));
      
      % init, one call for each time stamp but the first, and done
      this.verifyEqual(rec.numCalls(), numel(this.tsp) + 1);
      this.verifyTrue(all(cellfun(@isempty, rec.Flags(2:end-1))));
      
    end
    
    
    function outputFcnReceivesStatesOfEachStep(this)
      %% OUTPUTFCNRECEIVESSTATESOFEACHSTEP passes time and column state
      
      
      rec = mltests.ode.OutputRecorder();
      
      [t, y] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0], odeset('OutputFcn', @rec.call));
      
      % Calls 2 to end-1 are steps 2 to N
      this.verifyEqual(cell2mat(rec.Times(2:end-1)), transpose(t(2:end)), 'AbsTol', 1000*eps);
      this.verifyEqual(horzcat(rec.States{2:end-1}), transpose(y(2:end,:)), 'AbsTol', 1000*eps);
      
    end
    
    
    function outputFcnIsFinalizedLast(this)
      %% OUTPUTFCNISFINALIZEDLAST calls the output function with done
      
      
      rec = mltests.ode.OutputRecorder();
      
      bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0], odeset('OutputFcn', @rec.call));
      
      this.verifyEqual(rec.Flags{end}, 'done');
      this.verifyEmpty(rec.Times{end});
      this.verifyEmpty(rec.States{end});
      
    end
    
    
    function stopRequestEndsIntegration(this, stopcall)
      %% STOPREQUESTENDSINTEGRATION stops with the call that requested it
      %
      %   This covers requests during start-up of the multi-step method (calls 2
      %   to 4 for BDF3) and during the main phase.
      
      
      rec = mltests.ode.OutputRecorder();
      rec.StopAtCall = stopcall;
      
      [t, y] = bdf(@mltests.ode.bdfScenarios.oscillator, this.tsp, [1; 0], odeset('OutputFcn', @rec.call, 'MaxOrder', 3));
      
      % Call n has produced time stamp n
      this.verifyEqual(t, this.tsp(1:stopcall).', 'AbsTol', 1000*eps);
      this.verifySize(y, [stopcall, 2]);
      % init, stopcall - 1 steps, and done
      this.verifyEqual(rec.numCalls(), stopcall + 1);
      this.verifyEqual(rec.Flags{end}, 'done');
      
    end
    
    
    function noPlotIfOutputsAreRequested(this)
      %% NOPLOTIFOUTPUTSAREREQUESTED does not call the default plot function
      
      
      % Requesting outputs must not open the default plot function ODEPLOT
      figs = findall(groot(), 'Type', 'figure');
      
      [~, ~] = bdf(@mltests.ode.bdfScenarios.decay, this.tsp, 1);
      
      this.verifyEqual(numel(findall(groot(), 'Type', 'figure')), numel(figs));
      
    end
    
  end
  
  
  
  %% TESTS: INVALID ARGUMENTS
  methods ( Test )
    
    function invalidArgumentsThrowError(this, invalid)
      %% INVALIDARGUMENTSTHROWERROR rejects invalid arguments with an identifier
      
      
      [odefun, tspan, y0, id] = invalid{:};
      
      this.verifyError( ...
          @() bdf(odefun, tspan, y0) ...
        , ['PHILIPPTEMPEL:MATLAB_TOOLING:' , id] ...
      );
      
    end
    
  end
  
  
  
  %% TESTS: KNOWN ISSUES
  methods ( Test )
    
    function integratesBackwardInTime(this)
      %% INTEGRATESBACKWARDINTIME solves with decreasing time stamps
      
      
      this.assumeFail('Known issue: BDF always steps forward in time, so decreasing time stamps are not integrated backward.');
      
      tspBack = 1:-1e-2:0;
      
      [t, y] = bdf(@(t, y) -y, tspBack, exp(-1));
      
      this.verifyEqual(t, tspBack(:), 'AbsTol', 1000*eps);
      this.verifyEqual(y, exp(-t), 'AbsTol', 3e-4);
      
    end
    
    
    function integratesFewerTimeStampsThanOrder(this)
      %% INTEGRATESFEWERTIMESTAMPSTHANORDER solves with two time stamps
      
      
      this.assumeFail('Known issue: BDF never terminates if TSPAN has no more elements than the order of the method, e.g., a 2-element TSPAN with the default order.');
      
      [t, y] = bdf(@(t, y) -y, [0, 0.5], 1);
      
      this.verifyEqual(t, [0; 0.5]);
      this.verifySize(y, [2, 1]);
      
    end
    
  end
  
end
