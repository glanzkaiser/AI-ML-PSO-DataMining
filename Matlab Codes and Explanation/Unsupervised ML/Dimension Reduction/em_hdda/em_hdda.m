function [prms,T,cls] = em_hdda(XX,k,varargin);
% High Dimensionality Reduction Clustering (hddc)

%       - X: data
%       - k: jumlah kelas
%       - common: '' or 'd'
%
% Output:
%       - cls: label test data Y.data,
%       - T: a posteriori probabilitas
%       - prms: kelas parameter
%

%                     Initialisasi parameter                    %

if isstruct(XX), X = XX.data; if isfield(XX,'cls'), class = XX.cls; end
else X = XX; class = []; end

[N,p] = size(X);
diff = 1e-6; 
maxiter = 50;
common = []; 
init = 'random';
dims = []; 
dim = [];
seuil = 2e-1;
update = 0;
cem = 0;
sem = 0;

%%% PARAMETERS MANAGEMENT
for i=1:2:length(varargin)
    if ~isstr(varargin{i}) | ~exist(varargin{i},'var')
        error(['Invalid parameter ' varargin{i}]);
    end
    eval([varargin{i} '= varargin{i+1};']);
end
%%%

if ~ischar(init), 
    cls = init; fprintf('* User inisialisasi !\n');
    T = zeros(N,k); for i=1:k, T(cls==i,i) = 1; end 
else
    switch init
        case 'random'
            cls = randsample(k,N,1); fprintf('* Inisialisasi acak !\n');
            T = zeros(N,k); for i=1:k, T(cls==i,i) = 1; end
        case 'kmeans'
            [m,cls] = kmeanslight(X,k); fprintf('* Inisialisasi kmeans !\n');
            T = zeros(N,k); for i=1:k, T(cls==i,i) = 1; end
            %[m,cls] = kmeanslight(X(:,1),k); fprintf('* Initialization
            %dari
            %kmeans on the first column !\n');
        case 'parameters' % EM step 0 (McLacklan et al.)
            prop(1:k) = 1/k; W = cov(X); cls(1:N) = 1;
            moy = rand(gaussdens('m',mean(X),'var',10*W),k);
            for i=1:k, S{i} = 10*W; end
            c = densitycl(gaussdens,'m',moy','var',S);
            T = proba_class(c,X); fprintf('* Inisialisasi !\n');
    end
end

S = compute_params(X,k,N,p,T,seuil,common,dims);
for i=1:k, T(:,i) = 1 ./ sum( exp(-0.5*(S-repmat(S(:,i),1,k))) ,2)'; end

for it = 1:maxiter %awal loop
    %fprintf('* Etape : %g\n',it);
    %waitbar(it/maxiter,h)
    if it~=1,
        for i=1:k, T(:,i) = 1 ./ sum( exp(-0.5*(S-repmat(S(:,i),1,k))) ,2)'; end
    end
    
    %%%% S STEP %%%%
    if sem
        T = s_step(T); 
    end
    
    %%%%% C STEP %%%%%
    if cem,
        [val,cls] = max(T,[],2);
        T = zeros(N,k); for i=1:k, T(cls==i,i) = 1; end
    end
    
    %%%% Update jumlah 
    if update,
        for i=1:k, prop(i) = sum(T(:,i)) / N; end
        [val,ind] = min(prop);
        if val <= 1 / (2*k),
            k = k - 1;
            T = [T(:,1:ind-1),T(:,ind+1:end)];
            prop = [prop(1:ind-1),prop(ind+1:end)];
            fprintf('Step %i: number of components updated !\n',it);
        end
    end
    %%%% M STEP %%%%
    [S,prms] = compute_params(X,k,N,p,T,seuil,common,dims);
    disp(prms.d);
    
    %%%% hitung Q %%%%
    for i=1:k, prop(i) = sum(T(:,i)) / N; end
    Q(it) = sum(sum(T.*(repmat(log(prop),N,1)-0.5*S-p/2*log(2*pi)),2),1);
    fprintf('Step %i: %f\n',it,Q(it) / N);
    
    %%%% check %%%%
    %if (it>1 & abs(Q(it)-Q(it-1))<diff*abs(Q(it))), break; end
    cls_old = cls; [val,cls] = max(T,[],2);
    if (it>1 & ~sum(cls_old ~= cls)) | (it>1 & abs(Q(it)-Q(it-1))<diff*abs(Q(it))), break; end
end

% informasi umum
%fprintf('***********************************\n');
%fprintf('* Log Likelihood: %f\n',Q(it));
fprintf('***********************************\n');
fprintf('* parameter yg ditemukan: \n\n'); disp(prms);
fprintf('***********************************\n');

% hasil numerik
for i=1:k, T(:,i) = 1 ./ sum( exp(-0.5*(S-repmat(S(:,i),1,k))) ,2)'; end
[val,cls] = max(T,[],2);

function [S,prms] = compute_params(data,k,N,p,T,seuil,common,dims);
 
for i=1:k
    % komputasi proporsi kelas
    n(i) = sum(T(:,i));
    if ~isempty(strfind(common,'p')), prop(i) = 1 / k;
    else  prop(i) = n(i) / N; end   
    m(i,:) = sum(repmat(T(:,i),1,p).*data) / n(i);

    % Estimator Sigma_i
    Sigma{i} = ((T(:,i)*ones(1,p)).*(data-ones(N,1)*m(i,:)))' * (data-ones(N,1)*m(i,:)) / n(i);
    Tr(i) = trace(Sigma{i});

    % temukan dimensi intrinsec dari eigenspace
    LL = eig(Sigma{i});
    LL = sort(LL,'descend');
    L(i,:) = LL; % ordered eigenvalues
    fait = 0;
    % metode utk nemukan dimensi yg sama
    sc = diff([LL(2:end),LL(1:end-1)],1,2);
    for j=1:floor(p/2),
        if prod(double(sc(j+1:end)<seuil*max(sc))),
            d(i) = j;
            fait = 1;
            break
        end
    end
    if fait==0, d(i) = floor(p/2); end
    % hapus variabel lokal
    clear LL sc;
        
    % dimensi umum
    if ~isempty(strfind(common,'d')),   
        d = dim*ones(1,k);
    end

    % d_i eigenvectors
    opt.disp = 0;
    [V{i},LL] = eigs(Sigma{i},d(i),'LM',opt);
end

%%%%%%%%%%%%%%%%%%%% hitungan estimatorny %%%%%%%%%%%%%%%%%%%%
%  Model [a_ij b_i q_i]
if isequal(common,'f') | isequal(common,'fd')
    a = zeros(max(d(i)),k);
    for i=1:k
        a(1:d(i),i) = L(i,1:d(i));
        b(i) = (Tr(i) - sum(L(i,1:d(i)),2)) / (p-d(i));
    end
end

% Model [a_ij b q_i]
if isequal(common,'fb') | isequal(common,'fbd')
    a = zeros(max(d(i)),k);
    for i=1:k
        a(1:d(i),i) = L(i,1:d(i));
        s(i) = (Tr(i) - sum(L(i,1:d(i)),2));
    end
    b(1:k) = sum(n.*s) / sum(n.*(p-d));
    clear s;
end

%  Model [a_i b_i q_i] (HDDA)
if isempty(common) | isequal(common,'d') | isequal(common,'p')
    for i=1:k
        a(i) = sum(L(i,1:d(i)),2) / d(i);
        b(i) = (Tr(i) - sum(L(i,1:d(i)),2)) / (p-d(i));
    end
end

% Model [a b_i q_i]
if isequal(common,'a') | isequal(common,'ad') | isequal(common,'ap')
    for i=1:k, 
        s(i) = sum(L(i,1:d(i)));
        b(i) = (Tr(i) - sum(L(i,1:d(i)),2)) / (p-d(i));
    end
    a(1:k) = sum(n.*s) / sum(n.*d);
    clear s;
end

% Model [a_i b q_i]
if isequal(common,'b') | isequal(common,'bd') | isequal(common,'bp')
    for i=1:k, 
        s(i) = (Tr(i) - sum(L(i,1:d(i)),2)); 
        a(i) = sum(L(i,1:d(i)),2) / d(i);
    end
    b(1:k) = sum(n.*s) / sum(n.*(p-d));
    clear s;
end

% Model [a b q_i]
if isequal(common,'ab') | isequal(common,'abd') | isequal(common,'abp')
    for i=1:k,
        s1(i) = sum(L(i,1:d(i)));
        s2(i) = (Tr(i) - sum(L(i,1:d(i)),2));
    end  
    a(1:k) = sum(n.*s1) / sum(n.*d);
    b(1:k) = sum(n.*s2) / sum(n.*(p-d));
end

% Model alpha 
if  isequal(common,'alpha') | isequal(common,'alphad') | isequal(common,'alphap')
    dif = 1; eps = 1e-3;
    for i=1:k, 
        a(i) = sum(L(i,1:d(i)),2) / d(i); 
        b(i) = (Tr(i) - sum(L(i,1:d(i)),2)) / (p-d(i));
        s1(i) =  sum(L(i,1:d(i))); s2(i) = (Tr(i) - sum(L(i,1:d(i))));
    end
    sigma = a.*b ./ (a+b);
    gamma = sum(n.*d); Lambda = sum(n.*(s1-s2)./sigma);
    alpha = ((Lambda+N*p) - sqrt((Lambda+N*p)^2-4*Lambda*gamma)) / (2*Lambda);
    while dif > eps        
        sigma = (alpha*s1 + (1-alpha)*s2) / p;
        alpha_old = alpha; Lambda = sum(n.*(s1-s2)./sigma);
        alpha = ((Lambda+N*p) - sqrt((Lambda+N*p)^2-4*Lambda*gamma)) / (2*Lambda);
        dif = abs(alpha - alpha_old);        
    end
    alpha(1:k) = alpha;
end

% Model sigma 
if  isequal(common,'sigma') | isequal(common,'sigmad') | isequal(common,'sigmap')
    dif = 1; eps = 1e-10; %u=1;
    for i=1:k, 
        a(i) = sum(L(i,1:d(i)),2) / d(i);
        b(i) = (Tr(i) - sum(L(i,1:d(i)),2)) / (p-d(i));
        s1(i) =  sum(L(i,1:d(i))); s2(i) = (Tr(i) - sum(L(i,1:d(i))));
    end
    alpha = b ./ (a+b);
    sigma = sum(n.*(alpha.*s1 + (1-alpha).*s2)) / (N*p);
    while dif > eps    
        %tmp(u) = sigma; u = u+1;
        Lambda = (s1 - s2) ./ sigma;
        alpha = ((Lambda+p) - sqrt((Lambda+p).^2-4.*Lambda.*d)) ./ (2*Lambda);
        sigma_old = sigma; 
        sigma = sum(n.*(alpha.*s1 + (1-alpha).*s2)) / (N*p);
        dif = abs(sigma - sigma_old);        
    end
    sigma(1:k)=sigma;
    %plot(tmp)
end


%%%%%%%%%%%%%%%%%%%%% hapus fungsi harga %%%%%%%%%%%%%%%%%%%%
for i=1:k
    % proyeksi test data ke eigenspace Ei
    W{i} = zeros(p); W{i}(:,1:d(i)) = V{i};
    [nt,pt] = size(data);
    Pr = (data - repmat(m(i,:),nt,1)) * W{i} * W{i}'  + repmat(m(i,:),nt,1);

    % hitung Ki (Cost function)
    S(:,i) = (1/a(i) * sum((repmat(m(i,:),nt,1) - Pr).^2,2) ) ...
        + (1/b(i) * sum((data - Pr).^2,2)) ...
        + d(i) * log(a(i)) + (p-d(i)) * log(b(i)) ...
        - 2 * log(prop(i));
end

%%%%%%%%%%%%%%%%%%%%% Kembalikan parameter %%%%%%%%%%%%%%%%%%%%
prms.k = k; prms.p = p;
prms.a = a; prms.b = b;
prms.d = d; prms.prop = prop; 
prms.m = m; prms.W = W; 
function TT = s_step(T)
[n,k] = size(T); R = rand(n,1); TT = zeros(n,k);
P = cumsum(T,2); P = [zeros(n,1),P];
for i=1:n
    for j=2:k+1
        if R(i)>=P(i,j-1) & R(i)<P(i,j), TT(i,j-1)=1; end
    end
end