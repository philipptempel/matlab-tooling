function rs = randstr(len)
%% RANDSTR Create a random text string
%
% RS = RANDSTR() creates a random string of length 10.
%
% RS = RANDSTR(LEN) creates a random string of length LEN.
%
% Inputs:
%
%   LEN                     Desired length of string.
%
% Outputs:
%
%   RS                      Description of argument RS



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-02-28
% Changelog:
%   2022-02-28
%       * Initial release



%% Parse arguments

% RANDSTR()
% RANDSTR(L)
narginchk(0, 1);

% RANDSTR(___)
% RS = RANDSTR(___)
nargoutchk(0, 1);

% RANDSTR()
if nargin < 1 || isempty(len)
  len = 10;
end



%% Algorithm

% Allowed characters [a-zA-Z] from ASCII table
% @see https://www.asciitable.com
dec = [ 97:122 , 65:90 ];

% Extract random numbers from array of decimals and convert to char
rs = char(dec(randi(52, [1, len])));



end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
