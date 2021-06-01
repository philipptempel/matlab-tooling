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
% Date: 2020-11-24
% Changelog:
%   2020-11-24
%     * Updates to support code generation
%   2020-11-19
%     * Initial release



%% Parse arguments

% QUATNORMALIZED(Q);
narginchk(1, 1);
% QUATNORMALIZED(Q)
% QN = QUATNORMALIZED(Q);
nargoutchk(0, 1);

qv = quatvalid(q, 'quatnormalized');



%% Calculate norm

qn = qv ./ repmat(quatnorm(qv), [4, 1]);



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
