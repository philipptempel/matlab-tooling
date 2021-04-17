function v = rotm2rotv(r, tol)%#codegen
%% ROTM2ROTV 
%
% V = ROTM2ROTV(M) converts rotation matrix M into a axis-angle representation.
%
% V = ROTM2ROTV(M, TOL) uses tolerance TOL to check for singular values.
%
% Inputs:
%
%   R                   3x3 rotation matrix.
%
%   TOL                 Tolerance threshold used as upper limit for determining
%                       if a value is singular (close to zero) or not.
%
% Outputs:
%
%   V                   4x1 axis-angle where the angle is the first component
%                       and the axis is in V([2,3,4]).
%
% See also:
%   https://euclideanspace.com/maths/geometry/rotations/conversions/matrixToAngle



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-28
% Changelog:
%   2020-12-28
%       * Update H1 documentation
%   2020-12-23
%       * Rename to `rotm2rotvec` to stay consistent with other rotation
%       methods.
%   2020-12-11
%       * Initial release



%% Parse arguments

% ROTM2ROTV(M, TOL)
narginchk(1, 2);
% ROTM2ROTV(...)
% V = ROTM2ROTV(...)
nargoutchk(0, 1);

if nargin < 2 || isempty(tol)
  tol = 1e-12;
end



%% Make conversion

mtrc = trace(r);

% phi == 0
if abs(mtrc - 3) <= tol

  v = [0; 1; 0; 0]; 

% phi == pi
elseif abs(mtrc + 1) <= tol
  % This singularity requires elaborate sign ambiguity resolution
  
  % compute axis of rotation, make sure all elements are >= 0
  % real signs are obtained by the flipping algorithm below
  axis = sqrt(max((diag(r) + 1) ./ 2, [0; 0; 0]));
  % axis elements that are <= tol set to zero
  axis = axis .* (axis > tol);
  
  % Flipping
  % 
  % The algorithm uses the elements above diagonal to determine the signs 
  % of rotation axis coordinate in the singular case Phi = pi. 
  % All valid combinations of 0, positive and negative values lead to 
  % 3 different cases:
  % If (Sum(signs)) >= 0 ... leave all coordinates positive
  % If (Sum(signs)) == -1 and all values are non-zero 
  %   ... flip the coordinate that is missing in the term that has + sign, 
  %       e.g. if 2AyAz is positive, flip x
  % If (Sum(signs)) == -1 and 2 values are zero 
  %   ... flip the coord next to the one with non-zero value 
  %   ... ambiguous, we have chosen shift right
  
  % construct vector [M23 M13 M12] ~ [2AyAz 2AxAz 2AxAy]
  % (in the order to facilitate flipping):    ^
  %                                  [no_x  no_y  no_z ]
  
  m_upper = [ ...
    r(2,3) ; ...
    r(1,3) ; ...
    r(1,2) ; ...
  ];
  % elements with || smaller than tol are considered to be 0
  signs = sign(m_upper) .* ( abs(m_upper) > tol );
  
  % none of the signs is negative
  if sum(signs) >= 0
    
    % don't flip any axis element
    flip = [1; 1; 1];
    
  % none of the signs is zero, 2 negative 1 positive
  elseif isempty( find(signs == 0, 1) )
    
    % flip the coordinate that is missing in the term that has + sign
    flip = -signs;
    
  % 2 signs are 0, 1 negative
  else
     
     % flip the coord to the right of the one with non-zero value 
     % [-1 0 0]->[1 -1 1], [0 -1 0]->[1 1 -1], [0 0 -1]->[-1 1 1]
     shifted = [ ...
       signs(3) ; ...
       signs(1) ; ...
       signs(2) ; ...
     ];
     flip = shifted + (shifted == 0);
 
  end
  
  % flip the axis
  axis = axis .* flip;
  v = [ ...
    pi ; ...
    axis ; ...
  ];
 
% General case
else
  phi = acos( ( mtrc - 1 ) / 2 );
  den = 2 * sin(phi);
  axis = [ ...
    r(3,2) - r(2,3) ; ...
    r(1,3) - r(3,1) ; ...
    r(2,1) - r(1,2) ; ...
  ] ./ repmat(den, [3, 1]); 
  
  v = [ ...
    phi ; ...
    axis ; ...
  ];  
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
