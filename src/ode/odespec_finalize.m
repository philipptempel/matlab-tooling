function solver_output = odespec_finalize(tout, yout, sol)
%% ODESPEC_FINALIZE
%
% OUT = ODESPEC_FINALIZE(T, Y, SOL)
%
% Inputs:
%
%   T                   Description of argument T
%
%   Y                   Description of argument Y
%
%   SOL                 Description of argument SOL
%
% Outputs:
%
%   OUT                 Description of argument OUT
%
% See also:
%   ODESPEC



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-02
% Changelog:
%   2022-02-02
%       * Fix major error in how output node points are calculated and how the
%       spectral integration is performed. This reduces the number of flips and
%       transposes respectively puts them in a more central place
%   2022-02-01
%       * Initial release



%% Parse arguments

% ODESPEC_FINALIZE(TOUT, YOUT, SOL)
narginchk(3, 3);
% ODESPEC_FINALIZE(___)
% OUTPUT = ODESPEC_FINALIZE(___)
nargoutchk(0, 1);



%% Algorithm

% Initialize output
solver_output = {};

% Flip direction of state vector as it is always calculated on the interval [b,
% a] rather than [a, b]
yout = flip(yout, 1);

% SOL = ODESPEC_FINALIZE(...)
if ~isempty(sol)
  sol.x = tout;
  sol.y = transpose(yout);
  
  solver_output = {sol};

% [T, Y] = ODESPEC_FINALIZE(...)
else
  % Turn data into column-major
  tout = transpose(tout);
  
  solver_output{1} = tout;
  solver_output{2} = yout;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
