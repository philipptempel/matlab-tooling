function setrng()
% SETRNG sets the random number generator to a set or pre-defined options
%
% This function sets the random number generator rng to shuffle and chooses
% `simdTwister` as generator type. Additionally, the generator is being seeded
% with `sum(100*clock)`



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-03-14
% Changelog:
%   2022-03-14
%       * Code formatting
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2016-12-03
%       * Initial release



%% Do your code magic here

rng('shuffle')
rng(sum(100 * clock()), 'simdTwister');


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
