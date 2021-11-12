function [Q, Qc] = quatmat(q)%#codegen
%% QUATMAT Calculate quaternion matrix and conjugate quaternion matrix
%
% Inputs:
%
%   Q                   4xN quaternion(s) with scalar element in first row.
%
% Outputs:
%
%   Q                   4x4xN quaternion matrix 
%
%   QC                  4x4xN conjugate quaternion matrix



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-12
% Changelog:
%   2021-11-12
%     * Correct signs in quaternion matrix and conjugate quaternion matrix
%   2021-10-21
%     * Revert previous "fix"
%   2021-10-07
%     * Fix sign of skew-symmetric part in quaternion matrix and its conjugate
%     quaternion matrix counterpart
%   2020-11-24
%     * Updates to support code generation
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-10
%     * Initial release



%% Parse arguments

% QUATMAT(Q);
narginchk(1, 1);
% QUATMAT(Q)
% QM = QUATMAT(Q);
% [QM, QCM] = QUATMAT(Q);
nargoutchk(0, 2);

qv = quatvalid(q, 'quatmat');



%% Calculate matrices

qskm = vec2skew(qv([2,3,4],:));

% Shift number of quaternions into third dimensions
qv = permute(qv, [1, 3, 2]);
% Number of quaternions
nq = size(qv, 3);

% Split scalar and vector part from quaternions
qsca = qv(1,:,:);
qvec = qv([2,3,4],:,:);

% Unit matrix with nq pages
eyenq = repmat(eye(3, 3), [1, 1, nq]);

% Quaternion matrix
Q = cat( ...
    1 ...
  , cat( ...
      2 ...
    , qsca ...
    , permute(-qvec, [2, 1, 3]) ...
  ) ...
  , cat( ...
      2 ...
    , +qvec ...
    , qsca .* eyenq + qskm ...
  ) ...
);

% Conjugate quaternion matrix, conditionally
if nargout > 1
  Qc = cat( ...
      1 ...
    , cat( ...
        2 ...
      , qsca ...
      , permute(+qvec, [2, 1, 3]) ...
    ) ...
    , cat( ...
        2 ...
      , -qvec ...
      , qsca .* eyenq - qskm ...
    ) ...
  );
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
