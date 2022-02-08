function qn = quatnorm(q)%#codegen
%% QUATNORM Calculate norm of quaternion(s)
%
% Inputs:
%
%   Q                   4xN array of quaternions.
%
% Outputs:
%
%   QN                  1xN array of quaternion norms.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Code syntax updates
%   2020-11-24
%     * Updates to support code generation
%   2020-11-19
%     * Change to only calculate the quaternion norm and move normalization to
%     `quatnormalized`
%   2020-11-11
%     * Initial release



%% Parse arguments

% QUATNORM(Q);
narginchk(1, 1);

% QUATNORM(Q)
% QN = QUATNORM(Q);
nargoutchk(0, 1);

% Parse quaternions
qv = quatvalid(q, 'quatnorm');



%% Algorithm

qn = sqrt(sum(qv .^ 2, 1));



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
