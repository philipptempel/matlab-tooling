function qmp = quatmul(q, p)%#codegen
%% QUATMUL Multiply two quaternions
%
% QMP = QUATMUL(Q, P) multiplies quaternion Q with P = QMP = Q * P.
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
%   QP              4xN array of product of quaternions.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Use new syntax of `quatvalid` also returning number of quaternions N
%   2021-11-12
%     * Fix code
%     * Update H1 documentation
%     * Remove `MException` and incerase code generation compatability
%   2020-11-24
%     * Updates to support code generation
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-10
%     * Add support for either `q` and `p` or both being matrices of appropriate
%     dimensions
%     * Make sure that scalar entry appears first
%   2020-11-09
%     * Initial release



%% Parse arguments

% QUATMUL(Q, P);
narginchk(2, 2);

% QUATMUL(Q, P);
% QP = QUATMUL(Q, P);
nargoutchk(0, 1);



%% Algorithm

nq = size(q, 2);
np = size(p, 2);

% If either q or p are matrices, make the other one of the same size
if nq == 1 && np  > 1
  qvn = repmat(q, [1, np]);
  pvn = p;
  
elseif np == 1 && nq > 1
  qvn = q;
  pvn = repmat(p, [1, nq]);
  
else
  qvn = q;
  pvn = p;
  
end

% Obtain scalar and vector part from both quaternions
qvec = qvn([2,3,4],:);
qsca = qvn(1,:);
pvec = pvn([2,3,4],:);
psca = pvn(1,:);

% And compute quaternion product
qmp = [ ...
    qsca .* psca - dot(qvec, pvec, 1) ...
  ; repmat(+qsca, [3, 1]) .* pvec + repmat(+psca, [3, 1]) .* qvec + cross(qvec, pvec, 1) ...
];


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
