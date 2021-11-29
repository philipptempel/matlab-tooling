function oldpath = rmpath(varargin)
%% RMPATH A wrapper around built-in RMPATH to accept multiple paths to remove
%
% RMPATH(FOLDERNAME1, ... FOLDERNAMEN) removes the specified folders from
% MATLAB's search path.
%
% OLDPATH = RMPATH(___) removes MATLAB's old search path before removing the
% folders.
%
% Inputs:
%
%   FOLDERNAME          Name of folder to remove from MATLAB's search path.
%
% Outputs:
%
%   OLDPATH             MATLAB's old search path before removing all given
%                       folders.
%
% See also:
%   RMPATH



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-29
% Changelog:
%   2021-11-29
%       * Fix to support case where `VARARGIN` contains more than one path
%       * Update H1 documentation
%       * Add single output argument `OLDPATH`
%   2021-11-05
%       * Initial release



%% Parse arguments

% RMPATH(FOLDERNAME)
% RMPATH(FOLDERNAME1, ..., FOLDERNAMEN)
narginchk(1, Inf);

% RMPATH(___)
% OLDPATH = RMPATH(___)
nargoutchk(0, 1);

% Default first output argument
if nargout > 0
  oldpath = path();
end



%% Algorithm

% Get function handle to the shadowed `RMPATH` function
rmpath_ = shadowed('rmpath');

% And run the built-in function with all arguments
cellfun(@(c) rmpath_(c), varargin);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
