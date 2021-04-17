function g = shearmodulus(e, nu)%#codegen
%% SHEARMODULUS Calculate shear modulus from elastic modulus and Poisson's ratio
%
% G = SHEARMODULUS(E, NU) calculates shear modulus G from elastic modulus E and
% Poisson's ration NU). Dimensions of E and NU must match or must be able to be
% propagated to either.
%
% Supported argument sizes are
%   * (NxM, 1x1)
%   * (1x1, NxM)
%   * (NxM, Nx1)
%   * (NxM, 1xM)
%   * (NxM, NxM)
%
% Inputs:
%
%   E                   Elastic modulus.
%
%   NU                  Poisson's ratio.
%
% Outputs:
%
%   G                   Shear modulus for elastic modulus and Poissons's ratio.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-02-24
% Changelog:
%   2021-02-24
%     * Fix H1 and inline documentation
%   2020-11-11
%     * Update documentation to support some sort of `publish` functionality
%   2020-11-10
%     * Initial release



%% Parse arguments

% SHEARMODULUES(E, NU);
narginchk(2, 2);
% SHEARMODULUES(E, NU);
% G = SHEARMODULUES(E, NU);
nargoutchk(0, 1);

validateattributes(e, {'numeric'}, {'2d', 'nonnan', 'finite', 'real'}, 'shearmodulus', 'e');
validateattributes(nu, {'numeric'}, {'2d', 'nonnan', 'finite', 'real'}, 'shearmodulus', 'nu');



%% Calculate shear modulus

se = size(e);
snu = size(nu);

% E and NU have different dimensions
if ~isequal(se, snu)
  if isscalar(nu) && ~isscalar(e)
    nu = repmat(nu, se);
    
  elseif isscalar(e) && ~isscalar(nu)
    e = repmat(e, snu);
    
  end
  
end

se = size(e);

twos_ = repmat(2, se);
ones_ = ones(se);

g = e ./ ( twos_ .* ( ones_ + nu ) );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
