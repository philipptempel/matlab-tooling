function g = quat2tpar(q)%#codegen
%% QUAT2TPAR
%
% G = QUAT2TPAR(Q)
%
% Inputs:
%
%   Q                       4xN array of quaternions.
%
% Outputs:
%
%   G                       7xN array of homogeneous transformations parameters.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-05
% Changelog:
%   2022-10-05
%     * Rename to `QUAT2TPAR` to not collide with the Robotics Toolbox'
%       internal implementations of homogeneous transformation matrices
%   2022-03-11
%     * Initial release



%% Parse arguments

% QUAT2TPAR(Q)
narginchk(1, 1);

% QUAT2TPAR(___)
% G = QUAT2TPAR(___)
nargoutchk(0, 1);



%% Algorithm

% Ensure Q is a column vector
q = reshape(q, 4, []);

% Dispatch
g = tpar(quatnormalized(q), zeros(3, size(q, 2)));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
