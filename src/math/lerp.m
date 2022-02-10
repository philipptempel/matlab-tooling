function l = lerp(a, b, t)%#codegen
%% LERP Linear interpolation between two values
%
% LERP(A, B, T) interpolates linearly between A and B at T where T is a scaling
% factor. The function assumes that X(0) = A and X(1) = B; T may be any value
% between -oo and +oo.
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
%   L                   NxKxS array of interpolated values.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-10
% Changelog:
%   2022-02-10
%       * Fix incorrect use of limiting values to boundaries by possibly
%       assigning the boundaries to an empty array. Now, the code first limits
%       `T` to be within the boundaries of the interval [0, 1], and then
%       performs all calculation
%   2022-01-21
%       * Enforce extrapolation of values is bound by values of A and B for T <
%       0 and T > 1, respectively
%       * Add `NARGINCHK` and `NARGOUTCHK`
%   2021-01-24
%       * Initial release



%% Parse arguments

% LERP(A, B, T)
narginchk(3, 3);

% LERP(___)
% L = LERP(___)
nargoutchk(0, 1);



%% Algorithm

% Check if `A` is a singleton i.e., scalar or vector
asingleton = isvector(a);

% Limit T to lie within [0, 1];
t = limit(t, 0.00, 1.00);

% Reshape T such that it adds pages to the size of A
if asingleton
  tn = reshape(t, [], numel(t));
else
  tn = reshape(t, [ones(1, ndims(a)), numel(t)]);
end

% Interpolate linearly
l = (1 - tn) .* a + tn .* b;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
