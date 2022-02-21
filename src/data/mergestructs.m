function s = mergestructs(varargin)%#codegen
%% MERGESTRUCTS merges multiple structs into one
%
% S = MERGESTRUCTS(S1, S2, ...) merges S2 and succeeding structs into S1. Values
% of later structures overwrite values of preceding structures.
%
% Inputs:
%
%   S1                  Base struct that shall be merged into.
%
%   S2                  Structure array that shall be merged into S1.
%
% Outputs:
%
%   S                   Structure array merge of all other structures from S1 to
%                       SN.



%% File information
% Author: Philipp Tempel <matlab@philipptempel.me>
% Date: 2022-02-21
% Changelog:
%   2022-02-21
%       * Add codegen directive
%       * Add support to recursively merge structures
%   2021-12-14
%       * Update email address of Philipp Tempel
%   2021-11-25
%       * Correct H1 format
%   2017-03-18
%       * Allow all structs to be empty
%   2016-09-21
%       * Initial release



%% Assert arguments

% MERGESTRUCTS(S1, ...)
narginchk(1, Inf);

% MERGESTRUCTS(S1, ...)
% S = MERGESTRUCTS(S1, ...)
nargoutchk(0, 1);

% All arguments must be struct
assert(all(cellfun(@(x) isstruct(x), varargin)), 'PHILIPPTEMPEL:MATLAB_TOOLING:MERGESTRUCTS:InvalidType', 'All arguments must be struct');



%% Algorithm

% Get the base struct
s = varargin{1};

% Get all other structs
os = varargin(2:end);

% Loop over other structs
for iS = 1:numel(os)
    fns = fieldnames(os{iS});
    
    % Loop over all fieldnames
    for iFn = 1:numel(fns)
        % Field name
        fn = fns{iFn};
        
        % If field is a structure, merge it recursively
        if isstruct(os{iS}.(fn))
            if ~isfield(s, fn)
                s.(fn) = os{iS}.(fn);
            else
                s.(fn) = mergestructs(s.(fn), os{iS}.(fn));
            end
        else
            s.(fn) = os{iS}.(fn);
        end
    end
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changes" section of the header.
