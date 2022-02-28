function options = optsset(varargin)
%% OPTSSET Set or update an options structure's Name/Value pairs
%
% OPTIONS = OPTSSET() returns an empty defaults option structure.
%
% OPTIONS = OPTSSET(Name, Value, ...) sets Name/Value pairs onto options
% structure.
%
% OPTIONS = OPTSSET(OLDOPTS, NEWOPTS) overrides options structure OLDOPTS with
% new options from NEWOPTS options structure.
%
% OPTIONS = OPTSSET(OLDOPTS, Name, Value) updates old options structure OLDOPTS
% with new Name/Value pairs options.
%
% Inputs:
%
%   OLDOPTS                 An options structure to use as base for updating its
%                           Name/Value pairs.
%
%   NEWOPTS                 An options structure with new values.
%
% Outputs:
%
%   OPTIONS                 New options structure with updated values.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-28
% Changelog:
%   2022-02-28
%       * Initial release



%% Parse arguments

% OPTSSET()
% OPTSSET(NAME, VALUE, ...)
% OPTSSET(OLDOPTS, NEWOPTS)
% OPTSSET(OLDOPTS, Name, Value, ...)
narginchk(0, Inf);

% OPTSSET(___)
% OPTIONS = OPTSSET(___)
nargoutchk(0, 1);



%% Algorithm

% OPTSSET(OLDOPTS, NEWOPTS)
if nargin == 2 && isstruct(varargin{1}) && isstruct(varargin{2})
  options = mergestructs(varargin{1}, varargin{2});

% OPTSSET(OLDOPTS, NAME, VALUE, ...)
elseif nargin > 2 && isstruct(varargin{1})
  options = mergestructs(varargin{1}, struct(varargin{2:end}));

% OPTSSET(NAME, VALUE, ...)
else
  options = struct(varargin{:});
  
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
