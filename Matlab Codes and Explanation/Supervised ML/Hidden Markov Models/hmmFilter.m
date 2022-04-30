function [alpha, energy] = hmmFilter(x, model)
% algortima HMM forward filtering. % the alpha mengembalikan versi normal alpha(t)=p(z_t|x_{1:t})
% komputasi versi alpha yang tidak normal alpha(t)=p(z_t,x_{1:t})
% Input:
%   x: 1 x n integer vector yang berurutan dg pengamatan
%   model:  model structure
% Output:
%   alpha: k x n matrix of posterior alpha(t)=p(z_t|x_{1:t})
%   enery: loglikelihood
A = model.A;
E = model.E;
s = model.s;

n = size(x,2);
d = max(x);
X = sparse(x,1:n,1,d,n);
M = E*X;
[alpha, energy] = hmmFilter_(M, A, s);