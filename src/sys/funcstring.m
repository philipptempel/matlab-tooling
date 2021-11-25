function s = funcstring(fun)
%% FUNCSTRING Yield string representation of a function
%
% S = FUNCSTRING(FUN) returns a string representing function FUN to the best
% capabilities. This function is the public (i.e., non MATLAB private function)
% of MATLAB's `funfun/private/funstring` function.
%
% Inputs:
%
%   FUN                 Variable type of function. Either a function handle, a
%                       function character name, or an inline function. In any
%                       other case, 'unknown' will be returned.
%
% Outputs:
%
%   S                   String representation of function FUN.
%
% See also:
%   FUNSTRING



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-23
% Changelog:
%   2021-11-23
%       * Initial release



%% Parse arguments

% FUNCSTRING(FUN)
narginchk(1, 1);

% FUNCSTRING(___)
% S = FUNCSTRING(___)
nargoutchk(0, 1);



%% Algorithm

if isa(fun, 'function_handle')
  s = upper(func2str(fun));
  
elseif ischar(fun)
  s = upper(fun);
  
elseif isa(fun, 'inline')
  s = formula(fun);
  
else
  s = 'unknown';
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
