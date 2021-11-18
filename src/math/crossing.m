function [ind,t0,s0,t0close,s0close] = crossing(S,t,level,imeth)
%% CROSSING find the crossings of a given level of a signal
%
% IND = CROSSING(S) returns an index vector IND, the signal S crosses zero at
% IND or at between IND and IND + 1.
%
% [IND, T0] = CROSSING(S, T) additionally returns a time vector T0 of the zero
% crossings of the signal S. The crossing times are linearly interpolated
% between the given times T.
%
% [IND, T0] = CROSSING(S, T, LEVEL) returns the crossings of the given level
% instead of the zero crossings IND = CROSSING(S, [], LEVEL) as above but
% without time interpolation
%
% [IND, T0] = CROSSING(S, T, LEVEL, PAR) allows additional definition of the
% interpolation method. With interpolation turned off (par = 'none') this
% function always returns the value left of the zero (the data point thats
% nearest to the zero AND smaller than the zero crossing).
%
%	[IND, T0, S0 ] = CROSSING(___) also returns the data vector corresponding to
%	the T0 values.
%
%	[IND, T0, S0, T0CLOSE, S0CLOSE] = CROSSING(___) additionally returns the data
%	points closest to a zero crossing in the arrays T0CLOSE and S0CLOSE.
%
%	This version has been revised incorporating the good and valuable bugfixes
%	given by users on Matlabcentral. Special thanks to Howard Fishman, Christian
%	Rothleitner, Jonathan Kellogg, and Zach Lewis for their input.



%% File information
% Author: Steffen Brueckner <brueckner@sbrs.net>
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format
%   2007-08-27
%       * Revised version
%   2002-09-25
%       * Initial release


% check the number of input arguments
narginchk(1, 4);

% check the time vector input for consistency
if nargin < 2 || isempty(t)
	% if no time vector is given, use the index vector as time
    t = 1:length(S);
elseif length(t) ~= length(S)
	% if S and t are not of the same length, throw an error
    error('t and S must be of identical length!');    
end

% check the level input
if nargin < 3 || isempty(level)
	% set standard value 0, if level is not given
    level = 0;
end

% check interpolation method input
if nargin < 4 || isempty(imeth)
    imeth = 'linear';
end

% make row vectors
t = t(:).';
S = S(:).';

% always search for zeros. So if we want the crossing of 
% any other threshold value "level", we subtract it from
% the values and search for zeros.
S = S - level;

% first look for exact zeros
ind0 = find( S == 0 ); 

% then look for zero crossings between data points
S1 = S(1:end-1) .* S(2:end);
ind1 = find( S1 < 0 );

% bring exact zeros and "in-between" zeros together 
ind = sort([ind0 ind1]);

% and pick the associated time values
t0 = t(ind); 
s0 = S(ind);

if strcmp(imeth,'linear')
    % linear interpolation of crossing
    nt0 = length(t0);
    for ii = 1:nt0
        if abs( S(ind(ii)) ) > eps( S(ind(ii)) )
            % interpolate only when data point is not already zero
            NUM = ( t(ind(ii) + 1 ) - t(ind(ii)));
            DEN = ( S(ind(ii) + 1 ) - S(ind(ii)));
            DELTA =  NUM / DEN;
            t0(ii) = t0(ii) - S(ind(ii)) * DELTA;
            % I'm a bad person, so I simply set the value to zero
            % instead of calculating the perfect number ;)
            s0(ii) = 0;
        end
    end
end

% Addition:
% Some people like to get the data points closest to the zero crossing,
% so we return these as well
[~, II] = min(abs([ S(ind-1) ; S(ind) ; S(ind+1) ]), [], 1); 
ind2 = ind + (II - 2); %update indices 

t0close = t(ind2);
s0close = S(ind2);


end
