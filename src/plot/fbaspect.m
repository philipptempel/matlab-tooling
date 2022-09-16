function fbaspect(val, varargin)%#codegen
%% FBASPECT Set figure box aspect ratio
%
% FBASPECT([W H]) sets the current figure's aspect ratio to W:H such that the
% height remains unchanged and the width satisfies the aspect ratio.
%
% FBASPECT(FIG, ...) sets aspect ratio of figure given in handle FIG to W:H.
%
% Inputs:
%
%   VAL                     1x2 vector of apsect ration given as [ W , H ]
%
% See also:
%   DASPECT PBASPECT



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-09-16
% Changelog:
%   2022-09-16
%       * Initial release



%% Parse arguments

% FBASPECT(VAL)
% FBASPECT(HF, VAL)
narginchk(1, 2);

% FBASPECT(__)
nargoutchk(0, 0);

% Get figure object (if any)
[hf, args] = figcheck(val, varargin{:});
% No figure?
if isempty(hf)
  % Get current figure
  hf = gcf();
end

% Pop off aspect ratio
val = args{1};
args(1) = [];



%% Algorithm

% Get current figure size i.e., position
fp = get(hf, 'Position');

% Set position of figure such that height remains the same and width adjusts to
% the aspect ratio
set(hf, 'Position', [ fp([1,2]) , fix(val(1) / val(2) * fp(4)) , fp(4) ]);



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
