function qv = quatvalid(q, fname)%#codegen
%% QUATVALID Validate a quaternion
%
% QV = QUATVALID(Q) validates quaternion Q and returns validated/normalized form
% Q with column major.
%
% Inputs:
%
%   Q                   Arbitrary quaternion as either 1x4 vector, 4x1 vector,
%                       or 4xN matrix.
%
% Outputs:
%
%   QV                  Validated/normalized quaternion with column major.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-11
% Changelog:
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-11
%     * Initial release



%% Validate and normalize quaternion

narginchk(2, 2);
nargoutchk(0, 1);

if isrow(q)
  qv = q(:);
else
  qv = q;
end

validateattributes(qv, {'numeric'}, {'nonempty', '2d', 'nrows', 4}, fname, 'q');


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
