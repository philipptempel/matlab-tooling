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

% Direction of integration
tdir = sign(tout(end) - tout(1));

% If the interval [a,b] was increasing i.e., a < b, then the Chebyshev points
% are sorted on a decreasing interval from [+1,-1]. Thus, we need to reverse the
% order of values in this case
if tdir > 0
  yout = flip(yout, 1);
end

% If the interval [b,a] was decreasing i.e., b > a, then the Chebyshev points
% are in the reverse order to the integration interval. Thus, we need to change
% the order of the node points
if tdir < 0
  tout = flip(tout, 2);
end

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
