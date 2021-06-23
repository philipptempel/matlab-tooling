function vn = limitnorm(v, n)
%% LIMITNORM Limit vector norm to a given value
%
% Inputs:
%
%   V                   Description of argument V
%
%   N                   Description of argument N
%
% Outputs:
%
%   VN                  Description of argument VN



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-04-17
% Changelog:
%   2021-04-17
%       * Initial release



%% Do your code magic here

if norm(v) > 0
  vn = v ./ norm(v) .* limit(norm(v), 0, n);
else
  vn = v;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
