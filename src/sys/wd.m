function varargout = wd(varargin)
%% WD MATLAB implementation of `warpdirectory`
%
% WD('add') adds current working directory to your warp points.
% WD('add', POINT) adds directory POINT to your warp points.
%
% WD('rm') removes warp point of the current working directory.
% WD('rm', POINT) removes warp point POINT.
%
% WD('list') prints all stored warp points
%
% WD('ls', POINT) show files from a given warp point.
%
% WD('path', POINT) show path to a given warp point.
%
% WD('clean') remove warp points warping to nonexistent directories.
%
% WD('help') shows a short help of which commands are available.
%
% WD(POINT) warp to the warp point specified.
% WD(POINT, PATH, ...) warp to the warp point specified and its relative
% subdirectoy/subdirectoires under PATH.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-03-29
% Changelog:
%   2021-05-11
%       * Update to work on windows, too.
%   2021-03-29
%       * Add `help` action
%   2021-03-17
%       * Update H1 documentation
%   2020-11-23
%       * Initial release


%% Parse arguments

narginchk(0, 3)
nargoutchk(0, 1);

if nargin == 0
  action = 'list';
  
else
  action = varargin{1};
  varargin(1) = [];
  
end

switch action
  case 'add'
    wd_add(varargin{:});
  
  case 'rm'
    wd_rm(varargin{:});
  
  case 'list'
    wd_list(varargin{:});
  
  case 'ls'
    wd_ls(varargin{:});
  
  case 'path'
    [varargout{1:nargout}] = deal(wd_path(varargin{:}));
  
  case 'clean'
    wd_clean(varargin{:});
  
  case 'help'
    wd_help();
  
  otherwise
      wd_go(action, varargin{:});
  
end


end


function wd_help()
%% WD_HELP
%
% WD_HELP()


hlp = [ ...
    {'add';    'Add a warp point'} ...
  , {'rm';     'Remove a warp point'} ...
  , {'list';   'List all warp points'} ...
  , {'ls';     'List files of warp point'} ...
  , {'path';   'Show path to warp point'} ...
  , {'clean';  'Remove dead warp points'} ...
  , {'<wd>';     'Go to warp point'} ...
];

spacer = 2 + max(cellfun(@numel, hlp(1,:)));

fmt = ['  %', num2str(spacer) , 's   %s\n'];

for h = hlp
  fprintf(fmt, h{:});
end


end


function rc = wd_read_rc()
%% WD_READ_RC
%
% WD_READ_RC()


persistent prc

if isempty(prc)
  % Path to warp RC
  prc = fullfile(userpath(), '.warprc');
end

rc = repmat(struct('name', '', 'path', ''), [1, 0]);

try
  % Read file
  c = strsplit(fileread(prc), newline());
  c(cellfun(@isempty, c)) = [];
  c = cellfun(@(cs) strsplit(cs, ':'), c, 'UniformOutput', false);
  if ~isempty(c)
    c = cellfun(@(cs) [cs(1), wd_decode_path(cs{2})], c, 'UniformOutput', false);
    rc = cell2struct(transpose(vertcat(c{:})), {'name', 'path'});
  end
catch
end


end


function wd_save_rc(rc)
%% WD_SAVE_RC
%
% WD_SAVE_RC(RC)


persistent prc

if isempty(prc)
  % Path to warp RC
  prc = fullfile(userpath(), '.warprc');
end

% Sort directories alphabetically by name
[~, idx] = sort({rc.name});
rc = rc(idx);

try
  fid = fopen(prc, 'w');
  coCloseFile = onCleanup(@() fclose(fid));
  if fid ~= 1
    for irc = 1:numel(rc)
      fprintf(fid, '%s:%s\n', rc(irc).name, wd_encode_path(rc(irc).path));
    end
  end
catch me
  warning(me.identifier, '%s', me.message);
end


end


function wd_go(point, p)
%% WD_GO
%
% WD_GO(POINT)
%
% WD_GO(POINT, PATH)


% WD_GO(POINT)
% WD_GO(POINT, PATH)
narginchk(1, 2);
nargoutchk(0, 0);

if nargin < 2 || isempty(p)
  p = '';
end

% Get path and move
cd(fullfile(wd_path(point), wd_decode_path(p)));


end


function wd_add(point)
%% WD_ADD
%
% WD_ADD()
%
% WD_ADD(POINT)


% WD_ADD()
% WD_ADD(POINT)
narginchk(0, 1);
nargoutchk(0, 0);

% Default point is current directory's name
if nargin < 1 || isempty(point)
  point = fileparts(fullfile(pwd));
end

% Get all directories
rc = wd_read_rc();

% Only save if warp directory does not exist yet
if ~any(strcmp({rc.name}, point))
  rc = vertcat(rc, struct('name', point, 'path', pwd()));
end

wd_save_rc(rc);


end


function wd_rm(point)
%% WD_RM
%
% WD_RM()
%
% WD_RM(POINT)


% WD_RM()
% WD_RM(POINT)
narginchk(0, 1);
nargoutchk(0, 0);


% Default point is current directory's name
if nargin < 1 || isempty(point)
  point = fileparts(fullfile(pwd()));
end

% Get all directories
rc = wd_read_rc();

% Find matching warp directory, then remove it
idx = find(strcmp({rc.name}, point), 1, 'first');
if ~isempty(idx)
  rc(idx) = [];
else
  throw(MException('PHILIPPTEMPEL:WD:WarpPointNotFound', 'Warp point was not found'));
end

wd_save_rc(rc);


end


% function wd_show(point)
% %% WD_SHOW
% %
% % WD_SHOW()
% %
% % WD_SHOW(POINT)
% 
% 
% % WD_SHOW()
% % WD_SHOW(POINT)
% narginchk(0, 1);
% nargoutchk(0, 0);
% 
% end


function wd_list()
%% WD_LIST
%
% WD_LIST()


% Get all warp directories
rc = wd_read_rc();

% Find longest name so that each name column will be right-aligned
nlongestname = max(cellfun(@numel, {rc.name}));

% Formatting of each row with left-padded name
fstr = sprintf('%%%gs  ~>  %%s\n', nlongestname + 2);

% Start output
fprintf('* All warp points:\n');

% Loop over each directory
for iwd = 1:numel(rc)
  fprintf(fstr, rc(iwd).name, rc(iwd).path);
end


end


function wd_ls(point)
%% WD_LS
%
% WD_LS(POINT)


% WD_LS(POINT)
narginchk(1, 1);
nargoutchk(0, 0);

% Simple as that
ls(wd_path(point))


end


function p = wd_path(point)
%% WD_PATH
%
% WD_PATH(POINT)


% Get all warp directories
rc = wd_read_rc();

% Find path
idx = find(strcmpi(point, {rc.name}), 1, 'first');

if ~isempty(idx)
  p = rc(idx).path;
else
  throw(MException('PHILIPPTEMPEL:WD:WarpPointNotFound', 'Warp point was not found'));
end


end


function wd_clean()
%% WD_CLEAN
%
% WD_CLEAN()


% Load all directories
rc = wd_read_rc();

% Check which paths don't exist anymore
idx = cellfun(@(d) 7 ~= exist(d, 'dir'), {rc.path});

% And remove them, then save
rc(idx) = [];

% Save RC file
wd_save_rc(rc);


end


function ep = wd_encode_path(p)
%% WD_ENCODE_PATH
%
% EP = WD_ENCODE_PATH(P)


% Convert all machine-local separators into UNIX-style file separators
ep = strrep(p, filesep(), '/');

% On PC (windows), the path contains a colon, which we will need to strip away
if ispc()
    % Location of the first ':'
    idx_colon = find(ep == ':', 1, 'first');
    ep(idx_colon) = [];
    ep = sprintf('/%s', ep);
end


end


function p = wd_decode_path(ep)
%% WD_DECODE_PATH
%
% P = WD_DECODE_PATH(EP)


% Convert all UNIX-style file separators into machine-local separators
p = strrep(ep, '/', filesep());

% On PC (windows), restore the drive letter
if ispc()
    p(1) = [];
    idx_slash = find(p == '\', 1, 'first');
    p = [p(1:idx_slash-1) , ':', p(idx_slash:end)];
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
