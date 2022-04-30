function [Xr, Xreg] = simBellman(n,k,param)

Xr      = zeros(n, k+1);
Xreg    = zeros(n, k+1);

% set beberapa arbitraty start values
Xreg(:,1)       = repmat(-3.4596,   1,  n);
Xr(:,1)         = repmat(-3.4596,   1,  n);

for i = 1:n
    for j = 2:k+1
    eT = mvnrnd([0 0], param.COV );
    Xr(i,j)         = param.b11 + param.b12*Xreg(i,j-1) + eT(1);
    Xreg(i,j)       = param.b21 + param.b22*Xreg(i,j-1) + eT(2);
    end
end
Xr(:,1)=[];
Xreg(:,1) = [];