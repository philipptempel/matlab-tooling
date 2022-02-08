function qsp = quatsub(q, p)%#codegen
%% QUATSUB Subtract two quaternions
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
%   QP              4xN array of difference of quaternions.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Use new syntax of `quatvalid` also returning number of quaternions N
%   2020-11-25
%     * Initial release



%% Parse arguments

% QUATSUB(Q, P);
narginchk(2, 2);
% QUATSUB(Q, P);
% QSP = QUATSUB(Q, P);
nargoutchk(0, 1);

% Parse quaternions
[qv, nq] = quatvalid(q, 'quatsub');
[pv, np] = quatvalid(p, 'quatsub');



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

% Difference in quaternions
qsp = qvn - pvn;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
