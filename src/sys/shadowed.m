function fh = shadowed(fname)
%% SHADOWED Return path to a shadowed MATLAB functon
%
% FH = SHADOWED(FNAME) returns a function handle to the shadowed MATLAB function
% FNAME.
%
% Inputs:
% 
%   FNAME               Function name of shadowing function to retrieve MATLAB's
%                       built-in function for.
%
% Outputs:
%
%   FH                  Description of argument FH
%
% Examples:
%
% Return the filepath to MATLAB's built-in `RMPATH` function. At the end of this
% call, `FH` will point to `MATLABROO()/toolbox/matlab/general/rmpath.m`.
%
%   FH = SHADOWED('RMPATH')



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-29
% Changelog:
%   2021-11-29
%       * Initial release



%% Parse arguments

% SHADOWED()
% SHADOWED(FNAME)
narginchk(0, 1);

% SHADOWED(___)
% FH = SHADOWED(___)
nargoutchk(0, 1);

% If no function name is given, we will guess from the calling function
if nargin < 1 || isempty(fname)
  fname = backtrace_function();
end



%% Algorithm

persistent cache

if isempty(cache)
  cache = struct();
end

% Split given filename into its file parts
[~, fname, fext] = fileparts(fname);

% Current working directory to switch back to after this function ends
cwd = pwd();

% Check if function not yet cached
if ~isfield(cache, fname)
  
  % The fully qualified function name
  this_fname = [ fname, fext ];
  
  % Find all the functions which shadow it
  all_fcns = which(this_fname, '-all');
  
  % Locate 1st file in list under `MATLABROOT`
  f = strncmp(all_fcns, matlabroot(), length(matlabroot()));
  
  % Extract from list the exact function we want to be able to call
  shadow_fcn = all_fcns{find(f, 1)};
  
  % Change back to this file's directory at end of this function
  coDir = onCleanup(@() cd(cwd));
  
  % Temporarily switch to the containing folder
  cd(fileparts(shadow_fcn));
  
  % Grab a handle to the function
  cache.(fname) = str2func(fname);
  
end

% Get function handle
fh = cache.(fname);


end


function f = backtrace_function()
%% BACKTRACE_FUNCTION


% Get callback stack but skip the first two entries (the call to `DBSTACK` in
% `BACKTRACE_FUNCTION` and the call to `BACKTRACE_FUNCTION` in `SHADOWED`)
st = dbstack(2, '-completenames');

% The next file in the stack (originally the third one) is the function calling
f = st(1).file;


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
