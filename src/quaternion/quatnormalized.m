function qn = quatnormalized(q)%#codegen
%% QUATNORMALIZED Normalizes quaternion(s)
%
% Inputs:
%
%   Q                   4xN array of quaternions.
%
% Outputs:
%
%   QN                  4xN array of normalized quaternions



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-16
% Changelog:
%   2022-02-16
%     * Fix wrong call of `QUATVALID`
%   2022-02-08
%     * Split dependency on `QUATNORM` to avoid too depp recursion
%     * Code syntax updates
%   2020-11-24
%     * Updates to support code generation
%   2020-11-19
%     * Initial release



%% Parse arguments

% QUATNORMALIZED(Q)
narginchk(1, 1);

% QUATNORMALIZED(Q)
% QN = QUATNORMALIZED(Q)
nargoutchk(0, 1);

% Parse quaternions
qv = quatvalid(q, 'quatnormalized');



%% Algorithm

% Normalize quaternions
qn = qv ./ repmat(sqrt(sum(qv .^ 2, 1)), [4, 1]);
% Per convention, always keep scalar quaternion elements positive
qn(:,q(1,:) < 0) = -qn(:,qn(1,:) < 0);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
