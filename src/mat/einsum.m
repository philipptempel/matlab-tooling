function C = einsum(A, B, iA, iB)
%% EINSUM Calculate tensor contraction
%
% Efficiently calculates tensor contraction in any dimension. It uses matlab's
% matrix multiplication so parallelized and optimized. The Einstein summation is
% inspired by NumPy's syntax, but is not identical.
%
% EINSUM(A, B, S) calculates the contraction of A and B which are n-dimensional
% tensors with contraction specified by string S in Einstein notation
%
% EINSUM(A, B, IA, IB) calculates the contraction of A and B which are
% n-dimensional tensors with contraction specified by vectors IA and IB which
% list the indices to contract on for each tensor.
%
% Using the iA, iB it is not possible to specify the order of dimensions in the
% output, they're just in the same order as the inputm with the contracted
% dimensions omitted.
%
% Examples:
% 
% To contract the 1st dimension of A with the 2nd dimension of B, use
%   A = rand(7, 4, 5);
%   B = rand(5, 7);
%   einsum(A, B, 'ijk,li->jkl')
%   einsum(A, B, 1, 2)
%   
% The result will be of size [4,5,5]. 
%
% To contract the 3rd dimension of A with the 1st dimension of B, use
%   A = rand(7, 4, 5);
%   B = rand(5, 7);
%   einsum(A, B, 'ijk,kl->ijl')
%   einsum(A, B, 3, 1)
%
% The result will be of size [7,4,7]. 
%
% To do both contractions at once, use
%   A = rand(7, 4, 5);
%   B = rand(5, 7);
%   einsum(A,B,'ijk,ki->j')
%   einsum(A, B, [1 3], [2 1])



%% File information
% Author: Yohai Bar-Sinai
% Author: Philipp Tempel <philipp.tempel@ls2n.fr>
% Date: 2021-11-17
% Changelog:
%   2021-11-17
%       * Update H1 to correct format



%% Algorithm

sA = size(A);
sB = size(B);
if nargin == 3
    [iA, iB, final_permutation] = parse(iA, sA, sB);
else
    final_permutation=false;
end
if size(iA)~=size(iB)
    error('number of dimensions to contract should be equal')
end
for i=1:length(iA)
    if size(A,iA(i))~=size(B,iB(i))
        error(['cannot contract dimension %d of 1st argument (length=%d)'...
            ' with dimension %d of 2nd argument (length=%d)'],...
            iA(i),size(A,iA(i)),iB(i),size(B,iB(i)))
    end
end
if length(iA)~=length(unique(iA)) || length(iB)~=length(unique(iB))
    error('each dimension should appear only once.')
end
dimsA=setdiff(1:ndims(A),iA);
dimsB=setdiff(1:ndims(B),iB);
A=permute(A, [dimsA iA]);
B=permute(B, [iB dimsB]);
A=reshape(A, [], prod(sA(iA)));
B=reshape(B, prod(sB(iB)), []);
C=A*B;
output_shape=[sA(dimsA),sB(dimsB)];
if length(output_shape)>1
    C=reshape(C,[sA(dimsA),sB(dimsB)]);
    if final_permutation
        C=permute(C,final_permutation);
    end
end
end
function [iA, iB, final_permutation]=parse(s, sA, sB)
msg='argument should be a string of the form ''ijk,kjl->il''';
if ~ischar(s)
    error(msg)
end
%assert that every index appear exactly twice
ss=join(split(s,{',','->'}));
ss=ss{1};
for i=1:length(ss)
    if length(find(ss==ss(i)))~=2
        error(['problem with index %s. '...
               'Each index should appear exactly twice'], ss(i))
    end
end
%split input and output indices
s=split(s,'->');
if length(s)~=2 
    error(msg)
end
%split input indices
in=s{1};
out=s{2};
in=split(in,',');
if length(in)~=2
    error(msg)
end
inA=in{1};
inB=in{2};
if length(inA)~=length(sA)
    error(['''%s'' has %d dimensions while the '...
        'first argument has %d'],inA, length(inA), length(sA))
end
if length(inB)~=length(sB)
    error(['''%s'' has %d dimensions while the '...
        'second argument has %d'],inB, length(inB), length(sB))
end
if length(unique(inA))~=length(inA)
    error('''%s'' has a double index',inA)
end
if length(unique(inB))~=length(inB)
    error('''%s'' has a double index',inB)
end
if length(unique(out))~=length(out)
    error('''%s'' has a double index',out)
end
final_permutation=[];
iA=[];
iB=[];
for i=1:length(inA)
    j=find(inB==inA(i));
    if isempty(j)   % i is an output index
        j=find(out==inA(i));
        final_permutation(end+1)=j;%#ok<AGROW>
    else            % i is contracted
        iA(end+1)=i; %#ok<AGROW>
        iB(end+1)=j; %#ok<AGROW>
    end
end
for i=1:length(inB)
    j=find(inB(i)==out);
    if ~isempty(j)   % i is an output index
        final_permutation(end+1)=j;%#ok<AGROW>
    end
end
[~, final_permutation]=sort(final_permutation);
end
