function c = color(varargin)
%% COLOR Create a color RGB triplet from a human readable name
%
% C = COLOR(NAME)
%
% C = COLOR(NAME_1, NAME_2, ...)
%
% Inputs:
%
%   NAME                Name of the color to convert into RGB
%
% Outputs:
%
%   C                   Nx3 array of RGB triplets.



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-02-26
% Changelog:
%   2021-02-26
%       * Initial release



%% Parse arguments

% COLOR(NAME)
% COLOR(NAME, ...)
narginchk(1, Inf);
% COLOR(___)
% C = COLOR(___)
nargoutchk(0, 1);



%% Do your code magic here

% Registered color names
colors = [ ...
  {'black'},       {[0.000, 0.000, 0.000]} ; ...
  {'blue'},        {[0.000, 0.000, 1.000]} ; ...
  {'cyan'},        {[0.000, 1.000, 1.000]} ; ...
  {'fuelyellow'},  {[0.929, 0.694, 0.125]} ; ...
  {'gray'},        {[0.500, 0.500, 0.500]} ; ...
  {'green'},       {[0.000, 1.000, 0.000]} ; ...
  {'lochmara'},    {[0.000, 0.447, 0.741]} ; ...
  {'magenta'},     {[1.000, 0.000, 1.000]} ; ...
  {'orange'},      {[0.850, 0.325, 0.098]} ; ...
  {'pictonblue'},  {[0.301, 0.745, 0.933]} ; ...
  {'red'},         {[1.000, 0.000, 0.000]} ; ...
  {'sushi'},       {[0.456, 0.674, 0.188]} ; ...
  {'tamarillo'},   {[0.635, 0.078, 0.184]} ; ...
  {'violet'},      {[0.494, 0.184, 0.556]} ; ...
  {'white'},       {[1.000, 1.000, 1.000]} ; ...
  {'yellow'},      {[1.000, 1.000, 0.000]} ; ...
];

% Extract RGB triplet for each color name match in `varargin`
try
  matches = cellfun(@(m) colors(m,2), cellfun(@(n) strcmpi(n, colors(:,1)), varargin, 'UniformOutput', false), 'UniformOutput', false);
  
catch me
  throwAsCaller(me);
  
end

% Some colors were not found?
if ~all(cellfun(@isempty, matches))
  error('invalid color name `%s`', varargin{find(cellfun(@isempty, matches), 1)});
  
end

% Turn into an Nx3 array
c = vertcat(matches{:});


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header
