function [gamma, alpha, beta, c] = hmmSmoother(x, model)
% HMM  (normalized forward-backward or normalized alpha-beta algorithm).
% Computing versi gamma yang tidak normal(t)=p(z_t,x_{1:T}) is numerical unstable
% Input:
%   x: 1 x n vektor integer yang berurutan dg pengamatan
%   model:  model structure
% Output:
%   gamma: k x n matrix of posterior gamma(t)=p(z_t,x_{1:T})
%   alpha: k x n matrix of posterior alpha(t)=p(z_t|x_{1:T})
%   beta: k x n matrix of posterior beta(t)=gamma(t)/alpha(t)
%   c: loglikelihood
A = model.A;
E = model.E;
s = model.s;

n = size(x,2);
d = max(x);
X = sparse(x,1:n,1,d,n);
M = E*X;
[gamma, alpha, beta, c] = hmmSmoother_(M, A, s);
