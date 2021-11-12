function qdp = quatdiv(q, p)%#codegen
%% QUATDIV Divide two quaternions
%
% QDP = QUATDIV(Q, P) divides quaternion Q by quaternion P i.e., QDP = Q * P^-1.
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
%   QP              4xN array of division of quaternions.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-12
% Changelog:
%   2021-11-12
%     * Fix code
%   2020-11-25
%     * Remove `MException` and incerase code generation compatability
%   2020-11-24
%     * Updates to support code generation
%   2020-11-11
%     * Initial release



%% Parse arguments

% QUATDIV(Q, P);
narginchk(2, 2);
% QUATDIV(Q, P);
% QP = QUATDIV(Q, P);
nargoutchk(0, 1);

qv = quatvalid(q, 'quatdiv');
pv = quatvalid(p, 'quatdiv');

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



%% Calculate quaternion division

% Obtain scalar and vector part from both quaternions
qvec = qvn([2,3,4],:);
qsca = qvn(1,:);
pvec = pvn([2,3,4],:);
psca = pvn(1,:);

% And compute quaternion product
qdp = [ ...
    qsca .* psca + dot(qvec, pvec, 1) ...
  ; repmat(-qsca, [3, 1]) .* pvec + repmat(+psca, [3, 1]) .* qvec - cross(qvec, pvec, 1) ...
];


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
