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
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Use new syntax of `quatvalid` also returning number of quaternions N
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

% Parse quaternions
[qv, nq] = quatvalid(q, 'quatdiv');
[pv, np] = quatvalid(p, 'quatdiv');



%% Algorithm

% If either q or p are matrices, make the other one of the same size
if nq == 1 && np  > 1
  qvn = repmat(qv, [1, np]);
  pvn = pv;
  
elseif np == 1 && nq > 1
  qvn = qv;
  pvn = repmat(pv, [1, nq]);
  
else
  qvn = qv;
  pvn = pv;
  
end

% Obtain scalar and vector part from both quaternions
qvec = qvn([2,3,4],:);
qsca = qvn(1,:);
pvec = pvn([2,3,4],:);
psca = pvn(1,:);

% And compute quaternion division
qdp = [ ...
    qsca .* psca + dot(qvec, pvec, 1) ...
  ; repmat(-qsca, [3, 1]) .* pvec + repmat(+psca, [3, 1]) .* qvec - cross(qvec, pvec, 1) ...
];


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
