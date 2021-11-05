function e = true_error(g, c)%#codegen
%% TRUE_ERROR Calculate true error between G and C.
%
% E = TRUE_ERROR(G, C) determines the true error between ground truth values G
% and candidate values C via $E = G - C$.
%
% Inputs:
%
%   G                   Ground truth value(s).
%
%   C                   Candidate value(s).
%
% Outputs:
%
%   E                   Relative percent error between G and C.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-05
% Changelog:
%   2021-11-05
%       * Initial release



%% Parse arguments

% TRUE_ERROR(G, C)
narginchk(2, 2);

% TRUE_ERROR(G, C)
% E = TRUE_ERROR(G, C)
nargoutchk(0, 1);



%% Calculate

e = g - c;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
