function tf = aany(v)
%% AANY is a wrapper over recursive calls to any(any(any(....)))
%
% TF = AANY(V)
%
% Inputs:
%
%   V                   Any type of value that is also accepted by `all(V)```
%
% Outputs:
%
%   A                   Boolean flag, whether really all(all(all(...))) is given
%                       or not.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2021-12-14
% Changelog:
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-17
%       * Update H1 to correct format
%       * Remove parameter `DIM`
%   2021-11-04
%       * Initial release



%% Assert arguments
% AANY(V)
narginchk(1, 1);

% AANY(___)
% TF = AANY(___)
nargoutchk(0, 1);



%% Algorithm

tf = any(v);

while ~isscalar(tf)
  tf = any(tf);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
