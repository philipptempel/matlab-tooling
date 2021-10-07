function ev = evecn(dim, cord)%#codegen
%% EVECN Create a unit vector of some dimenions.
%
% Inputs:
%
%   DIM                 Number of dimensions to create.
%
%   CORD                Index of coordinate that should be set to 1.
%
% Outputs:
%
%   EV                  DIMx1 vector with its CORD-th entry set to 1



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-11-13
% Changelog:
%   2020-11-13
%       * Add H1 and file information section
%   2016-05-16
%       * Initial release



%% Do your code magic here

% EVECN(DIM, CORD)
narginchk(2, 2);
% EVECN(DIM, CORD)
% EV = EVECN(DIM, CORD);
nargoutchk(0, 1);


validateattributes(dim, {'numeric'}, {'nonempty', 'scalar', 'positive', 'nonnan', 'nonsparse', 'finite'}, 'evecn', 'dim');
validateattributes(cord, {'numeric'}, {'nonempty', 'scalar', '<=', dim, 'positive', 'nonnan', 'nonsparse', 'finite'}, 'evecn', 'cord');



%% Create vector

% Make sure we do not create vectors larger than the specified dimension by
% providing a coordinate bigger than dimension
cord = min(cord, dim);

% Create an empty vector...
ev = zeros(dim, 1);
% ... and set the cord-th value to 1
ev(cord) = 1;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
