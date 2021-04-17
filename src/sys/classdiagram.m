function classdiagram(varargin)
%% CLASSDIAGRAM Create a class hierarchy diagram for a given package
%
% CLASSDIAGRAM(DIR1, DIR2, ..., DIRN) creates a class hierarchy diagram for
% all classes found in directories DIR1 through DIRN.
%
% CLASSDIAGRAM(CLS1, CLS2, ..., CLSN) creates a class hierarchy diagram for the
% classes given.
%
% CLASSDIAGRAM(PKG1, PKG2, ..., PKGN) creates a class hierarchy diagram for the
% classes found in the πackages given.
%
% Inputs:
%
%   DIR                 Directory to search recursively for classes.
%
%   PKG                 Package name or `meta.package` object or array of
%                       objects to extract classes and class hierarchy from.
%
%   CLS                 Class name or `meta.clas` object or array of objects to
%                       extract class hierarchy from.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-03-09
% Changelog:
%   2021-03-09
%       * Fix not finding classes when running `classdiagram` inside a package
%       directory
%       * Add support to remove MATLAB's built-in classes from the diagram e.g.,
%       those used with `matlab.mixin.Copyable` or other class mixins
%   2021-02-16
%       * Fix empty packages causing function to fail
%       * Make sure there are no duplicate classes before processing the graph.
%       Not sure, why there would be duplicate classes but, alas, it was like
%       that
%   2021-02-15
%       * Add support for passing any of directory path, `meta.class`, or
%       `meta.package`
%   2021-02-01
%       * Add support for passing multiple packages to function
%   2021-01-30
%       * Initial release



%% Parse arguments

narginchk(0, Inf);
nargoutchk(0, 0);

% CLASSDIAGRAM()
if nargin == 0
  varargin = {pwd};
end



%% Find classes and display diagram

% Find classes for all arguments
clss = cellfun(@(a) arg2classes(a), varargin, 'UniformOutput', false);

% Make one big array of `meta.class` objects
clss = vertcat(clss{:});

% Bail out if there are no classes
if numel(clss) == 0
  return
end

% Remove duplicate classes
clss = unique(clss);

% Remove all of MATLAB's own classes i.e., those in `toolbox` directory or those
% which are built-in i.e., contain `built-in` in their `which` output
cls_which = arrayfun(@(c) which(c.Name), clss, 'UniformOutput', false);
clss(contains(cls_which, 'toolbox') | contains(cls_which, 'built-in')) = [];

% Class names
clsnms = {clss.Name};

% Init adjacency matrix
adjm = zeros(numel(clss), numel(clss));

% Loop over all classes we found
for icls = 1:numel(clss)
  % Get class
  cls = clss(icls);
  % Get parent classes
  pclss = cls.SuperclassList;
  
  % Loop over parent classes
  for ipcl = 1:numel(pclss)
    pcls = pclss(ipcl);
    idxEdge = find(strcmp(pcls.Name, clsnms), 1, 'first');
    
    if ~isempty(idxEdge)
      adjm(idxEdge,icls) = 1;
    end
    
  end
  
end


% First, try plotting the graph as a biograph
try
  % Create the biograph object
  G = biograph(adjm, clsnms);
  
  % and view it
  for inode = 1:numel(G.Nodes)
    G.Nodes(inode).FontSize = 16;
  end
  
  view(G);

% That didn't work, so plot graph as a typical undirected graph
catch
  % Create the graph object
  G = digraph(transpose(adjm), clsnms);
  
  % and plot it
  hgp = plot(G, 'NodeFontSize', 16);
  layout(hgp, 'layered', 'Direction', 'up');
  
end


end



function clss = arg2classes(arg)
%% ARG2CLASSES


if isa(arg, 'char')
  mp = meta.package.fromName(arg);
  
  if ~isempty(mp)
    arg = mp;

  else
    mc = meta.class.fromName(arg);

    if ~isempty(mc)
      arg = mc;

    else
      arg = dir2classes(arg);

    end

  end
end

if isa(arg, 'meta.package')
  clss = package2classes(arg);
  
end

if isa(arg, 'meta.class')
  clss = arg;
  
end


end



function clss = dir2classes(d)
%% DIR2CLASSES


clss = meta.class.empty();

% First, find all subdirectories
sd = alldirs(d);

% From directories, we will extract packages
lopkgs = startsWith({sd.name}, '+');
pkgs = sd(lopkgs);
pldr = sd(~lopkgs);

% Turn tru subdirectories into classes
dir_clss = arrayfun(@(dd) dir2classes(fullfile(dd.folder, dd.name)), pldr, 'UniformOutput', false);
clss = vertcat(clss, dir_clss{:});

% Turn packages into classes
pkg_clss = arrayfun(@(pkg) package2classes(pkg.name), pkgs, 'UniformOutput', false);
clss = vertcat(clss, pkg_clss{:});

% Try to turn each file into a `meta.class` object
fl_clss = arrayfun(@(f) file2class(f), allfiles(d), 'UniformOutput', false);
clss = vertcat(clss, fl_clss{:});


end



function cls = file2class(f)
%% FILE2CLASS
%
% FILE2CLASS(FILE)


try
  [fd, fn, fe] = fileparts(fullfile(f.folder, f.name));
  
  % Check if there is a package name in the directory path
  if contains(fd, '+')
    fds = strsplit(fd, filesep());
    fds(~contains(fds, '+')) = [];
    pkgn = [strrep(strjoin(fds, '.'), '+', '') , '.'];
  
  % Class not contained in package
  else
    pkgn = '';
  
  end
  
  % Obtain `meta.class` object from fully qualified class name
  cls = meta.class.fromName([pkgn, fn]);
catch
  cls = meta.class.empty();
  
end


end



function clss = package2classes(mp)
%% PACKAGE2CLASSES


% Make sure the object we are dealing with is a `meta.package` object
if ~isa(mp, 'meta.package')
  if startsWith(mp, '+')
    mp = mp(2:end);
    
  end
  
  mp = meta.package.fromName(mp);
  
end

if ~isempty(mp)
  % Direct classes
  cls = mp.ClassList;

  % Classes in sub-packages
  scls = arrayfun(@(sp) package2classes(sp), vertcat(mp.PackageList), 'UniformOutput', false);

  % Merged and returned
  clss = vertcat(cls, scls{:});
else
  clss = meta.class.empty();
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
