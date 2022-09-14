function idx = padding_symmetric(aSize, padSize, direction)%#codegen
%% PADDING_SYMMETRIC



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-14
% Changelog:
%   2022-09-14
%     * Initial release



%% Parse arguments



%% Algorithm

ndim = numel(padSize);

% Form index vectors to subsasgn input array into output array.
% Also compute the size of the output array.
idx   = cell(1, ndim);

for k = 1:ndim
  M = aSize(k);
  dimNums = uint32([1:M M:-1:1]);
  p = padSize(k);
  
  switch direction
    case 'pre'
      idx{k}   = dimNums(mod(-p:M-1, 2*M) + 1);
      
    case 'post'
      idx{k}   = dimNums(mod(0:M+p-1, 2*M) + 1);
      
    case 'both'
      idx{k}   = dimNums(mod(-p:M+p-1, 2*M) + 1);
      
  end
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
