function [hess,err] = hessest(fun,x0)
%% HESSEST Estimate Hessian matrix of a scalar function
%
% HESS = HESSEST(FUN, XO) estimate elements of the Hessian matrix (array of 2nd
% partials) of function FUN at X0.
%
% [HESS, ERR] = HESSEST(FUN, XO) also return error estiamtes of each element in
% HESS.
%
% Hessian is NOT a tool for frequent use on an expensive to evaluate objective
% function, especially in a large number of dimensions. Its computation will use
% roughly O(6*n^2) function evaluations for n parameters.
%
% Inputs:
%
%   FUN                 Scalar analytical function to differentiate. FUN must be
%                       a function ofthe vector or array X0. FUN does not need
%                       to be vectorized.
% 
%   X0                  Nx1 vector location at which to compute the Hessian.
%
% Outputs:
% 
%   HESS                NxN symmetric array of second partial derivatives of
%                       FUN, evaluated at X0.
%
%   ERR                 NxN array of error estimates corresponding to each
%                       second partial derivative in HESS.
%
% Examples:
%
% Rosenbrock function, minimized at [1,1]
%   rosen = @(x) (1 - x(1)).^2 + 105*(x(2) - x(1).^2).^2;
%   [h, err] = hessian(rosen, [1, 1])
%   h =
%           842         -420
%          -420          210
%   err =
%    1.0662e-12   4.0061e-10
%    4.0061e-10   2.6654e-13
%
%
% Calculate positive semi-definite matrix of cos(x-y) at (0,0)
%   hessian(@(xy) cos(xy(1) - xy(2)), [0, 0])
%   ans =
%           -1            1
%            1           -1
%
% See also
%   DERIVEST GRADIENT GRADEST HESSDIAG



%% File information
% Author: John D'Errico <woodchips@rochester.rr.com>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2021-07-16
%       * Initial release



%% Algorithm
% parameters that we might allow to change
params.StepRatio = 2.0000001;
params.RombergTerms = 3;

% get the size of x0 so we can reshape
% later.
sx = size(x0);

% was a string supplied?
if ischar(fun)
  fun = str2func(fun);
end

% total number of derivatives we will need to take
nx = length(x0);

% get the diagonal elements of the hessian (2nd partial
% derivatives wrt each variable.)
[hess,err] = hessdiag(fun,x0);

% form the eventual hessian matrix, stuffing only
% the diagonals for now.
hess = diag(hess);
err = diag(err);
if nx<2
  % the hessian matrix is 1x1. all done
  return
end

% get the gradient vector. This is done only to decide
% on intelligent step sizes for the mixed partials
[~, ~, stepsize] = gradest(fun,x0);

% Get params.RombergTerms+1 estimates of the upper
% triangle of the hessian matrix
dfac = params.StepRatio.^(-(0:params.RombergTerms)');
for i = 2:nx
  for j = 1:(i-1)
    dij = zeros(params.RombergTerms+1,1);
    for k = 1:(params.RombergTerms+1)
      dij(k) = fun(x0 + swap2(zeros(sx),i, ...
        dfac(k)*stepsize(i),j,dfac(k)*stepsize(j))) + ...
        fun(x0 + swap2(zeros(sx),i, ...
        -dfac(k)*stepsize(i),j,-dfac(k)*stepsize(j))) - ...
        fun(x0 + swap2(zeros(sx),i, ...
        dfac(k)*stepsize(i),j,-dfac(k)*stepsize(j))) - ...
        fun(x0 + swap2(zeros(sx),i, ...
        -dfac(k)*stepsize(i),j,dfac(k)*stepsize(j)));
        
    end
    dij = dij/4/prod(stepsize([i,j]));
    dij = dij./(dfac.^2);
    
    % Romberg extrapolation step
    [hess(i,j), err(i,j)] =  rombextrap(params.StepRatio, dij, [2 4]);
    hess(j,i) = hess(i,j);
    err(j,i) = err(i,j);
  end
end


end % mainline function end

% =======================================
%      sub-functions
% =======================================
function vec = swap2(vec,ind1,val1,ind2,val2)
% swaps val as element ind, into the vector vec
vec(ind1) = val1;
vec(ind2) = val2;

end % sub-function end


% ============================================
% subfunction - romberg extrapolation
% ============================================
function [der_romb,errest] = rombextrap(StepRatio,der_init,rombexpon)
% do romberg extrapolation for each estimate
%
%  StepRatio - Ratio decrease in step
%  der_init - initial derivative estimates
%  rombexpon - higher order terms to cancel using the romberg step
%
%  der_romb - derivative estimates returned
%  errest - error estimates
%  amp - noise amplification factor due to the romberg step

srinv = 1/StepRatio;

% do nothing if no romberg terms
nexpon = length(rombexpon);
rmat = ones(nexpon+2,nexpon+1);
switch nexpon
  case 0
    % rmat is simple: ones(2,1)
  case 1
    % only one romberg term
    rmat(2,2) = srinv^rombexpon;
    rmat(3,2) = srinv^(2*rombexpon);
  case 2
    % two romberg terms
    rmat(2,2:3) = srinv.^rombexpon;
    rmat(3,2:3) = srinv.^(2*rombexpon);
    rmat(4,2:3) = srinv.^(3*rombexpon);
  case 3
    % three romberg terms
    rmat(2,2:4) = srinv.^rombexpon;
    rmat(3,2:4) = srinv.^(2*rombexpon);
    rmat(4,2:4) = srinv.^(3*rombexpon);
    rmat(5,2:4) = srinv.^(4*rombexpon);
end

% qr factorization used for the extrapolation as well
% as the uncertainty estimates
[qromb,rromb] = qr(rmat,0);

% the noise amplification is further amplified by the Romberg step.
% amp = cond(rromb);

% this does the extrapolation to a zero step size.
ne = length(der_init);
rombcoefs = rromb\(qromb'*der_init);
der_romb = rombcoefs(1,:)';

% uncertainty estimate of derivative prediction
s = sqrt(sum((der_init - rmat*rombcoefs).^2,1));
rinv = rromb\eye(nexpon+1);
cov1 = sum(rinv.^2,2); % 1 spare dof
errest = s'*12.7062047361747*sqrt(cov1(1));

end % rombextrap
