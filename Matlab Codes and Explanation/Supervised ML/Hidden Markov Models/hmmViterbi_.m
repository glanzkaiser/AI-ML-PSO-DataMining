function [z, p] = hmmViterbi_(M, A, s)% algoritma viterbi untuk kalkukasi log scale ke stabilitas angka 
% Fungsi pembungkus yang mentransformasi input 
% Input:
%   x: 1 x n integer vector which is the sequence of observations
%   model:  model structure
% Output:
%   z: 1 x n latent state
[k,n] = size(M);
Z = zeros(k,n);
A = log(A);
M = log(M);
Z(:,1) = 1:k;
v = log(s(:))+M(:,1);
for t = 2:n
    [v,idx] = max(bsxfun(@plus,A,v),[],1);    % 13.68
    v = v(:)+M(:,t);
    Z = Z(idx,:);
    Z(:,t) = 1:k;
end
[v,idx] = max(v);
z = Z(idx,:);
p = exp(v);
