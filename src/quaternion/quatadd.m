function qap = quatadd(q, p)%#codegen
%% QUATADD Add two quaternions
%
% Inputs:
%
%   Q               4x1 or 4xN vector of quaternion with scalar entry in first
%                   field i.e., in Q(1,:).
%
%   P               4x1 or 4xN vector of quaternion with scalar entry in first
%                   field i.e., in Q(1,:).
%
% Outputs:
%
%   QP              4xN array of sum of quaternions.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-25
% Changelog:
%   2020-11-25
%     * Update H1 documentation
%   2020-11-24
%     * Updates to support code generation
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-10
%     * Initial release



%% Parse arguments

% QUATADD(Q, P);
narginchk(2, 2);
% QUATADD(Q, P);
% QAP = QUATADD(Q, P);
nargoutchk(0, 1);

qv = quatvalid(q, 'quatadd');
pv = quatvalid(p, 'quatadd');

% Ensure qv and pv have same column count or either of them is a vector
mq = size(qv, 2);
mp = size(pv, 2);

% If either q or p are matrices, make the other one of the same size
if mq == 1 && mp  > 1
  qvn = repmat(qv, [1, mp]);
  pvn = pv;
elseif mp == 1 && mq > 1
  qvn = qv;
  pvn = repmat(pv, [1, mq]);
else
  qvn = qv;
  pvn = pv;
end



%% Calculate quaternion sum

qap = qvn + pvn;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
