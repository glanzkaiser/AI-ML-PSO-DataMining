function [cls,T,S,d] = em_hdda(XX,k,varargin);
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
%       - cls: label test data Y.data,
%       - PE: Classification error probabilitas
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inisialisasi parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(XX), X = XX.data; class = XX.cls;
else X = XX; class = []; end

[N,p] = size(X);
diff = 1e-6; maxiter = 30;
common = []; init = [];
dims = []; dim = [];
seuil = 1e-2;
display = 1;

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


%%%%%%% Inisialisasi densitas %%%%%%%

% Inisialisasi dg kmeans (the StatLearn toolbox is required !)
%[m,cls] = kmeanslight(X,k);
cls = randsample(k,N,1);
if ~isempty(init), cls = init; end

% EM step 0
T = zeros(N,k); 
for i=1:k, T(cls==i,i) = 1; end
%epsilon = 0.1; T = zeros(N,k) + epsilon/(k-1); 
%for i=1:k, T(cls==i,i) = 1-epsilon; end

S = compute_params(X,k,N,p,T,seuil,common,dims);
if display & ~isempty(class), tx(1) = em_eval(class,cls,k,'disp',1); end

for it = 1:maxiter %loop awal
    
    %%%% E STEP %%%%
    %T = exp(-0.5 * S) ./ repmat(sum(exp(-0.5*S),2),1,k);
    for i=1:k, T(:,i) = 1 ./ sum( exp(-0.5*(S-repmat(S(:,i),1,k))) ,2)'; end
    
    %%%% S STEP %%%%
    %T = s_step(T); 

    %%%% M STEP %%%%
    [S,d] = compute_params(X,k,N,p,T,seuil,common,dims);
    
    %%%% hitung de Q %%%%
    Q(it) = - 0.5 *sum(sum(T.*S,2),1);
    
    [val,cls] = max(T,[],2);
    %hist(cls);pause;
    if display & ~isempty(class), tx(it+1) = em_eval(class,cls,k,'disp',1); end
    
    %%%% Check %%%%
    if (it>1 & abs(Q(it)-Q(it-1))<diff*abs(Q(it)))
        %T = T_old;
        break;
    end
end
%hasil
if display, plot(Q,'-o'); 
if ~isempty(class), figure, plot(tx,'-o'); end
end
[val,cls] = max(T,[],2);
function [S,d] = compute_params(data,k,N,p,T,seuil,common,dims);
 
%%%%%%%%%%% hitung dimensi %%%%%%%%%%%
for i=1:k
    % hitung kelas proporsi
    n(i) = sum(T(:,i));
    prop(i) = n(i) / N;
    m(i,:) = sum(repmat(T(:,i),1,p).*data) / n(i);

    Sigma{i} = ((T(:,i)*ones(1,p)).*(data-ones(N,1)*m(i,:)))' * (data-ones(N,1)*m(i,:)) / n(i);
    Tr(i) = trace(Sigma{i});

    % temukan dimensi eigenspace Ei
    LL = eig(Sigma{i});
    LL = sort(LL,'descend');
    L(i,:) = LL; % ordered eigenvalues
    total_var = sum(LL);
    ex = cumsum(LL / total_var);
    %subplot(2,k,i), bar(LL(1:20));
    fait = 0;
    for j=1:round(p/2)-1,
        sc(j) = LL(j) - LL(j+1);
        [val,ind] = max(sc);
        if j>ind & sc(j)<seuil*val & ~fait, d(i) = j-1; fait = 1; end
    end
    %[val,ind] = max(sc); d(i) = ind;
    if fait==0, d(i) = round(p/2)-1; end
    if ~isempty(dims), d(i) = dims(i); end
    %subplot(2,k,k+i), plot(sc(1:19),'+-');
    %%%%%%%%%%% NEW %%%%%%%%%%%
    % Clear local variables
    clear LL ex total_var;

    % d_i eigenvectors
    opt.disp = 0;
    [V{i},LL] = eigs(Sigma{i},d(i),'LM',opt);
end
%disp(d), pause
%%%%%%%%%%%%%%%%%%%% hitung estimasi %%%%%%%%%%%%%%%%%%%%

%  Model [a_i b_i q_i] (HDDA)
if isempty(common) | isequal(common,'d')
    for i=1:k
        a(i) = sum(L(i,1:d(i)),2) / d(i);
        b(i) = (Tr(i) - sum(L(i,1:d(i)),2)) / (p-d(i));
    end
end

%%%%%%%%%%%%%%%%%%%%% hitung fungsi harga %%%%%%%%%%%%%%%%%%%%
for i=1:k
    % Projection of test data in the eigenspace Ei
    W{i} = zeros(p); W{i}(:,1:d(i)) = V{i};
    [nt,pt] = size(data);
    P = (data - repmat(m(i,:),nt,1)) * W{i} * W{i}'  + repmat(m(i,:),nt,1);

    % hitung Ki
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
    endfunction TT = s_step(T)
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