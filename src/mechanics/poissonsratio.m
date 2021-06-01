function nu = poissonsratio(e, g)%#codegen
%% POISSONSRATIO Calculate Poisson's ratiom from elastic modulus and shear modulus
%
% NU = POISSONSRATIO(E, G) calculates Poisson's ratio NU from elastic modulus E
% and shear modulus G. Dimensions of E and NU must match or must be able to be
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
%   G                   Shear modulus.
%
% Outputs:
%
%   NU                  Poisson's ratio of appropriate dimension.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-02-24
% Changelog:
%   2021-02-24
%     * Initial release



%% Parse arguments

% POISSONSRATIO(E, G)
narginchk(2, 2);
% POISSONSRATIO(E, G)
% NU = POISSONSRATIO(E, G)
nargoutchk(0, 1);

validateattributes(e, {'numeric'}, {'2d', 'nonnan', 'finite', 'real'}, 'shearmodulus', 'ElasticModulus');
validateattributes(g, {'numeric'}, {'2d', 'nonnan', 'finite', 'real'}, 'shearmodulus', 'ShearModulus');



%% Calculate shear modulus

se = size(e);
sg = size(g);

% E and G have different dimensions
if ~isequal(se, sg)
  if isscalar(g) && ~isscalar(e)
    g = repmat(g, se);
    
  elseif isscalar(e) && ~isscalar(g)
    e = repmat(e, sg);
    
  end
  
end

se = size(e);

twos_ = repmat(2, se);
ones_ = ones(se);

nu = e ./ ( twos_ .* g ) - ones_;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
