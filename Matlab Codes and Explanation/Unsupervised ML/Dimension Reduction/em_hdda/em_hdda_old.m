function [cls,T] = em_hdda(XX,k,varargin);
% Classification of High Dimensionality Data using EM algorithm
%
% Usage: (1) [cls,PE] = em_hdda(X,k);
%        (2) [cls,PE] = em_hdda(X,k,'maxiter',100,'common','abqd');
%       
% Input: 
%       - X: data
%       - common: '', 'a', 'b', 'd', 'ab', 'ad', 'bd', 'abd', 'abqd'
%                 'alpha', 'alphad', 'sigma', 'sigmad' and 'alphaqd'
%
% Output:
%       - cls: label of test data Y.data,
%       - PE: Classification error probability 
%
% Authors: C. Bouveyron <charles.bouveyron@inrialpes.fr> - 2004
% 
% Reference: C. Bouveyron, S. Girard and C. Schmid, "High Dimensional Discriminant Analysis",
%            Inria Research Report, December 2004.
%
% Required function:lbl2cell, clustermeans

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZATION OF PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(XX), X = XX.data; class = XX.cls;
else X = XX; class = []; end

[N,p] = size(X);
diff = 1e-6; maxiter = 100;
common = []; init = [];
seuils = [0.50:0.05:0.99]; seuil = 0.9;
dims = []; dim = [];

%%% PARAMETERS MANAGEMENT
for i=1:2:length(varargin)
    if ~isstr(varargin{i}) | ~exist(varargin{i},'var')
        error(['Invalid parameter ' varargin{i}]);
    end
    eval([varargin{i} '= varargin{i+1};']);
end
%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EM algorithm for HD data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%% INITIALIZATION OF THE DENSITIES %%%%%%%

% Initailization using kmeans (the StatLearn toolbox is required !)
[m,cls] = kmeanslight(X,k);
if ~isempty(init), cls = init; end

% EM step 0
T = zeros(N,k); 
for i=1:k, T(cls==i,i) = 1; end
%epsilon = 0.1; T = zeros(N,k) + epsilon/(k-1); 
%for i=1:k, T(cls==i,i) = 1-epsilon; end

S = compute_params(X,k,N,p,T,seuils,common,dims);


%%%%%%% MAIN LOOP OF EM %%%%%%%

for it = 1:maxiter %beginning of the loop
    
    %%%% E STEP %%%%
    %T = exp(-0.5 * S) ./ repmat(sum(exp(-0.5*S),2),1,k);
    for i=1:k, T(:,i) = 1 ./ sum( exp(-0.5*(S-repmat(S(:,i),1,k))) ,2)'; end
    
    %%%% S STEP %%%%
    %T = s_step(T); 

    %%%% M STEP %%%%
    S = compute_params(X,k,N,p,T,seuils,common,dims);
    
    %%%% Calcul de Q %%%%
    Q(it) = - 0.5 *sum(sum(T.*S,2),1);
    
    [val,cls] = max(T,[],2);
    %hist(cls);pause;
    if ~isempty(class), tx(it) = em_eval(class,cls,k); end
    
    %%%% Check for early stoping %%%%
    if (it>1 & abs(Q(it)-Q(it-1))<diff*abs(Q(it)))
        %T = T_old;
        break;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAY of RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(Q,'-o'); 
if ~isempty(class), figure, plot(tx,'-o'); end
[val,cls] = max(T,[],2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           SUB-FUNCTION                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S = compute_params(data,k,N,p,T,seuils,common,dims);

if ~isempty(dims), ss = length(dims); common = 'd';
else ss = length(seuils); end

for s=1:ss  % for all s in seuils
    
    if ~isempty(dims), dim = dims(s);
    else seuil = seuils(s); end
    
    %%%%%%%%%%% Compute intrinsec dimension and others %%%%%%%%%%%
    for i=1:k
        % Compute the class proportion
        n(i) = sum(T(:,i));
        prop(i) = n(i) / N;
        m(i,:) = sum(repmat(T(:,i),1,p).*data) / n(i);

        % Estimator of Sigma_i
        Sigma{i} = zeros(p,p);
        for j=1:N, 
            Sigma{i} = Sigma{i} + T(j,i)*(data(j,:)-m(i,:))'*(data(j,:)-m(i,:))/ n(i);
        end
        Tr(i) = trace(Sigma{i});
        
        % Find the intrinsec dimension of the eigenspace Ei
        LL = eig(Sigma{i}); 
        LL = sort(LL,'descend'); 
        L(i,:) = LL; % ordered eigenvalues
        %subplot(1,k,i), bar(LL);
        total_var = sum(LL);
        ex = cumsum(LL / total_var);
        if isempty(strfind(common,'d'))
            d(i) = 1;
            for j=1:length(ex),
                if (ex(j)<= seuil), d(i) = j; end
            end
        else d(i) = dim; end

        % Clear local variables
        clear LL ex total_var;
        
        % d_i eigenvectors
        opt.disp = 0;
        [V{i},LL] = eigs(Sigma{i},d(i),'LM',opt);  
    end

    %%%%%%%%%%%%%%%%%%%% Compute estimators %%%%%%%%%%%%%%%%%%%%

    %  Model [a_i b_i q_i] (HDDA)
    if isempty(common) | isequal(common,'d')
        for i=1:k
            a(i) = sum(L(i,1:d(i)),2) / d(i);
            b(i) = (Tr(i) - sum(L(i,1:d(i)),2)) / (p-d(i));
        end
    end
    %disp(a), disp(b), disp(prop), %pause

    %%%%%%%%%%%%%%%%%%%%% Cost function computing %%%%%%%%%%%%%%%%%%%%
    for i=1:k
        % Projection of test data in the eigenspace Ei
        W{i} = zeros(p); W{i}(:,1:d(i)) = V{i};
        [nt,pt] = size(data);
        P = (data - repmat(m(i,:),nt,1)) * W{i} * W{i}'  + repmat(m(i,:),nt,1);

        % Compute Ki (Cost function)
        if isempty(strfind(common,'alpha')) & isempty(strfind(common,'sigma'))
            S(:,i) = (1/a(i) * sum((repmat(m(i,:),nt,1) - P).^2,2) ) ...
                + (1/b(i) * sum((data - P).^2,2)) ...
                + d(i) * log(a(i)) + (p-d(i)) * log(b(i)) ...
                - 2 * log(prop(i));
        else
            S(:,i) = ( alpha(i) *   sum((repmat(m(i,:),nt,1) - P).^2,2)...
                + (1-alpha(i)) * sum((data - P).^2,2) ) / sigma(i) ...
                + 2*p*log(sigma(i)) + d(i)*log((1-alpha(i))/alpha(i)) - p*log(1-alpha(i))...
                - 2 * log(prop(i));
        end
    end

    %%%%%%%%%%%%%%%%%%%%%% Classification step %%%%%%%%%%%%%%%%%%%
    SS{s} = S;
    Q(s) = - 0.5 *sum(sum(T.*S,2),1);
end
%plot(Q,'-o'), pause

% recherche du s opt
[val,ind]=max(Q);
S = SS{ind};

if ~isempty(dims), fprintf('Dimension choisie : %g \n',dims(ind));
else fprintf('Seuil choisi : %g \n',seuils(ind)); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       END of SUB-FUNCTION                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TT = s_step(T)
%
[n,k] = size(T);
R = rand(n,1);
TT = zeros(n,k);
P = cumsum(T,2);
P = [zeros(n,1),P];
for i=1:n
    for j=2:k+1
        if R(i)>=P(i,j-1) & R(i)<P(i,j), TT(i,j-1)=1; end
    end
end