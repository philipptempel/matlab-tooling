function inda = padding_indices(asz, padsz, mthd, drctn)%#codegen
%% PADDING_INDICES



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-14
% Changelog:
%   2022-09-14
%     * Initial release



%% Parse arguments



%% Algorithm


% make sure we have enough image dims for the requested padding
if numel(padsz) > numel(asz)
  singleton_dims = numel(padsz) - numel(asz);
  asz = [ asz , ones(1, singleton_dims) ];
end


switch mthd
  case 'circular'
    inda = padding_circular(asz, padsz, drctn);
    
  case 'symmetric'
    inda = padding_symmetric(asz, padsz, drctn);
    
  case 'replicate' 
    inda = padding_replicate(asz, padsz, drctn);
    
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
