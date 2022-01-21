function varargout = eltimstat(elt, names)
%% ELTIMSTAT Calculate statistics of elapsed times
%
% ELTIMSTAT(ELT) calculates the statistics MIN, MAX, MEAN, and MEDIAN of all
% columns of ELT and displays the output as a formatted table.
%
% ELTIMSTAT(ELT, TRIALNAMES) uses trial names TRIALNAMES as table headings
% instead of generic `Trial x` text.
%
% T = ELTIMSTAT(___) returns the table object instead.
%
% Inputs:
%
%   ELT                 NxM array of N time samples and M trials.
%
%   TRIALNAMES          1xM cell array of trial names.
%
% See also:
%   TABLE MIN MAX MEDIAN MEAN



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-01-20
% Changelog:
%   2022-01-20
%       * Add option `TRIALNAMES`.
%   2021-11-24
%       * Initial release



%% Parse arguments

% ELTIMSTAT(ELT)
% ELTIMSTAT(ELT, NAMES)
narginchk(1, 2);

% ELTIMSTAT(ELT)
if nargin < 2 || isempty(names)
  names = arrayfun(@(idx) sprintf('Trial %d', idx), 1:size(elt, 2), 'UniformOutput', false);
end

% ELTIMSTAT(___)
% T = ELTIMSTAT(___)
nargoutchk(0, 1);



%% Algorithm

t = array2table( ...
  time2str( ...
    [ ...
      min(elt, [], 1) ; ...
      median(elt, 1) ; ...
      mean(elt, 1) ; ...
      max(elt, [], 1) ; ...
    ] ...
    , 'Format', '%.3f' ...
  ) ...
  , 'RowNames', {'min', 'median', 'mean', 'max'} ...
  , 'VariableNames', names ...
);


%% Assign output quanttiies

if nargout == 0
  display(t);
end

if nargout > 0
  varargout{1} = t;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
