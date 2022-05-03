function varargout = git(varargin)
%% GIT
% 
% A thin MATLAB wrapper for Git.
%
% Short instructions:
% Use this exactly as you would use the OS command-line verison of Git.
%
% Long instructions:
%   This is not meant to be a comprehensive guide to the near-omnipotent
%   Git SCM: http://git-scm.com/documentation
%
% Common MATLAB workflow:
%
% Creates initial repository tracking all files under some root folder
% >> cd ~/
% >> git init
%
% Shows changes made to all files in repo (none so far)
% >> git status
%
% Create a new file and add some code
% >> edit foo.m
%
% Check repo status, after new file created
% >> git status
%
% Stage/unstage files for commit
% >> git add foo.m          % Add file to repo or to stage
% >> git reset HEAD .       % To unstage your files from current commit area
%
% Commit your changes to a new branch, with comments
% >> git commit -m 'Created new file, foo.m'
%
% Other useful commands (replace ellipses with appropriate args)
% >> git checkout ...       % To res[cmdout, statout]tore files to last commit
% >> git branch ...         % To create or move to another branch
% >> git diff ...           % See line-by-line changes
%
% Useful resources:
% 1. GitX: A visual interface for Git on the OS X client
% 2. Github.com: Remote hosting for Git repos
% 3. Git on Wikipedia: Further reading[cmdout, statout]



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% URL: https://mathworks.com/matlabcentral/fileexchange/29154-a-thin-matlab-wrapper-for-the-git-source-control-system
% Date: 2022-05-03
% Changelog:
%   2022-05-03
%       * Fix bug in stripping commands
%   2022-03-18
%       * Initial release based on FEX submission 29154



%% Parse arguments

% GIT()
% GIT(ACTION)
% GIT(ARGUMENT, ARGUMENT, ...)
narginchk(0, Inf);

% GIT(___)
% CMDOUT = GIT(___)
% [STATUS, CMDOUT] = GIT(___)
nargoutchk(0, 2);



%% Algorithm

persistent mode

if isempty(mode)
  mode = '';
end

switch lower(mode)
  case 'active'
    % We can call the real git with the arguments
    arguments = parseArguments(varargin{:});
    
    % Piping of data on UNIX systems
    if isunix()
      prog = ' | cat';
    else
      prog = '';
    end
    
    [status, result] = system([ 'git ', arguments , prog ]);
    cmdout = strtrim(result);

  case 'notfound'
    throw( ...
        MException( ...
            'GIT:RUN:NotFound' ...
          , [ ...
            'GIT was not found on your system. Please go to ' ...
            , '''https://git-scm.com'' and download and install it from there.' ...
            ] ...
        ) ...
    );
    
  otherwise
    try
      % By default, GIT was not found on the machine
      mode = 'notfound';
      
      % Run a version check command to see if GIT is installed
      [status, ~] = system('git --version');
      
      % Git command not successfully executed
      if status == 0
        
        % Find GIT on windows machines
        if ispc()
          search = { 'C:\Program Files (x86)\Git\bin' , 'c:\Program Files\Git\bin' };
          
        % Find GIT on unix machines
        else
            % Find all locations of GIT on the path
            [status, cmdout] = system('which -a git');
            
            % `WHICH` returned something
            if status == 0
              % Search locations
              search = strsplit(strtrim(cmdout), newline());
              
            % `WHICH` didn't find anything, so let's try some default paths
            else
              search = { '/usr/local/bin/git' , 'usr/bin/git' , '/bin/git' };
              
            end
            
        end
        
        % Loop through all search locations
        nsearch = numel(search);
        for isearch = 1:nsearch
          % If GIT can be found at any of the locations...
          if 2 == exist(search{isearch}, 'file')
            % Add the enclosing directory to MATLAB's path
            [gitdir, ~, ~] = fileparts(search{isearch});
            % Add directory of GIT to PATH environment
            setenv('PATH', [ gitdir , pathsep() , getenv('PATH') ]);
            % Mark mode as active
            mode = 'active';

            % And break out of loop
            break;

          end

        end
        
      % Git was found
      else
        mode = 'active';
        
      end
      
      if strcmp(mode, 'active')
        % Now, recursively call GIT so that the actual command is being executed
        [status, cmdout] = git(varargin{:});
        
      else
        status = 1;
        cmdout = 'Git not found';
        
      end
      
    catch me
      mode = 'notfound';
      
      addCause( ...
          MException( ...
              'GIT:INIT:NotFound' ...
            , [ ...
              'GIT was not found on your system. Please go to ' ...
              , '''https://git-scm.com'' and download and install it from there.' ...
              ] ...
            ) ...
        , me ...
      );
      
      rethrow(me);
      
    end
    
end

% [STATUS, CMDOUT] = GIT(___)
if nargout > 1
  varargout = {status, cmdout};
  
% CMDOUT = GIT(___)
elseif nargout == 1
  varargout = {cmdout};

% GIT(___)
else
  disp(cmdout);
  
end


end


function sdl = parseArguments(varargin)
%% PARSEARGUMENTS



sdl = strip(cell2mat(cellfun(@(s) ([char(s) ,' ']), varargin, 'UniformOutput', false)), 'right', ' ');


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
