function qa = quatconj(q)%#codegen
%% QUATCONJ Calculate adjoint quaternion
%
% Inputs:
%
%   Q                   Description of argument Q
%
% Outputs:
%
%   QA                  Description of argument QA



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-05
% Changelog:
%   2021-11-05
%     * Rename to `quatconj`
%   2020-11-24
%     * Updates to support code generation
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-10
%     * Initial release



%% Parse arguments

% QUATCONJ(Q);
narginchk(1, 1);
% QUATCONJ(P);
% QP = QUATCONJ(Q);
nargoutchk(0, 1);

qv = quatvalid(q, 'quatconj');



%% Do your code magic here
qa = [ ...
    qv(1,:) ...
  ; -qv([2,3,4],:) ...
];


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
