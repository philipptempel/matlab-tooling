function [b, a] = swap(a, b)%#codegen
%% SWAP Flip two variables
%
% [B, A] = SWAP(A, B) swaps variables A and B.
%
% Inputs:
%
%   A                       One variable.
% 
%   B                       Other variable.
%
% Outputs:
%
%   B                       One variable.
% 
%   A                       Other variable.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-04-25
% Changelog:
%   2022-04-25
%       * Initial release



%% Parse arguments

% [A, B] = SWAP(___)
narginchk(2, 2);

% [B, A] = SWAP(___)
nargoutchk(2, 2);



%% Algorithm

% Swap variables using a temporary variable
tmp = a;
a   = b;
b   = tmp;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
