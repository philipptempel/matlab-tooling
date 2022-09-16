function b = padarray(a, padsz, padval, direction, method)%#codegen
%% PADARRAY Pad array with values
%
% B = PADARRAY(A, PADSIZE) pads array A with PADSIZE(K) number of zeros along
% the K-th dimension. PADSIZE should be a vector of nonnegative integers.
%
% B = PADARRAY(A, PADSIZE, PADVAL) pads array A with PADVAL. If A is numeric or
% logical, PADVAL should be a scalar.
%
% B = PADARRAY(A, PADSIZE, PADVAL, DIRECTION) pads A in the direction specified
% by DIRECTION. DIRECTION can be one of the following:
% String or character vector values for DIRECTION:
%   'pre'     Pads before the first array element along each dimension.
%   'post'    Pads after the last array element along each dimension.
%   'both'    Pads before the first array element and after the last array
%           element along each dimension.
% By default, DIRECTION is 'both'.
%
% Inputs:
%
%   A             Description of argument A
% 
%   PSZ           Description of argument PSZ
%
% Outputs:
%
%   B             Description of argument B



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-14
% Changelog:
%   2022-09-14
%     * Initial release



%% Parse arguments

% PADARRAY(A, PADSIZE)
% PADARRAY(A, PADSIZE, PADVAL)
% PADARRAY(A, PADSIZE, PADVAL, DIRECTION)
% PADARRAY(A, PADSIZE, PADVAL, DIRECTION, METHOD)
narginchk(2, 5);

% PADARRAY(___)
% B = PADARRAY(___)
nargoutchk(0, 1);

% PADARRAY(A, PADSIZE)
if nargin < 3 || isempty(padval)
  padval = 0;
end

% PADARRAY(A, PADSIZE, PADVAL)
if nargin < 4 || isempty(direction)
  direction = 'both';
end

% PADARRAY(A, PADSIZE, PADVAL, DIRECTION)
if nargin < 5 || isempty(method)
  method = 'constant';
  
end



%% Algorithm

dima = ndims(a);

% Preprocess the padding size
if numel(padsz) < dima
    padsz       = padsz(:);
    padsz(dima) = 0;
end

if isempty(a)
  ndim = numel(padsz);
  sizeB = zeros(1, ndim);
  
  for k = 1:ndim
    % treat empty matrix similar for any method
    if strcmp(direction, 'both')
      sizeB(k) = size(a, k) + 2 * padsz(k);
    else
      sizeB(k) = size(a, k) + padsz(k);
    end
  end
  
  b = mkconstarray(class(a), padval, sizeB);
  
elseif strcmpi(method, 'constant')
  % constant value padding with padVal
  b = padding_constant(a, padsz, padval, direction);
  
else
  % compute indices then index into input
  aIdx  = padding_indices(size(a), padsz, method, direction);
  b     = a(aIdx{:});
  
end

if islogical(a)
  b = logical(b);
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
