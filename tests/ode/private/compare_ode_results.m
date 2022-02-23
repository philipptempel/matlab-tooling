function compare_ode_results(ab, g, varargin)
%% COMPARE_ODE_RESULTS
%
% COMPARE_ODE_RESULTS(AB, GROUND, CANDIDATE1, CANDIDATE2, ...)
%
% Inputs:
%
%   AB                  2-element vector defining the interval boundaries of
%                       integration as well as the integration direction.
%
%   G                   Tx(Y+1) array of ground truth values where G(:,1) is the
%                       independent variable of the solution and G(:,2:end) are
%                       the dependent variables
%
%   CANDIDATEx          Tx(Y+1) array of candidate values to compare against
%                       ground truth G.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-23
% Changelog:
%   2022-02-23
%       * Change columns of comparison table to use absolute difference between
%       ground truth and candidate
%       * Update usage of `ALLISCLOSE` to follow correct argument order of
%       `CANDIDATE, GROUNDTRUTH`
%   2021-12-13
%       * Initial release



%% Parse arguments

% COMPARE_ODE_RESULTS(AB, GROUND, CANDIDATE1, ...)
narginchk(3, Inf);

% COMPARE_ODE_RESULTS(___)
nargoutchk(0, 0);



%% Algorithm

% Tolerances for comparison
atol = 5 * 1e-3;
rtol = 1 * 1e-9;

% Direction of integration
tdir = sign(ab(2) - ab(1));

% Get ground truth values
x_g = g(:,1);
y_g = g(:,2:end);
% Number of states
ny = size(y_g, 2);

% Candidates
candidates = varargin;
ncands = numel(candidates);

fprintf('Verifying %s ODE %dd is correct...\n', human(tdir), ny);

% Compare each candidate
for icand = 1:ncands
  % Extract solution
  sol_cand = candidates{icand};
  % Get X and Y vector from solution
  x_c = sol_cand(:,1);
  y_c = sol_cand(:,2:end);
  
  % Ensure the X and Y values are fairly close to each other
  assert(allisclose(x_c, x_g, atol, rtol));
  assert(allisclose(y_c, y_g, atol, rtol));
  cprintf('*green', '\tsuccess\n');
  
  % Build a table of datas for easier comparison and display
  t = array2table( ...
    [ abs(x_g - x_c) , abs(y_g - y_c) ] ...
      , 'VariableNames', [ ...
        sprintf('x_g - x_c%d', icand) ...
      , arrayfun( ...
            @(idx) sprintf('y_g(%d) - y_c%d(%d)', idx, icand, idx) ...
          , 1:ny ...
          , 'UniformOutput', false ...
        ) ...
    ] ...
  );
  % Show summary of table
  summary(t)
  fprintf(newline());
  
end

fprintf(newline());


end


function s = human(d)
%% HUMAN
%
% S = HUMAN(D)
%
% Inputs:
%
%   D                       Scalar direction value.
%
% Outputs:
%
%   S                       Char vector providing the human-readable text of
%                           direction D.



% Negative direction
if d < 0
  s = 'backward';

% Positive direction
else
  s = 'forward';
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
