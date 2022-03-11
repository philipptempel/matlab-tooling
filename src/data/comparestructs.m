function tf = comparestructs(c, g)
%% COMPARESTRUCTS Compare two structures
%
% F = COMPARESTRUCTS(C, G) compares candidate structure C against ground truth
% structure G.
%
% Inputs:
%
%   C                       Description of argument C
% 
%   G                       Description of argument G
%
% Outputs:
%
%   F                       True/false flag if both structures are the same.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-10
% Changelog:
%   2022-03-10
%       * Initial release



%% Parse arguments

narginchk(2, 2);

nargoutchk(0, 1);



%% Algorithm

% Get field names of ground truth
fns = fieldnames(g);
nfns = numel(fns);

% Initialize flag to be true
f = true;

% Loop over each field

for ifn = 1:nfns
  % Field name
  fn = fns{ifn};
  
  % Status output
  fprintf('comparing field %s...', fn);
  
  % Get value from ground truth
  vg = g.(fn);
  
  % Process candidate
  try
    % Get value from candidate
    vc = c.(fn);
    
    % If both values are structures, recurse into them
    if isstruct(vg) && isstruct(vc)
      f = comparestructs(vc, vg);
      
    % One or both values aren't structures, so we will simply compare them
    else
      f = allisclose(vc, vg);
      
    end
    
  catch me
    % And set flag to false
    f = false;
    
  end
  
  if f == false
    cprintf('error', 'not same');
  else
    cprintf('green', 'same');
  end
  
  fprintf('%s', newline());
  
end



%% Assign output quantities

% TF = COMPARESTRUCTS(___)
if nargout > 0
  tf = f;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
