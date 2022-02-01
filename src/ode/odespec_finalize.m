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
% Date: 2022-02-01
% Changelog:
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

% If the interval ab was increasing i.e., a < b, then the nodes and values at
% the nodes are in decreasing order since the Chebyshev-nodes are in decreasing
% order. Thus, we need to sort T and Y in reverse row order; in other words
% flip row 1 and N, row 2 and N-1, etc.
if tdir < 0
  tout = flip(tout, 2);
  yout = flip(yout, 1);

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
