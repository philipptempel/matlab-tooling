function fh = ternary(c, t, f)
%% TERNARY Implementation of a ternary operator in MATLAB
%
% This function implements the ternary operator `() ? () : ()` in MATLAB in a
% fairly human-readable form.
%
% FH = TERNARY(COND, TRUE, FALSE) creates a function handle that, when COND is
% true, returns value of TRUE, otherwise value of FALSE.
%
% Inputs:
%
%   C                       Function handle to condition to test.
% 
%   T                       Function handle or value to return in case of
%                           C == TRUE.
% 
%   F                       Function handle or value to return in case of
%                           C == FALSE.
%
% Outputs:
%
%   FH                      Function handle of as many arguments as the conditon
%                           test C takes.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-21
% Changelog:
%   2022-02-21
%       * Initial release



%% Parse arguments

% TERNARY(C, T, F)
narginchk(3, 3);

% TERNARY(___)
% FH = TERNARY(___)
nargoutchk(0, 1);



%% Algorithm

% Ensure both the true and false condition are a function handle
if ~isa(t, 'function_handle')
  t = @(varargin) t;
end
if nargin(t) == 0
  t = @(varargin) feval(t);
end
if ~isa(f, 'function_handle')
  f = @(varargin) f;
end
if nargin(f) == 0
  f = @(varargin) feval(f);
end

% And wrap everything into a callback
fh = @(varargin) ternary_wrapper(c, t, f, varargin{:});


end


function v = ternary_wrapper(c, t, f, varargin)
%% TERNARY_WRAPPER



% In case of a true condition
if c(varargin{:})
  % Return the true statement
  v = feval(t, varargin{:});

% In case of a false condition
else
  % Return the false statement
  v = feval(f, varargin{:});
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
