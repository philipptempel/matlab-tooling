function [fr, er, fi, ei] = unpacknum(x, base, n)
%% UNPACKNUM Unpack number into fraction and exponent.
%
% [F, E] = UNPACKNUM(X, BASE) unpacks the real number X so that X = F * BASE^E,
% where 1 <= |F| < BASE and E is an integer.  BASE must be larger than one.
%
% [FR, ER, FI, EI] = UNPACKNUM(X, BASE) unpacks the complex number X so that X =
% FR * BASE^ER + i * FI * BASE^EI.
%
% [...] = UNPACKNUM(X, BASE, N) will make sure BASE is a multiple of N.  N
% must be a positive value.  In this case, 1 <= |F| < BASE*N.
%
% Example:  To display a number using "engineering notation", where the power of
% ten is always a multiple of three, use BASE = 10 and N = 3:
%
%    x = 8.560372e-25;
%    [f, e] = unpacknum(x, 10, 3);    % f = 856.0372 and e = -27
%    fprintf('%.15ge%+.03d\n', f, e);  % displays `856.0372e-027'
%
% See also
%   LOG2



%% File information
% Author: Peter J. Acklam <pjacklam@online.no>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% URL: http://home.online.no/~pjacklam
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2003-11-04
%       * Initial release



%% Algorithm

% check number of input arguments
narginchk(2, 3);

x = double(x);

% check the `base' argument
if ~isnumeric(base) || ~isreal(base) || any(base <= 1)
  error('BASE must contain only real values > 1.');
  
end

base = double(base);

if nargin < 3
  n = 1;
  
else
  % check the `n' argument
  if ~isnumeric(n) || ~isreal(n) || any(n <= 0)
    error('N must contain only real positive values.');
  end
  
  n = double(n);
  
end

% do the real part of `x'
[fr, er] = unpack_fe(real(x), base, n);

% only do the imaginary part of `x' if necessary
if nargout > 2
  if any(imag(x(:)))
    [fi, ei] = unpack_fe(imag(x), base, n);
    
  else
    fi = zeros(size(fr));
    ei = fi;
    
  end
  
end


end



function [f, e] = unpack_fe(x, base, n)
%% UNPACK_FE Unpack real number into fraction and exponent.
%
% We could treat `base = 2' as a special case and use `log2', but that would
% require more work than I think it's worth -- especially when `base' is not a
% scalar.



ax = abs(x);
% avoid log(0) error
ax(~ax) = 1;
% prediction
e = floor(log(ax) ./ log(base));
% correction
e = e  + ( ax == base.^(e+1) );
% make `e' a multiple of `n'
e = n .* floor(e ./ n);
% compute `f'
f = x ./ base.^e;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
