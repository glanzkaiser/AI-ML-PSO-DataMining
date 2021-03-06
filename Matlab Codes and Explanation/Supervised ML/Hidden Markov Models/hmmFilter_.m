function [alpha, energy] = hmmFilter_(M, A, s)
% Fungsi implementasi dari HMM 
% Input:
%   M: k x n emmision data matrix M=E*X
%   A: k x k transition matrix
%   s: k x 1 starting probability (prior)
% Output:
%   alpha: k x n matriks dari posterior alpha(t)=p(z_t|x_{1:t})
%   enery: loglikelihood
[K,T] = size(M);
At = A';
energy = zeros(1,T);
alpha = zeros(K,T);
[alpha(:,1),energy(1)] = normalize(s.*M(:,1),1);
for t = 2:T
    [alpha(:,t),energy(t)] = normalize((At*alpha(:,t-1)).*M(:,t),1);    % 13.59
end
energy = sum(log(energy(energy>0)));