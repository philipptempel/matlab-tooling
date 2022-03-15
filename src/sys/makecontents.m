function makecontents(cwd, options)
%% MAKECONTENTS Make a Contents.M file in the given directory
%
% MAKECONTENTS() creates a `CONTENTS.M` file in the current directory.
%
% MAKECONTENTS(CWD) uses CWD as current directory
%
% MAKECONTENTS(CWD, OPTIONS) passes additional configuration options to the
% algorithm.
%
% Inputs:
%
%   CWD                     Directory in which to create the `CONTENTS.M` file
% 
%   OPTIONS                 Options structure for further configuration of the
%                           function.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-03-15
% Changelog:
%   2022-03-15
%       * Fix bug removing the given directory if `Recurse` was on
%       * Fix bug where recursing would only get all functions from lower levels
%       but not create `Contents.m` files in directories further down the
%       hierarchy
%   2022-03-01
%       * Initial release



%% Parse arguments

% MAKECONTENTS()
% MAKECONTENTS(CWD)
% MAKECONTENTS(CWD, OPTIONS)
narginchk(0, 2);

% MAKECONTENTS(___)
nargoutchk(0, 0);

% MAKECONTENTS()
% MAKECONTENTS([], OPTIONS)
if nargin < 1 || isempty(cwd)
  cwd = pwd();
end

% MAKECONTENTS()
% MAKECONTENTS(CWD)
if nargin < 2 || isempty(options)
  options = struct();
end



%% Algorithm

% Parse options
options = parse_options(options);

% Find all directories from the given base
suff = '';
if options.Recurse == matlab.lang.OnOffSwitchState.on
  suff = '**';
end
d = dir(fullfile(cwd, suff));
% Remove files
d(~[d.isdir]) = [];
% Remove the "up" directory i.e., ".."
d(strcmp({d.name}, '..')) = [];
% Remove `private` directories
d(strcmp({d.name}, 'private')) = [];
nd = numel(d);

% Loop over each directory
for id = 1:nd
  dir2contents(fullfile(d(id).folder, d(id).name), options);
end


end



function dir2contents(cwd, options)
%% DIR2CONTENTS



% Find all M-Files
mfs = allfiles(cwd, '.m');
% Remove possible `CONTENTS.M` file
mfs(arrayfun(@(f) isequal(char(lower(f.name)), 'contents.m'), mfs)) = [];
nmf = numel(mfs);

% Loop over all files
for imf = 1:nmf
  % Get file's H1 description
  mfs(imf).h1 = geth1(fullfile(mfs(imf).folder, mfs(imf).name));
  
  % Get clean filename of function
  [~, mfs(imf).mfilename, ~] = fileparts(mfs(imf).name);
  
end

% Length of the longest file name
lenName = num2str(max(arrayfun(@(f) numel(f.name), mfs)));

% Get name of directory
[~, dname] = fileparts(cwd);

% Path to `CONTENTS.M` file
cntntsfile = fullfile(cwd, 'Contents.m');

% Don't overwrite if `CONTENTS.M` file exist and must not be overriden
if 2 == exist(cntntsfile, 'file') && options.Overwrite ~= matlab.lang.OnOffSwitchState.on
  return
end

% Open file for writing
fid = fopen(cntntsfile, 'w');
% Create a cleanup object to close file handle
coClose = onCleanup(@() fclose(fid));

% Write content
fprintf(fid, '%% %s%s', upper(dname), newline());
fprintf(fid, '%%%s', newline());
fprintf(fid, '%% Files%s', newline());

% Loop over each file
for imf = 1:nmf
  fprintf( ...
      fid ...
    , ['%%   %-' lenName 's - %s%s'] ...
    , mfs(imf).mfilename ...
    , mfs(imf).h1 ...
    , newline() ...
  );
end

% Newline at EOF
fprintf(fid, '%s', newline());


end



function options = parse_options(options)
%% PARSE_OPTIONS Parse user-provided options and merge with default options
%
% OPTIONS = PARSE_OPTIONS(OPTIONS) parses user-provided options and fills with
% default values where missing.
%
% Inputs:
%
%   OPTIONS                 Options structure provided by user.
%
% Outputs:
%
%   OPTIONS                 Options structure of parsed/sane options.



% Default options
defaultopts = struct( ...
    'Recurse', false ...
  , 'Overwrite', false ...
);

% Merge with user-provided options
options = mergestructs(defaultopts, options);

% And turn true/false into correct object
options.Recurse = onoffstate(options.Recurse);
options.Overwrite = onoffstate(options.Overwrite);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
