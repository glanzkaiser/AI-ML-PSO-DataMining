function z = hmmViterbi(x, model)
% algoritma viterbi untuk kalkukasi log scale ke stabilitas angka 
% Fungsi pembungkus yang mentransformasi input 
% Input:
%   x: 1 x n integer vector which is the sequence of observations
%   model:  model structure
% Output:
%   z: 1 x n latent state
A = model.A;
E = model.E;
s = model.s;

n = size(x,2);
d = max(x);
X = sparse(x,1:n,1,d,n);
M = E*X;
z = hmmViterbi_(M, A, s);
