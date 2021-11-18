function v = cbrt(x)%#codegen
%% CBRT Cubic root of X
%
% V = CBRT(X) calculates the cubic root of X i.e., V = X ^ (1/3).
%
% Inputs:
%
%   X                   NxMx...xL array of values.
%
% Outputs:
%
%   V                   NxMx...xL array of cubic roots.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-10-07
%       * Initial release



%% Do your code magic here

v = x .^ ( 1.0 / 3.0 );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
