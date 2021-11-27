function tf = aall(v)
%% AALL is a wrapper over recursive calls to all(all(all(....)))
%
% TF = AALL(V)
%
% Inputs:
%
%   V                   Any type of value that is also accepted by `all(V)```
%
%   DIM                 Dimension along with to check ALL.
%                       Default: []
%
% Outputs:
%
%   TF                  Boolean flag, whether really all(all(all(...))) is
%                       given or not.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%       * Remove parameter `DIM`
%   2016-12-03
%       * Initial release



%% Assert arguments
% AALL(V)
narginchk(1, 1);
% AALL(___)
% T = AALL(___)
nargoutchk(0, 1);



%% Algorithm

tf = all(v);

while ~isscalar(tf)
  tf = all(tf);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
