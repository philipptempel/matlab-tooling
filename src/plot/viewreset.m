function viewreset(hax)
%% VIEWRESET 



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-03-18
% Changelog:
%   2021-03-18
%       * Initial release



%% Parse arguments

narginchk(0, 1);
nargoutchk(0, 0);

if nargin == 0
  hax = gca();
end



%% Set view

if ~isempty(hax.UserData) && isfield(hax.UserData, 'ViewPortOriginal')
  view(hax, hax.UserData.ViewPortOriginal);
  hax.XAxis.Direction = 'normal';
  hax.YAxis.Direction = 'normal';
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
