
% -------------------------------------------------------------------------
% SIMULASI PATH
n       = 1000;         % ukuran path 
k       = 12;           % ukuran horizontal

param.b11 = 0.2049;
param.b12 = 0.0568;
param.b21 = -0.1694;
param.b22 = 0.9514;
param.COV = [6.225, -6.044; -6.044, 6.316]*10^(-3);

[Xr, Xreg] = simBellman(n,k,param);


gamma      = 5.0;     % jumlah risknya dari gamma
rf         = 0.0;     % risiko dari rate 
accuracy   = 0.01;    %ukuran step dalam numerical 

%   untuk portofolio mengembalikan 1 period horizon 

statsMy = optMyopic(Xr(:,1), gamma, rf, accuracy);


% -------------------------------------------------------------------------
% OPTIMAL BUY AND HOLD (CONSTANT PROPORTION) 

statsNH = optMyopic(sum(Xr,2), gamma, rf, accuracy);


% -------------------------------------------------------------------------
% OPTIMAL DYNAMIC PORTFOLIO

statsDY = optDynamic(Xr, Xreg, gamma, rf, accuracy);

