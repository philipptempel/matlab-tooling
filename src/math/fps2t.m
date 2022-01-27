function t = fps2t(fps, t0, tf)%#codegen
%% FPS2T Turn an FPS into a time vector
%
% T = FPS2T(FPS, TF) creates a time-space vector on interval TI = [ 0 , TF ] for
% a frames-per-second rate FPS.
%
% T = FPS2T(FPS, T0, TF) creates a time span vector on interval IT = [T0 , TF].
%
% Inputs:
%
%   FPS                     Number of frames per second.
%
% Outputs:
%
%   T                       Time vector T.
%
% See also:
%   TIMESPACE



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-01-27
% Changelog:
%   2022-01-27
%       * Initial release



%% Parse arguments

% FPS2T(FPS, TF)
% FPS2T(FPS, T0, TF)
narginchk(2, 3);

% FPS2T(___)
% T = FPS2T(___)
nargoutchk(0, 1);

% FPS2T(FPS, TF)
if nargin < 3 || isempty(tf)
  tf = t0;
  t0 = 0;
end



%% Algorithm

% Just dispatching to `TIMESPACE` with the proper arguments
t = timespace(t0, tf, 1 / max(1, round(fps)));


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
