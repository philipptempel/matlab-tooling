function varargout = varsize(varargin)
%% VARSIZE determines the size of each variable given
%
% VARSIZE() prints the size of all of caller's variables in bytes.
%
% VARSIZE(X) prints the size of variable X on the screen.
%
% VARSIZE(X, Y) prints the size of variables X and Y on the screen.
%
% S = VARSIZE(...) returns the size of all variables in bytes in struct S.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-02-28
% Changelog:
%   2022-02-28
%       * Beautify output of function
%       * Add support for 0-argument call
%       * Code improvement
%       * Update H1 documentation
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2018-02-06
%       * Initial release



%% Validate arguments
try
    % VARSIZE()
    % VARSIZE(X, ...)
    narginchk(0, Inf);
    
    % VARSIZE(___)
    % S = VARSIZE(___)
    nargoutchk(0, 1);
    
catch me
    throwAsCaller(me);
end



%% Do your code magic here
% Store the names of the variables passed to this function in here
ceVarnames = cell(1, nargin);

% Get the original variable names passed to this function
for iArg = 1:nargin
    if ~isa(varargin{iArg}, 'char')
        ceVarnames{iArg} = inputname(iArg);
    else
        ceVarnames{iArg} = varargin{iArg};
    end
end

% Get all variables in the caller's workspace
vars = evalin('caller', 'whos();');

% Get info of only the variables that were passed to this function
if numel(ceVarnames)
  vars(~ismember({vars.name}, ceVarnames)) = [];
end

% Extract only the fields from the WHOS structure that we need
vars = struct('name', {vars.name}, 'bytes', {vars.bytes});

% Convert bytes to respective byte sizes
ceBytes = bytes2str([vars.bytes]);
[vars.bytes] = deal(ceBytes{:});



%% Assign output quantities
% No output, display the data
if nargout == 0
    % Count width of each column (variables' names and variables' size in bytes)
    col_widths = transpose(cell2mat(arrayfun(@(v) structfun(@(f) length(f), v), vars, 'UniformOutput', false)));
    % Ensure each column is at least 12 characters wide
    col_widths = max([12, 12], max(col_widths, [], 1)) + [4, 0];
    
    % Table headers
    fprintf('  ');
    fprintf(sprintf('%%-%ds', col_widths(1)), 'Name');
    fprintf(sprintf('%%+%ds', col_widths(2)), 'Bytes');
    fprintf(newline());
    % Separator between table and content
    fprintf(newline());
    
    % Loop over all variables
    for ivar = 1:numel(vars)
      var = vars(ivar);
      % Initial spacer
      fprintf('  ');
      % Variable's name
      fprintf(sprintf('%%-%ds', col_widths(1)), var.name);
      % Variable's size
      fprintf(sprintf('%%+%ds', col_widths(2)), strrep(var.bytes, ' b', ' b '));
      % And a newline character
      fprintf(newline());
    end
    
end

% One output: return the structure
if nargout > 0
    varargout{1} = vars;
    
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
