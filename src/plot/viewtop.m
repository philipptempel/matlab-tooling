function viewtop(hax)
%% VIEWTOP 



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-15
% Changelog:
%   2022-09-15
%       * Change argument parsing to use `NARGIN < X` rather than `NARGIN == X`
%   2021-10-20
%       * Fix viewport angles
%   2021-03-18
%       * Store previous original viewport in axes' UserData when it is not
%       already there. This allows for easier restoring of the very original
%       view port
%   2020-12-06
%       * Rename to `viewtop`
%   2020-11-30
%       * Fix implementation opening a new axes when it actually shoulnd't have.
%   2020-11-27
%       * Initial release



%% Parse arguments

narginchk(0, 1);
nargoutchk(0, 0);

if nargin < 1 || isempty(hax)
  hax = gca();
end



%% Set view

if isempty(hax.UserData) && ~isfield(hax.UserData, 'ViewPortOriginal')
  hax.UserData.ViewPortOriginal = hax.View;
end

hax.View = [ +90 , +90 ];
hax.XAxis.Direction = 'normal';
hax.YAxis.Direction = 'normal';


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
