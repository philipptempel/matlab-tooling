function varargout = eltimstat(elt, names, prec)
%% ELTIMSTAT Calculate statistics of elapsed times
%
% ELTIMSTAT(ELT) calculates the statistics SUM, MIN, MAX, MEAN, MEDIAN, and STD
% of all columns of ELT and displays the output as a formatted table.
%
% ELTIMSTAT(ELT, TRIALNAMES) uses trial names TRIALNAMES as table headings
% instead of generic `Trial x` text.
%
% ELTIMSTAT(___, PRECISION) allows setting the decimal precision of durations.
%
% T = ELTIMSTAT(___) returns the table object instead.
%
% Inputs:
%
%   ELT                     NxM array of N time samples and M trials.
%
%   TRIALNAMES              1xM cell array of trial names.
%
%   PRECISION               Scalar precision used in displaying the elasped
%                           durations.
%                           Default: 3.
%
% See also:
%   SECONDS TABLE MIN MAX MEDIAN MEAN STD



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-09
% Changelog:
%   2022-03-09
%       * Add input argument `PREC`
%       * Replace use of `time2str` with `seconds`
%   2022-02-23
%       * Add fields `SUM` and `STD` to table
%   2022-01-20
%       * Add option `TRIALNAMES`.
%   2021-11-24
%       * Initial release



%% Parse arguments

% ELTIMSTAT(ELT)
% ELTIMSTAT(ELT, NAMES)
% ELTIMSTAT(ELT, NAMES, PREC)
narginchk(1, 3);

% ELTIMSTAT(___)
% T = ELTIMSTAT(___)
nargoutchk(0, 1);

% ELTIMSTAT(ELT)
if nargin < 2 || isempty(names)
  names = arrayfun(@(idx) sprintf('Trial %d', idx), 1:size(elt, 2), 'UniformOutput', false);
end

% ELTIMSTAT(ELT, NAMES)
if nargin < 3 || isempty(prec)
  prec = 3;
end



%% Algorithm

% Elapsed durations in seconds
durs = round( ...
    [ ...
      sum(elt, 1) ; ...
      min(elt, [], 1) ; ...
      median(elt, 1) ; ...
      mean(elt, 1) ; ...
      max(elt, [], 1) ; ...
      std(elt, [], 1) ; ...
    ] ...
  , prec ...
);
durs = seconds(durs);

% Build table
t = array2table( ...
  durs ...
  , 'RowNames', { 'sum', 'min' , 'median' , 'mean' , 'max' , 'std' } ...
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
