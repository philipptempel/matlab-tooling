function textinterpreters(h, intp)
%% TEXTINTERPRETERS Set default text interpreters on graphics object
%
% TEXTINTERPRETERS(H)
%
% TEXTINTERPRETERS(H, INTP)
%
% Inputs:
%
%   H                       Graphics handle.
% 
%   INTP                    Interpreter name.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-04-11
% Changelog:
%   2022-04-11
%       * Initial release



%% Parse arguments

% TEXTINTERPRETERS(H)
% TEXTINTERPRETERS(H, INTP)
narginchk(1, 2);

% TEXTINTERPRETERS(___)
nargoutchk(0, 0);

% TEXTINTERPRETERS(H)
if nargin < 2 || isempty(intp)
  intp = 'latex';
end



%% Algorithm

% Get object's properties
p  = get(h);
fn = fieldnames(p);
np = numel(fn);

% Loop over each property
for ip = 1:np
  % Skip property "Parent"
  if strcmpi(fn{ip}, 'Parent')
    continue
  end
  
  % Get value
  v = p.(fn{ip});
  
  % If value is an object, recurse into it
  if isobject(v)
    try
      textinterpreters(v, intp);
    catch
    end
    
  % Value is no object, proceed as normal
  else
    % If property key does not contain text "Interpreter", we will skip it
    if contains(fn{ip}, 'Interpreter', 'IgnoreCase', true)
      set(h, fn{ip}, intp);
    end
    
  end
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
