function varargout = matsplit(A, dim)
%% MATSPLIT 
%
% MATSPLIT(A)
%
% MATSPLIT(A, DIM)
%
% Inputs:
%
%   A                   Array of arbitrary dimension to split into rows,
%                       columns, or pages.
%
%   DIM                 Dimension to split along. If not given defaults to the
%                       first dimension of A that does not equal q.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-22
% Changelog:
%   2020-12-22
%       * Initial release



%% Parse arguments

narginchk(1, 2);

if nargin < 2 || isempty(dim)
  dim = find(size(A) > 1, 1, 'first');
end

nargoutchk(0, size(A, dim));


%% Process data

q = num2cell(A, dim);

[varargout{1:nargout}] = q{:};


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
