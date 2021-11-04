function rs = spans(rlr, varargin)
%% SPANS Obtain data span of a given ruler
%
% Inputs:
%
%   HAX                 Description of argument HAX
%
%   RLR                 Description of argument RLR
%
% Outputs:
%
%   RS                  Description of argument RS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-04
% Changelog:
%   2021-11-04
%       * Initial release



%% Parse arguments

% SPANS(RLR)
% SPANS(HAX, RLR)
narginchk(1, 2);

% SPANS(___)
% RS = SPANS(___)
nargoutchk(0, 1);

% Extract axis object
[hax, args, ~] = axescheck(rlr, varargin{:});
rlr = args{1};

% Default axis will be the current axis
if isempty(hax)
  hax = gca();
end



%% Obtain data spans

% Get all associated axes data from the axis' childrens
dat = get(hax.Children, [upper(rlr) , 'Data']);

% With multiple children, we need to convert the obtained cell array into a pure
% numeric array
if iscell(dat)
  dat = vertcat(dat{:});
end

% Minimum
rs = [ min(min(dat, [], 2), [], 1) , max(max(dat, [], 2), [], 1) ];


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
