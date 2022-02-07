function varargout = unbundle(b, varargin)%#codegen
%% UNBUNDLE Unbundle a bundled vector into separate entities
%
% [A1, A2, ...] = UNBUNDLE(B, DIMA1, DIMA2, ...) unbundles bundle vector B into
% arrays A1, A2, etc of given dimensions DIMA1, DIMA2, etc.
%
% Inputs:
%
%   B                   Nx1 bundle vector of data
%
%   DIMAn               Dimension(s) of the first array to extract from B. DIMAn
%                       can be a scalar R to extract a column vector of R rows,
%                       an S-dimensional array of dimensions to reshape the
%                       vector into, or -1 to extract everything until the end
%
% See also:
%   BUNDLE



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-07
% Changelog:
%   2022-02-07
%       * Fix bug in reshaping an 0xN or Nx0 (empty double) matrix
%   2022-02-01
%       * Add support to extract data even if the bundle vector B is too small.
%       These arrays will then be of size (0,1) i.e., a 0x1 empty double column
%       vector
%   2021-12-17
%       * Add support for negative values in `DIMAn` argument so that the user
%       can also split a bundle into arrays of fixed length and variable length
%   2021-11-18
%       * Rename from `UNPACK` to `UNBUNDLE`
%   2021-11-09
%       * Initial release



%% Parse arguments

% UNBUNDLE(B, DIM1, ...)
narginchk(2, Inf);

% Get list of dimenions
dims = varargin;
% Count dimensions
ndims = numel(dims);

% [A, ...] = UNBUNDLE(B, DIMA, ...)
nargoutchk(0, ndims);



%% Process

% Create output
varargout = cell(1, ndims);

% Offset for linear indexing
idxoff = 0;

% Initialize loop variables
done = false;
idim = 1;

% Loop over all to-extract elements
while ~done
  % Dimensions to get
  vdim = dims{idim};
  % Number of elements
  vnum = prod(vdim);
  
  % Extract everything till the end
  if vnum < 0
    v = b((idxoff + 1):end);
    
  % Extract only a subset of data
  else
    % If the bundle vector is still large enough
    if idxoff + vnum <= numel(b) 
      % Extract the data
      v = b(idxoff + (1:vnum));
      
    % Bundle vector is not large enough anymore
    else
      % "Extract" an empty array
      v = zeros(vnum, 0);
      
    end
    
  end
  
  % Reshape into matrix if data exists
  if numel(vdim) > 1 && ~isempty(v)
    v = reshape(v, vdim);
  end
  
  % And assign output
  varargout{idim} = v;
  
  % Udpate index offset
  idxoff = idxoff + vnum;
  
  % Increase loop counter
  idim = idim + 1;
  
  % And evaluate if we are done or not
  done = idim > ndims || vnum < 0;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
