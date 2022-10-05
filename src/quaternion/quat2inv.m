function qi = quat2inv(q)%#codegen
%% QUAT2INV Calculate inverse quaternion
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

% QUAT2INV(Q);
narginchk(1, 1);
% QUAT2INV(P);
% QP = QUAT2INV(Q);
nargoutchk(0, 1);



%% Algorithm

% Invert and normalize
qi = quatconj(q) ./ ( repmat(quatnorm(q), 4, 1) .^ 2 );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
