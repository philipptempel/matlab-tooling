function idx = padding_replicate(aSize, padSize, direction)%#codegen
%% PADDING_REPLICATE



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
idx   = cell(1,ndim);

for k = 1:ndim
  M = aSize(k);
  p = padSize(k);
  onesVector = uint32(ones(1,p));
  
  switch direction
    case 'pre'
      idx{k}   = [ onesVector , 1:M ];
      
    case 'post'
      idx{k}   = [ 1:M , M * onesVector ];
      
    case 'both'
      idx{k}   = [ onesVector , 1:M , M * onesVector ];
      
  end
  
end

end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
