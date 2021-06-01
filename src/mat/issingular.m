function tf = issingular(a, tol)
%% ISSINGULAR Determine singularity of a value
%
% TF = ISSINGULAR(A) check value(s) A for singularity i.e., being close to zero
% but not exactly zero.
%
% TF = ISSINGULAR(A, TOL) uses tolerance TOL instead of the default value
% depending on the class of A.
%
% Inputs:
%
%   A                   Any arbitrarily dimensioned array.
%
%   TOL                 Scalar value to consider as maximum bound on
%                       singularity. Anything smaller TOL is assumed to be zero.
%                       Defaults to `10 * eps(class(A))`.
%
% Outputs:
%
%   TF                  Array of logical true/false indices of singularity of
%                       same dimension as A.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-11
% Changelog:
%   2020-12-11
%       * Add H1 documentation
%   2020-11-28
%       * Initial release



%% Parse arguments

% ISSINGULAR(A)
% ISSINGULAR(A, TOL)
narginchk(1, 2);
% ISSINGULAR(...)
% TF = ISSINGULAR(...)
nargoutchk(0, 1);

% Default tolerance
if nargin < 2 ||isempty(tol)
  tol = 10 * eps(class(a));
end



%% Determine singularity

tf = ( abs(a) < tol ) & ( a ~= 0 );


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
