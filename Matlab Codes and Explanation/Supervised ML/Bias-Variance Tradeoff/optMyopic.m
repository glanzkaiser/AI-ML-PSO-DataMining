function stats = optMyopic(returns, gamma, rf, accuracy)
%OPTMYOPIC: kalkulasikan bobot optimal atau strategy buy and hold
%
%   -   A tradeoff dibuat untuk 'returns' dan risk free rate 'rf' 
% 	-   Input berisi hanya yang terstimulasi
%   -   Bobot dibatasi dari 0 - 1
%
%   STATS = OPTMYOPIC(returns, 'gamma', ...) memungkinkan ditentukan
%   sendiri
%       'gamma'   :     risk-aversion constant, initially set to 5.
%
%   STATS = OPTMYOPIC(returns, gamma, 'rf', ...) memungkinkan menentukan sendiri
% risk aversion parameter 'gamma'.
%   risk free rate, relevant for your optimization problem.
%       'rf'      :     the risk free rate constant, initial set to 0.
%
%   STATS = OPTMYOPIC(returns, gamma, rf, 'accuracy') memungkinkan
%   menentukan sendiri memperpanjang
%   the accuracy of the grid, initially set to 0.01.
%       'accuracy':     the single step length in the grid
%
%   STATS = OPTMYOPIC(...) returns the structure 'stats' consisting of:
%       'stats.optWeight'   :  the optimal portfolio weight (in risky asset)
%       'stats.optCU'       :  optimal conditional expectation

[n, m] = size(returns);
if m >= n,  error('optMyopic:InvalidInput','The number of rows should be sufficiently larger than the number of columns'); end
if m > 1,   error('optMyopic:InvalidInput','The input should consist only of one column. Note: to calculate the portfolio weights using the Buy-and-Hold strategy, use cumulative returns over the past k periods instead.'); end

if nargin < 1, error('optMyopic:InsufficientParameters','Input variable is necessary'); end
if nargin < 2, gamma = 5; end   % default risk aversion
if nargin < 3, rf = 0; end      % default risk free rate
if nargin < 4, accuracy = 0.01; end 

% One-dimensional grid
grid = 0.00:accuracy:1.00;

% init
U = zeros(n,size(grid,2));
CU = zeros(1,size(grid,2));
CUopt = -10^(9);
gridopt = 0;

% -------------------------------------------------------------------------

% bobot portofolio 
wIter = 1;
for w = grid
   
   % define the realized utility value for all i = 1,...,n
   U(:,wIter) = (1/(1-gamma)) * ( w*exp( returns ) + (1-w)*exp( rf ) ).^(1-gamma);
   
   % perkiraan kondisi
   CU(wIter) = (1/n)*sum( U(:,wIter) );
   
   % update
   if CU(wIter) > CUopt
       CUopt = CU(wIter);
       gridopt = w;
   end
   
   wIter = wIter + 1;
   
end

stats.optWeight = gridopt;
stats.optCU = CUopt;
