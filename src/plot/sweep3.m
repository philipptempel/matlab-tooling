function varargout = sweep3(vrts, crv, drn, varargin)
%% SWEEP3
%
% SWEEP3(CRV) sweeps the geometry object cross-section along a given path.
%
% SWEEP3(CRV, DRN) sweeps the geometry object's cross-section along a
% given curve and uses the provided directors for local rotation.
%
% XYZ = SWEEP3(...) returns the swept curve.
%
% [X, Y, Z] = SWEEP3(...) returns separate arrays for X, Y, and Z
% coordinates of the swept curve.
%
% Inputs:
%
%   CRV           3xN curve along which to sweep.
%
%   DRN           3x3xN array of directors used for glocal rotation of the
%                 primtive's cross-section.
%
% Outputs:
%   
%   XYZ           NxNx3 array of XYZ coordinates of the swept curve.
%
%   X             NxNx1 array of X-coordinates of swept curve.
%
%   Y             NxNx1 array of Y-coordinates of swept curve.
%
%   Z             NxNx1 array of Z-coordinates of swept curve.


if size(vrts, 2) < 3
  vrts = [ vrts , zeros(size(vrts, 1), 1) ];
end
vrts = permute(vrts, [2, 1]);

% Count number of shape points
nshapes = size(vrts, 2);

% Multi-dimensional math over pages ftw
xyz = permute(repmat(permute(crv, [1, 3, 2]), [1, nshapes, 1]) + pagemult(drn, vrts), [2, 3, 1]);

% SWEEP3(OBJ, ___)
% XYZ = SWEEP3(OBJ, ___)
if nargout < 2
  varargout{1} = xyz;

% [X, Y, Z] = SWEEP3(OBJ, ___)
else
  varargout{1} = xyz(:,:,1);
  varargout{2} = xyz(:,:,2);
  varargout{3} = xyz(:,:,3);

end

end
