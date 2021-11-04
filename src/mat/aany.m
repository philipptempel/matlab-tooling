function A = aany(V, dim)
% AANY is a wrapper over recursive calls to any(any(any(....)))
%
%   Inputs:
%
%   V                    Any type of value that is also accepted by `all(V)```
%
%   Outputs:
%
%   A                    Boolean flag, whether really all(all(all(...))) is
%       given or not.



%% File information
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2021-11-04
% Changelog:
%   2021-11-04
%       * Initial release



%% Assert arguments
% AANY(V) or AANY(V, DIM)
narginchk(1, 2);



%% Do your code magic here

% If no dimension is given, we will call ANY without dimension and let it decide
% what to do
if nargin < 2 || isempty(dim)
    A = any(V);
    
    while ~isscalar(A)
        A = any(A);
    end
% Called with dimension, so pass along to ANY
else
    A = any(V, dim);
    
    while ~isscalar(A)
        A = any(A, dim);
    end
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
