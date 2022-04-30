function stats = optDynamic(returns, predictors, gamma, rf, accuracy)
%OPTDYNAMIC: kalkulasi bobot optimal selama strategi dinamik
%
%   STATS = OPTDYNAMIC(returns, predictors, ...) uses both predictor
%   variables and returns to calculate the optimal portfolio. If possible,
%   the conditional expectation is approximated by accross-path sample
%   means which is done in the very last step of the algorithm. As this is
%   not always feasible, different paths have different (simulated)
%   predictor variables, the approximation of such conditional expectations
%   are done by accross-path OLS regressions.
%
[n1, K1] = size(returns);
[n2, K2] = size(predictors);
if n1 ~= n2 || K1 ~= K2, error('optMyopic:InvalidInput', 'The dimensions of the returns are not equal to the dimensions of the predictors'); end
if K1 >= n1,  error('optMyopic:InvalidInput','The number of rows should be sufficiently larger than the number of columns'); end
if nargin < 2, error('optMyopic:InsufficientParameters','Both predictors and returns are necessary in the dynamic portfolio selection.'); end
if nargin < 3, gamma = 5; end   % risiko default
if nargin < 4, rf = 0; end      % risiko free rate
if nargin < 5, accuracy = 0.01; end

% One-dimensional
grid = 0.00:accuracy:1.00;

% init
n = n1;
K = K1;
Ufut    = ones(n,1);                    % utility
U       = zeros(n,size(grid,2));        % utility
CU      = zeros(n,size(grid,2));        % kondisi terhadap ekspetasi bobot

% -------------------------------------------------------------------------
% Inisialisasi 
% start dalam period (T+) K-1
for tIter = 1:K
    
    t = K-tIter;
    
    % reset dari nilai 
    OptU    = ones(n,1)*(-10^9);        % utility optimal
    PortW   = zeros(n,1);               % bobot optimal
    
    wIter = 1;
    for w = grid
        
        % definiskan utilitas dari semua bagian i = 1,...,n
        U(:,wIter) = (1/(1-gamma))*(    (   w*exp( returns(:,t+1) ) + (1-w)*exp( rf )   ).^(1-gamma)    ).*Ufut;
        
        % menurunkan nilai utilitas secara konstan
        if t == 0
            Xtemp = ones(n,1);
            Ytemp = U(:,wIter);
            beta = (Xtemp'*Xtemp)\(Xtemp'*Ytemp);
            CU(:,wIter) = ones(n,1)*beta;
        else
            Xtemp = [ones(n,1), predictors(:,t)];
            Ytemp = U(:,wIter);
            beta = (Xtemp'*Xtemp)\(Xtemp'*Ytemp);
            CU(:,wIter) = [ones(n,1), predictors(:,t)]*beta;
        end
        
        % update conditions
        bin = CU(:,wIter) > OptU;
        OptU(bin) = CU(bin,wIter);
        PortW(bin) = repmat(w,sum(bin),1);
        
        %--
        wIter = wIter+1;
    end
    
    % update vektor lain
    Ufut = Ufut.*( PortW.*exp( returns(:,t+1) ) + (1-PortW).*exp( rf ) ).^(1-gamma);
    
end

stats.optWeight = PortW(1); %dalam last step bobot optimal utk semua path 
