function qn = quatnormalized(q)%#codegen
%% QUATNORMALIZED Normalizes quaternion(s)
%
% QN = QUATNORMALIZED(Q) normalize quaternion to have vector norm equal to 1.
%
% Inputs:
%
%   Q                   4xN array of quaternions.
%
% Outputs:
%
%   QN                  4xN array of normalized quaternions.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-05
% Changelog:
%   2022-10-05
%     * Initial release



%% Parse arguments

% QUATNORMALIZED(Q)
narginchk(1, 1);

% QUATNORMALIZED(Q)
% QN = QUATNORMALIZED(Q)
nargoutchk(0, 1);



%% Algorithm

% Normalize quaternions i.e., columns
qn = mnormcol(q);
% Per convention, always keep scalar quaternion elements positive
qn(:,qn(1,:) < 0) = -qn(:,qn(1,:) < 0);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
