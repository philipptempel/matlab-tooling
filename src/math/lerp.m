function l = lerp(a, b, t)
%% LERP Linearly interpolate between two values
%
% LERP(A, B, T) linearly interpolates between A and B at T.
%
% Inputs:
%
%   A                   NxK matrix of values to use as start point of
%                       interpolation.
%
%   B                   NxK matrix of values to use as end point of
%                       interpolation.
%
%   T                   1xS vector of values at which to evaluate interpolation.
%
% Outputs:
%
%   L                   NxKxS array of interpolated values



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-01-24
% Changelog:
%   2021-01-24
%       * Initial release



%% Interpolate


% Check if `A` is a singleton i.e., scalar or vector
asingleton = isvector(a);

% Reshape T such that it adds pages to the size of A
if asingleton
  tn = reshape(t, [], numel(t));
else
  tn = reshape(t, [ones(1, ndims(a)), numel(t)]);
end

% Linearly interpolate
l = (1 - tn) .* a + tn .* b;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
