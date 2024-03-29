function [obj, args, nargs] = objectcheck(oc, varargin)
% OBJECTCHECK checks for an object of a calling class in the list of arguments
%
%   [OBJ, ARGS, NARGS] = OBJECTCHECK(O, ...) checks of an object of class OC in
%   the given list of variable arguments.
%
%   Inputs:
%
%   O                   MATLAB object to extract from list of arguments or class
%                       name to find inside the given list of arguments.
%
%   Outputs:
%
%   OBJ                 First object of type OC that is found, otherwise empty.
%
%   ARGS                Arguments remaining that are not of type OC.
%
%   NARGS               Number of remaining arguments not of type OC.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-02-05
% Changelog:
%   2021-02-05
%       * Allow for `meta.class` objects to be passed as `oc`.
%   2020-11-17
%       * Copy from my own personal MATLAB package to `functions` package
%       * Change author's email domain to `ls2n.fr`
%   2020-11-05
%       * Fix bug where the class object would not be returned if it wasn't the
%       first argument in `varargin`
%   2018-10-17
%       * Update to support passing an object as first argument instead of a
%       class name
%   2018-09-27
%       * Initial release



%% Valdiate arguments
try
  % OBJECTCHECK(O, ARG)
  % OBJECTCHECK(O)
  % OBJECTCHECK(O, ARG1, ...)
  narginchk(1, Inf);
  % OBJECTCHECK(...)
  % OBJ = OBJECTCHECK(...)
  % [OBJ, ARGS] = OBJECTCHECK(...)
  % [OBJ, ARGS, NARGS] = OBJECTCHECK(...)
  nargoutchk(0, 3);

  % If an object is given, we will convert it to its class name
  if isobject(oc)
    if isa(oc, 'meta.class')
      oc = oc.Name;
    else
      oc = class(oc);
    end
  end

  % Make sure the object given is a string
  validateattributes(oc, {'char'}, {'nonempty'}, mfilename, 'OC');
catch me
  throwAsCaller(me);
end



%% Do your code magic here

% Init output
args = varargin;
nargs = (nargin - 1);
obj = [];

% Do we have any arguments and is the first one already our sought fro object?
if nargs > 0 && ( isscalar(args{1}) && isa(args{1}, oc) )
  obj = args{1};
  args = args(2:end);
  nargs = nargs - 1;
end

% Process remaining arguments
if nargs > 0

  % Find where this an object matching in class
  inds = find(cellfun(@(cc) isa(cc, oc), args));

  % If there were any finds
  if ~isempty(inds)
    pind = inds(end);

    if nargs >= pind && isa(args{pind}, oc)
      obj = args{pind};
      args(inds) = [];
      nargs = length(args);
    end
  end
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
