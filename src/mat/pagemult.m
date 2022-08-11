function ab = pagemult(a, b)%#codegen
%% PAGEMULT Multiplies pages of two arrays
%
% AB = PAGEMULT(A, B) multiplies pages of 3D matrices A and B with each other.
% Only works for 3D matrices, for higher-dimensional matrix-matrix products, use
% MATLAB's built-in pagemtimes`.
%
% Inputs:
%
%   A                   NxMxK array.
%
%   B                   MxLxK array.
%
% Outputs:
%
%   AB                  Page-wise product of A and B i.e., product along the
%                       third dimension.
%
% See also:
%   PAGEMTIMES



%% File information
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2022-08-11
% Changelog:
%   2022-08-11
%       * Make function compatible with code generation
%   2021-11-19
%       * Initial release



%% Parse arguments

% PAGEMULT(A, B)
narginchk(2, 2);

% PAGEMULT(___)
% AB = PAGEMULT(___)
nargoutchk(0, 1);

% Page count of A and B
pa = size(a, 3);
pb = size(b, 3);

% A has less pages than B
if pa < pb
  a_ = repmat(a, [ 1 , 1 , pb ]);
  b_ = b;
  
% B has less pages then A
elseif pb < pa
  a_ = a;
  b_ = repmat(b, [ 1 , 1 , pa ]);
  
% Both A and B have the same number of pages
else
  a_ = a;
  b_ = b;
  
end

% Get whole matrix dimension for now and later
sa = size(a_, [ 1 , 2 , 3 ]);
sb = size(b_, [ 1 , 2 , 3 ]);

% Ensure both A and B have the same amount of pages
if sa(3) ~= sb(3)
  error('Arrays have incompatible sizes. For every dimension beyond the first two, the dimension sizes for both arrays must either be the same, or one of them must be 1.');
end



%% Algorithm

% Vectorized code
ab = reshape( ...
    permute( ...
        sum( ...
            repmat( ...
                a_ ...
              , [ 1 , 1 , 1 , sb(2) ] ...
            ) ...
            .* repmat( ...
                permute( ...
                    b_ ...
                  , [ 4 , 1 , 3 , 2 ] ...
                ) ...
              , sa(1) ...
              , 1 ...
            ) ...
          , 2 ...
        ) ...
      , [ 1 , 4 , 3 , 2 ] ...
    ) ...
  , sa(1) ...
  , sb(2) ...
  , [] ...
);


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original author as
% can be found in the header. Your contribution towards improving this function
% will be acknowledged in the "Changelog" section of the header.
