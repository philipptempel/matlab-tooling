function s = time2str(d, varargin)
%% TIME2STR turns a duration in seconds into a human readable string
%
% S = TIME2STR(D) turns time durations D into human readable strins.
%
% Inputs:
%
%   D                       MxN numeric array of durations in seconds to
%                           translate.
%
% Outputs:
%
%   S                       MxN char array representing durations D in the
%                           lowest human readable scale.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-03-07
% Changelog:
%   2022-03-07
%       * Remove parameter `Format`
%       * Change logic to return human readable time strings with 'min', 's',
%       'ms', etc. included
%       * Format H1 documentation
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-07-02
%       * Change validation of argument `D` to allow also zero as value
%   2021-02-11
%       * Initial release



%% Parse arguments

% TIME2STR(D)
narginchk(1, 1);

% TIME2STR(___)
% S = TIME2STR(___)
nargoutchk(0, 1);



%% Algorithm

% Run over each element of B and convert it
s = arrayfun(@(dur) in_parseduration(dur), d, 'UniformOutput', false);

% If there was only one time given, we will also have to adjust the array of
% strings
if numel(d) == 1
  s = s{1};
end


end


function s = in_parseduration(d)
%% IN_PARSEDURATION
%
% Inputs:
%
%   D                       Scalar duration in seconds.
%
% Outputs:
%
%   S                       Character array of duration.



persistent sec_ min_ hour_ day_ week_ month_ year_ millennium_ factor metric;

if isempty(sec_)
  sec_        = 1;
  min_        = 60     * sec_;
  hour_       = 60     * min_;
  day_        = 24     * hour_;
  week_       = 7      * day_;
  month_      = 30.471 * day_;
  year_       = 365.26 * day_;
  millennium_ = 1000   * year_;

  factor = [ 10 .^ (-24:3:0) , min_ , hour_ , day_ , week_ , month_ , year_ , millennium_ ];
  metric = { 'ys' , 'zs' , 'as' , 'fs' , 'ps' , 'ns' , 'mus' , 'ms' , 's' , 'min' , 'hr' , 'd' , 'w' , 'mo' , 'a' , 'ka' };
  
end

% Find the largest scaling factor
scls = d ./ factor;
idx = find(1 <= scls & scls < 1e3, 1, 'last');
if isempty(idx)
  idx = 9;
end

% Houses the fixed-integer parts of each factor
parts = nan(1, idx);

% Loop over each factor
for fidx = idx:-1:1
  % Full integer value of number and factor
  v = fix(d / factor(fidx));
  % 
  parts(idx-fidx+1) = v;
  % Calculate remaining value
  d = d - v * factor(fidx);
  % If remaining value is less than or equal to zero, we stop
  if d <= 0
    break
    
  end
  
end

% Remove superfluous time parts
parts(isnan(parts)) = [];
nparts = numel(parts);
% Get the metrics matching each part
metrics = metric(idx - (0:(nparts - 1)));

% Build the final time string
s = strjoin(arrayfun(@(ind) sprintf('%d%s', parts(ind), metrics{ind}), 1:nparts, 'UniformOutput', false), ' ');


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
