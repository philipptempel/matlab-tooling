function struct2vars(s)
%% STRUCT2VARS Convert a structure to local variables
%
% STRUCT2VARS(S) converts all key/value from structure S into local variables in
% your current workspace.
%
% Inputs:
%
%   S                       A structure.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-08-09
% Changelog:
%   2022-08-09
%       * Initial release



%% Parse arguments

% STRUCT2VARS(S)
narginchk(1, 1);

% STRUCT2VARS(___)
nargoutchk(0, 0);



%% Algorithm

% Get structure's fields and count them
fn = fieldnames(s);
nfn = numel(fn);

% Get callers variables
callerWho = evalin('caller', 'whos()');
callerVars = {callerWho.name};

% Loop over each field
for ifn = 1:nfn
  % Get field name
  f = fn{ifn};
  % Check we don't override any existing variable
  if ismember(f, callerVars)
    warning('Overwriting variable %s in caller workspace.', f);
  end
  
  % And assign the value in the caller's workspace
  assignin('caller', f, s.(f));
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
