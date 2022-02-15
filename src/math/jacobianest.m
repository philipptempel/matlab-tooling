function [jac, err] = jacobianest(fun, x0, maxh, ratioh)
%% JACOBIANEST Estimate Jacobian matrix of a vector-valued function of N variables
%
% JAC = JACOBIANEST(FUN, X0) estimate the Jacobian matrix of a vector valued
% function of N variables usage.
%
% JAC = JACOBIANEST(FUN, X0, MAXH) sets maximum step size for Jacobian calculation
% to MAXH.
%
% JAC = JACOBIANEST(FUN, X0, MAXH, RATIOH) sets ratio between 
%
% [JAC, ERR] = JACOBIANEST(___) also returns error estimates of each partial
% derivative in JAC.
% 
% Inputs:
% 
%   FUN                 Analytical (vector valued) function to differentiate.
%                       FUN must be a function of the vector or array X0.
% 
%   X0                  Vector location at which to differentiate FUN. If X0 is
%                       an NxM array, FUN is assumed to be a function of NxM
%                       variables.
%
% Outputs:
%
%   JAC                 Array of first partial derivatives of FUN. Assuming that
%                       X0 is a vector of length M and FUN returns a vector of
%                       length N, then JAC will be an array of size NxM.
%
%   ERR                 NxM array of error estimates corresponding to each
%                       partial derivative in JAC.
%
% Examples:
%
% Nonlinear least-squares
%   xdata = (0:.1:1).';
%   ydata = 1 + 2*exp(0.75 * xdata);
%   fun = @(c) ((c(1) + c(2)*exp(c(3)*xdata)) - ydata).^2;
%
%   [jac, err] = jacobianest(fun, [1, 1, 1])
%
%   jac =
%            -2           -2            0
%       -2.1012      -2.3222     -0.23222
%       -2.2045      -2.6926     -0.53852
%       -2.3096      -3.1176     -0.93528
%       -2.4158      -3.6039      -1.4416
%       -2.5225      -4.1589      -2.0795
%        -2.629      -4.7904      -2.8742
%       -2.7343      -5.5063      -3.8544
%       -2.8374      -6.3147      -5.0518
%       -2.9369      -7.2237      -6.5013
%       -3.0314      -8.2403      -8.2403
%
%   err =
%       5.0134e-15   5.0134e-15            0
%       5.0134e-15            0   2.8211e-14
%       5.0134e-15   8.6834e-15   1.5804e-14
%               0      7.09e-15   3.8227e-13
%       5.0134e-15   5.0134e-15   7.5201e-15
%       5.0134e-15   1.0027e-14   2.9233e-14
%       5.0134e-15            0   6.0585e-13
%       5.0134e-15   1.0027e-14   7.2673e-13
%       5.0134e-15   1.0027e-14   3.0495e-13
%       5.0134e-15   1.0027e-14   3.1707e-14
%       5.0134e-15   2.0053e-14   1.4013e-12
%
%  (At [1, 2, 0.75], jac should be numerically zero)
%
% See also
%   DERIVEST GRADIENT GRADEST



%% File information
% Author: John D'Errico <woodchips@rochester.rr.com>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-15
% Changelog:
%   2022-02-15
%       * Rename to `JACOBIANEST`
%   2021-11-17
%       * Update H1 to correct format
%   2021-07-16
%       * Initial release



%% Algorithm
% get the length of x0 for the size of jac
nx = numel(x0);

if nargin < 3 || isempty(maxh)
  maxh = 1;
end

if nargin < 4 || isempty(ratioh)
  ratioh = 2.0000001;
end

% was a string supplied?
if ischar(fun)
  fun = str2func(fun);
end

% get fun at the center point
f0 = fun(x0);
f0 = f0(:);
n = length(f0);
if n == 0
  % empty begets empty
  jac = zeros(0, nx);
  err = jac;
  return
end

relativedelta = maxh * ratioh .^ (0:-1:-25);
nsteps = length(relativedelta);

% total number of derivatives we will need to take
jac = zeros(n, nx);
err = jac;
parfor i = 1:nx
  x0_i = x0(i);
  if x0_i ~= 0
    delta = x0_i * relativedelta;
  else
    delta = relativedelta;
  end
  
  % evaluate at each step, centered around x0_i
  % difference to give a second order estimate
  fdel = zeros(n,nsteps);
  for j = 1:nsteps
    fdif = fun(swapelement(x0, i, x0_i + delta(j))) + ...
        - fun(swapelement(x0, i, x0_i - delta(j)));
    
    fdel(:,j) = fdif(:);
  end
  
  % these are pure second order estimates of the
  % first derivative, for each trial delta.
  derest = fdel .* repmat(0.5 ./ delta, n, 1);
  
  % The error term on these estimates has a second order
  % component, but also some 4th and 6th order terms in it.
  % Use Romberg exrapolation to improve the estimates to
  % 6th order, as well as to provide the error estimate.
  
  % loop here, as rombextrap coupled with the trimming
  % will get complicated otherwise.
  for j = 1:n
    [der_romb, errest] = rombextrap(ratioh, derest(j,:), [2 4]);
    
    % trim off 3 estimates at each end of the scale
    nest = length(der_romb);
    trim = [ 1, 2, 3, nest + (-2:0) ];
    [der_romb, tags] = sort(der_romb);
    der_romb(trim) = [];
    tags(trim) = [];
    
    errest = errest(tags);
    
    % now pick the estimate with the lowest predicted error
    [err(j,i), ind] = min(errest);
    jac(j,i) = der_romb(ind);
  end
end

end % mainline function end

% =======================================
%      sub-functions
% =======================================
function vec = swapelement(vec,ind,val)
% swaps val as element ind, into the vector vec
vec(ind) = val;

end % sub-function end

% ============================================
% subfunction - romberg extrapolation
% ============================================
function [der_romb, errest] = rombextrap(StepRatio, der_init, rombexpon)
% do romberg extrapolation for each estimate
%
%  StepRatio - Ratio decrease in step
%  der_init - initial derivative estimates
%  rombexpon - higher order terms to cancel using the romberg step
%
%  der_romb - derivative estimates returned
%  errest - error estimates
%  amp - noise amplification factor due to the romberg step

srinv = 1 / StepRatio;

% do nothing if no romberg terms
nexpon = length(rombexpon);
rmat = ones(nexpon + 2, nexpon + 1);
% two romberg terms
rmat(2,2:3) = srinv .^ ( 1 * rombexpon );
rmat(3,2:3) = srinv .^ ( 2 * rombexpon );
rmat(4,2:3) = srinv .^ ( 3 * rombexpon );

% qr factorization used for the extrapolation as well
% as the uncertainty estimates
[qromb, rromb] = qr(rmat, 0);

% the noise amplification is further amplified by the Romberg step.
% amp = cond(rromb);

% this does the extrapolation to a zero step size.
ne = length(der_init);
rhs = vec2mat(der_init, nexpon + 2, ne -(nexpon + 2));
rombcoefs = rromb \ ( qromb' * rhs );
der_romb = rombcoefs(1,:)';

% uncertainty estimate of derivative prediction
s = sqrt(sum( (rhs - rmat * rombcoefs) .^ 2, 1));
rinv = rromb \ eye(nexpon + 1);
cov1 = sum(rinv .^ 2, 2); % 1 spare dof
errest = s' * 12.7062047361747 * sqrt(cov1(1));

end % rombextrap


% ============================================
% subfunction - vec2mat
% ============================================
function mat = vec2mat(vec,n,m)
% forms the matrix M, such that M(i,j) = vec(i+j-1)
[i, j] = ndgrid(1:n, 0:m-1);
ind = i + j;
mat = vec(ind);
if n == 1
  mat = mat';
end

end % vec2mat
