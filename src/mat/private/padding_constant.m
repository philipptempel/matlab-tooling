function b = padding_constant(a, padsz, padval, drctn)%#codegen
%% PADDING_CONSTANT



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-14
% Changelog:
%   2022-09-14
%     * Initial release



%% Parse arguments



%% Algorithm

ndim = numel(padsz);

% Form index vectors to subsasgn input array into output array.
% Also compute the size of the output array.
idx   = cell(1, ndim);
sizeB = zeros(1, ndim);

for k = 1:ndim
  
  M = size(a, k);
  
  switch drctn
    case 'pre'
      idx{k}   = (1:M) + padsz(k);
      sizeB(k) =    M  + padsz(k);
      
    case 'post'
      idx{k}   = 1:M;
      sizeB(k) =   M + padsz(k);
      
    case 'both'
      idx{k}   = (1:M) +     padsz(k);
      sizeB(k) =    M  + 2 * padsz(k);
      
  end
  
end

% Initialize output array with the padding value.  Make sure the
% output array is the same type as the input.
b         = mkconstarray(class(a), padval, sizeB);
b(idx{:}) = a;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
