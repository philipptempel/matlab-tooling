function varargout = unbundle(b, varargin)%#codegen
%% UNBUNDLE Unbundle a bundled vector into separate entities
%
% [A, B, ...] = UNBUNDLE(B, DIMA, DIMB, ...) unbundles bundle vector B into
% arrays A, B, etc of given dimensions DIMA, DIMB, etc.
%
% Inputs:
%
%   B                   Nx1 bundle vector of data
%
%   DIMA                Dimension(s) of the first array to extract from B. DIMA
%                       can be a scalar R to extract a column vector of R rows
%                       or a S-dimensional array of dimensions to reshape the
%                       vector into.
%
% See also:
%   BUNDLE



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-18
% Changelog:
%   2021-11-18
%       * Rename from `UNPACK` to `UNBUNDLE`
%   2021-11-09
%       * Initial release



%% Parse arguments

% UNBUNDLE(B, DIM1, ...)
narginchk(2, Inf);

% [A, ...] = UNBUNDLE(B, DIMA, ...)
nargoutchk(0, nargin - 1);



%% Process

% Get list of dimenions
dims = varargin;
ndims = nargin - 1;

% Create output
varargout = cell(1, ndims);

% Offset for linear indexing
idxoff = 0;

% Loop over each pack dimension to get
for idim = 1:ndims
  % Dimensions to get
  vdim = dims{idim};
  % Number of elements
  vnum = prod(vdim);
  
  % Extract
  v = b(idxoff + (1:vnum));
  
  % Reshape into matrix
  if numel(vdim) > 1
    v = reshape(v, vdim);
  end
  
  % And assign output
  varargout{idim} = v;
  
  % Udpate index offset
  idxoff = idxoff + vnum;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
