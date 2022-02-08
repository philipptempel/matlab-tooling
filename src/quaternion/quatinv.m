function qi = quatinv(q)%#codegen
%% QUATINV Calculate inverse quaternion
%
% Inputs:
%
%   Q                   Description of argument Q
%
% Outputs:
%
%   QA                  Description of argument QA



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-08
% Changelog:
%   2022-02-08
%     * Code syntax updates
%   2021-11-10
%     * Initial release



%% Parse arguments

% QUATINV(Q);
narginchk(1, 1);
% QUATINV(P);
% QP = QUATINV(Q);
nargoutchk(0, 1);

% Parse quaternions
qv = quatvalid(q, 'quatinv');



%% Algorithm

% Quaternion norm
qn = repmat(quatnorm(qv), 4, 1);

qi = quatconj(qv) ./ ( qn .^ 2 );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
