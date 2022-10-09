function t = pluralize(num, snglr, plrl)%#codegen
%% PLURALIZE Select the plural or singular form of the argument
%
% T = PLURAL(N, S) appends a plural S to text S if count N is larger than one.
%
% T = PLURALIZE(N, S, P) selects the singular form S or plural form P depending on
% the count/size/length of N.
%
% Inputs:
%
%   N                       Number of items.
%
%   S                       Text for single item.
%
%   P                       Text for plural form.
%
% Outputs:
%
%   T                       Singular text S or plural text P.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-10-09
% Changelog:
%   2022-10-09
%       * Initial release



%% Parse arguments

% PLURALIZE(NUM, SING)
% PLURALIZE(NUM, SNGLR, PLRL)
narginchk(2, 3);

% PLURALIZE(___)
% T = PLURALIZE(___)
nargoutchk(0, 1);

% PLURALIZE(NUM, SING)
if nargin < 3 || isempty(plrl)
  plrl = [ snglr , 's' ];
end



%% Algorithm

% Simple switch
if num > 1
  t = plrl;
  
else
  t = snglr;
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
