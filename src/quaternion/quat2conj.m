function qa = quat2conj(q)%#codegen
%% QUAT2CONJ Calculate adjoint quaternion
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
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Code syntax updates
%   2021-11-05
%     * Rename to `quat2conj`
%   2020-11-24
%     * Updates to support code generation
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-10
%     * Initial release



%% Parse arguments

% QUAT2CONJ(Q);
narginchk(1, 1);

% QUAT2CONJ(Q);
% QP = QUAT2CONJ(Q);
nargoutchk(0, 1);



%% Algorithm

qa = cat(1, q(1,:), -q(2:4,:));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
