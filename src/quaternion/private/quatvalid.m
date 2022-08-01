function [qv, nq] = quatvalid(q, caller)%#codegen
%% QUATVALID Validate a quaternion
%
% [QV, NQ] = QUATVALID(Q, CALLER) validates quaternion Q and returns
% validated/normalized form Q with column major.
%
% Inputs:
%
%   Q                   4xN array of quaternions.
%
%   CALLER              Name of function calling this private function.
%
% Outputs:
%
%   QV                  4xN array of validated i.e., normalized quaternions.
%
%   NQ                  Number of quaternions N.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-08-01
% Changelog:
%   2022-08-01
%     * Allow empty quaternions to be valid as well i.e., also allow 4x0 to be a
%     valid quaternion
%   2022-02-14
%     * Remove `FAST` argument
%   2022-02-09
%     * Remove call to `QUATNORMALIZED` as this messes with code using finite
%     differences on quaternion
%   2022-02-08
%     * Add input argument option `FAST` to avoid normalization
%     * Add output argument NQ
%     * Remove option to pass a row vector quaternion
%     * Add normalization of quaternion into function
%     * Update H1 documentation
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-11
%     * Initial release



%% Parse arguments

% QUATVALID(Q, CALLER)
narginchk(2, 2);

% QUATVALID(___)
% QV = QUATVALID(___)
% [QV, NQ] = QUATVALID(___)
nargoutchk(0, 2);



%% Algorithm

% Validate...
validateattributes(q, {'numeric'}, {'2d', 'nrows', 4}, caller, 'q');

% Push quaternions into output
qv = q;

% Counter of quaternions
nq = size(qv, 2);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
