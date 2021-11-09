function varargout = unpack(p, varargin)
%% UNPACK 
%
% Inputs:
%
%   P                   Description of argument P



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-09
% Changelog:
%   2021-11-09
%       * Initial release



%% Parse arguments

% UNPACK(P, DIM1, ...)
narginchk(2, Inf);

% [A, ...] = UNPACK(P, DIMA, ...)
nargoutchk(0, nargin - 1);



%% Process

% Get list of dimenions
dims = varargin;

% Count number of dimensions to obatin
ndims = numel(dims);

% Create output
varargout = cell(1, ndims);

% Offset for linear indexing
idxoff = 0;

% Loop over each pack dimension to get
for idim = 1:ndims
  % Dimensions to get
  bdim = dims{idim};
  % Number of elements
  bnum = prod(bdim);
  
  % Extract
  b = p(idxoff + (1:bnum));
  
  % Reshape into matrix
  if numel(bdim) > 1
    b = reshape(b, bdim);
  end
  
  % And assign output
  varargout{idim} = b;
  
  % Udpate index offset
  idxoff = idxoff + bnum;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
