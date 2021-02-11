function classdiagram(varargin)
%% CLASSDIAGRAM Create a class hierarchy diagram for a given package
%
% CLASSDIAGRAM(PKG1, PKG2, ..., PKGN) creates a class hierarchy diagram for
% pacakges PKG1, PKG2, ... PKGN.
%
% Inputs:
%
%   PKG                 Package name or `meta.package` object.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-02-01
% Changelog:
%   2021-02-01
%       * Add support for passing multiple packages to function
%   2021-01-30
%       * Initial release



%% Do your code magic here


% Resolve the package and all its sub-packages
mp = cellfun(@(p) meta.package.fromName(p), varargin);
% mp = meta.package.fromName(pkg);

% Get all classes in this package and sub-packages
clss = all_classes(mp);

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



function clss = all_classes(mp)
%% ALL_CLASSES


% Make sure the object we are dealing with is a `meta.package` object
if ~isa(mp, 'meta.package')
  mp = meta.package.fromName(mp);
end

% Direct classes
cls = mp.ClassList;

% Classes in sub-packages
scls = arrayfun(@(sp) all_classes(sp), vertcat(mp.PackageList), 'UniformOutput', false);

% Merged and returned
clss = vertcat(cls, scls{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
