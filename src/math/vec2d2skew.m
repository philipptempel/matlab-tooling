function skw = vec2d2skew(vec)%#codegen
% VEC2D2SKEW Turn the input into its skew-symmetrix matrix form
% 
% SKEW = VEC2D2SKEW(VEC) turns vec into its skew-symmetric matrix form of type
% [-vec(2), vec(1)]. If VEC is a 2xN matrix, then SKEW is a 2xN matrix of
% skew-symmetrix matrices for each row of VEC concatenated along the third
% dimension
%   
%   
% Inputs:
%   
%   VEC               2xN matrix of vectors to turn into planar skew-symmetrix
%                     matrices.
%
% Outputs:
%   
%   SKEW              Nx2 matrix of skew-symmetrix matrices where each page
%                     corresponds to a single input vector.
%



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-28
% Changelog:
%   2020-12-28
%       * Clean up code and fix H1 and inline documentation
%   2020-12-18
%       * Initial release



%% Input parsing

% VEC2D2SKEW(V)
narginchk(1, 1);
% VEC2D2SKEW(V)
% SKEW = VEC2D2SKEW(V)
nargoutchk(0, 1);

validateattributes(vec, {'numeric'}, {'nonempty', 'nrows', 2}, 'vec2d2skew', 'vec');



%% Process inputs



%% Nagic (copied from quat2rotm)

% Explicitly define concatenation dimension for codegen
tempS = cat(1 ...
  , -vec(2,:), vec(1,:) ...
);
% Get into right orientation due to MATLAB's row-major and change dimensions to
% Nx2
skw = permute(tempS, [2, 1]);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original
% author as can be found in the header
% Your contribution towards improving this function will be acknowledged in
% the "Changes" section of the header
