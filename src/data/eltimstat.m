function varargout = eltimstat(elt)
%% ELTIMSTAT Calculate statistics of elapsed times
%
% ELTIMSTAT(ELT) calculates the statistics MIN, MAX, MEAN, and MEDIAN of all
% columns of ELT and displays the output as a formatted table.
%
% T = ELTIMSTAT(___) returns the table object instead.
%
% Inputs:
%
%   ELT                 NxM array of N time samples and M trials.
%
% See also:
%   TABLE MIN MAX MEDIAN MEAN



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-24
% Changelog:
%   2021-11-24
%       * Initial release



%% Parse arguments

% ELTIMSTAT(ELT)
narginchk(1, 1);

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
  , 'VariableNames', arrayfun(@(idx) sprintf('Trial %d', idx), 1:size(elt, 2), 'UniformOutput', false) ...
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
