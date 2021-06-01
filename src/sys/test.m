function test(varargin)
%% TEST Run tests for several packages
%
% TEST runs all tests in the current working directory's `tests` directory.
% Specific scenarios can be selected by specifying them separately. Nested
% scenarios are supported based on their directory structure.
%
% TEST SCENARIO SCENARIO SCENARIO ...



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2020-12-22
% Changelog:
%   2020-12-22
%       * Add support for specifying nested scenarios. This also avoids running
%       scenarios multiple times in case they have been selected more than once.
%   2020-11-16
%       * Initial release



%% Parse arguments

% TEST()
if nargin == 0
  tests = {'all'};
else
  tests = unique(varargin);
end

% TEST(...)
narginchk(0, Inf);
% TEST(...)
nargoutchk(0, 0);

% Directory where all tests are stored
testsdir = fullpath(fullfile(pwd, 'tests'));

% Build list of available tests
d = alldirs(testsdir, 'Recurse', 'on');
scenarios = arrayfun(@(d) strrep(fullfile(d.folder, d.name), [testsdir, filesep()], ''), d, 'UniformOutput', false);



%% Create tests and run them

% Import classes to improve readability
import matlab.unittest.TestSuite;

% Ensure we don't run tests multiple times if 'all' and specific test cases are
% given
if ismember(tests, 'all')
  tests = scenarios;
  args = {};
else
  % Get only those tests that exist and are requested
  tests = intersect(scenarios, varargin);
  args = setdiff(varargin, scenarios);
end

% Collect all tests suites per package
suite = cell(1, numel(tests));
for itest = 1:numel(tests)
  suite{itest} = TestSuite.fromFolder(fullfile(testsdir, tests{itest}), 'IncludingSubfolders', true, args{:});
end

% Get all suites
suite = horzcat(suite{:});

% Continue only if we found suites
if numel(suite)
  % Make test suites unique just in case the user selected multiple nested
  % scenarios at once
  [~, idx] = unique({suite.Name});
  suite = suite(idx);

  % Run tests
  run(suite);
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
