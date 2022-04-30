function [prms,T,cls] = hddc_learn(XX,k,varargin);
% High Dimensionality Reduction Clustering (hddc)
%
% Input: 
%       - X: data
%       - k: jumlah kelas
%       - model: 
%
% Output:
%       - cls: label  test data Y.data,
%       - T: a posteriori probabilitas
%       - prms: parameter kelas
%
% Initialisasi parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(XX), X = XX.data; if exist('XX.cls'), class = XX.cls; end
else X = XX; class = []; end

[N,p] = size(X);
maxiter = 100;
seuil = 0.2;
model = 'AiBiQiDi';
common = '';
init = 'random';
dim = [];
diff = 1e-5;

%%% PARAMETERS MANAGEMENT
for i=1:2:length(varargin)
    if ~isstr(varargin{i}) | ~exist(varargin{i},'var')
        error(['Invalid parameter ' varargin{i}]);
    end
    eval([varargin{i} '= varargin{i+1};']);
end
%%%

if isempty(strmatch(model,strvcat('AijBiQiDi', 'AijBQiDi', 'AiBiQiDi', 'ABiQiDi',...
        'AiBQiDi', 'ABQiDi','AijBiQiD', 'AijBQiD', 'AiBiQiD', 'ABiQiD', 'AiBQiD',...
        'ABQiD','best'),'exact'))
    error('--> The parameter ''model'' is not valide: see the help of hddc.');
end

% Initialisasi %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~ischar(init), 
    init_cls = init; 
    fprintf('* User inisialisasi !\n');
else
    switch init
        case 'random'
            init_cls = randsample(k,N,1);
            fprintf('* Random inisialisasi\n');
        case 'kmeans'
            init_cls = kmeans(X,k);
            fprintf('* Inisialisasi dari kmeans !\n');
    end
end

% Panggil main fungsi %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isequal(model,'best') % cari model dengan value terkecil
    if isempty(dim), % model dengan dimensi bebas
        models = {'AijBiQiDi', 'AijBQiDi', 'AiBiQiDi', 'ABiQiDi', 'AiBQiDi', 'ABQiDi'};
        fprintf('--> nilai HDDA model dengan dimensi \n');
        for i = 1:length(models)
            [prms_t{i},T_t{i},cls_t{i}] = learn(X,k,models{i},seuil,maxiter,dim,init_cls,diff);
            bic(i) = prms_t{i}.bic;
            fprintf('   - model %s:     %g\n',models{i},bic(i));
        end

    else % model dengan dimensi umum
        models = {'AijBiQiD', 'AijBQiD', 'AiBiQiD', 'ABiQiD', 'AiBQiD', 'ABQiD'};
        fprintf('--> nilai model dengan dimensi umum:\n');
        for i = 1:length(models)
            [prms_t{i},T_t{i},cls_t{i}] = learn(X,k,models{i},seuil,maxiter,dim,init_cls,diff);
            bic(i) = prms_t{i}.bic;
            fprintf('   - model %s:    %g\n',models{i},bic(i));
        end
    end
    [val,ind] = min(fliplr(bic));
    prms = prms_t{ind};
    T = T_t{ind};
    cls = cls_t{ind};
    fprintf('--> Best model: %s\n',prms_t{ind}.model);
else
    [prms,T,cls] = learn(X,k,model,seuil,maxiter,dim,init_cls,diff);
    fprintf('-->  model yang digunakan: %s\n',prms.model);
end
function [prms,T,cls] = learn(X,k,model,seuil,maxiter,dim,init_cls,diff);

[N,p] = size(X);

% Convert nama model ke format lama%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch model
    case 'AijBiQiDi' %  Model [a_ij b_i Q_i d_i]
        common = 'f';
    case 'AijBiQiD' %  Model [a_ij b_i Q_i d]
        common = 'fd';
    case 'AijBQiDi' %  Model [a_ij b_i Q_i d_i]
        common = 'fb';
    case 'AijBQiD' %  Model [a_ij b_i Q_i d]
        common = 'fbd';
    case 'AiBiQiDi' %  Model [a_i b_i Q_i d_i]
        common = '';
    case 'AiBiQiD' % Model [a_i b_i Q_i d]
        common = 'd';
    case 'ABiQiDi' % Model [a b_i Q_i d_i]
        common = 'a';
    case 'ABiQiD' % Model [a b_i Q_i d]
        common = 'ad';
    case 'AiBQiDi' % Model [a_i b Q_i d_i]
        common = 'b';
    case 'AiBQiD' % Model [a_i b Q_i d]
        common = 'bd';
    case 'ABQiDi' % Model [a b Q_i d_i]
        common = 'ab';
    case 'ABQiD' % Model [a b Q_i d]
        common = 'abd';
    otherwise error('Not yet implemented!');
end

%panggil fungsi C %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[prms,T,cls,S] = hddc_learn_fast(X,k,'seuil',seuil,'maxiter',maxiter,...
    'common',common,'dim',dim,'init',init_cls,'diff',diff);

% Compute nilai %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = double(prms.d);
switch model
    case 'AijBiQiDi' %  Model [a_ij b_i Q_i d_i]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + sum(d) + 2*k;
    case 'AijBiQiD' %  Model [a_ij b_i Q_i d]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + sum(d) + k + 1;
    case 'AijBQiDi' %  Model [a_ij b_i Q_i d_i]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + sum(d) + k + 1;
    case 'AijBQiD' %  Model [a_ij b_i Q_i d]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + sum(d) + 2;
    case 'AiBiQiDi' %  Model [a_i b_i Q_i d_i]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + 3*k;
    case 'AiBiQiD' % Model [a_i b_i Q_i d]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + 2*k + 1;
    case 'ABiQiDi' % Model [a b_i Q_i d_i]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + 2*k + 1;
    case 'ABiQiD' % Model [a b_i Q_i d]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + k + 2;
    case 'AiBQiDi' % Model [a_i b Q_i d_i]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + 2*k + 1;
    case 'AiBQiD' % Model [a_i b Q_i d]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + k + 2;
    case 'ABQiDi' % Model [a b Q_i d_i]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + k + 2;
    case 'ABQiD' % Model [a b Q_i d]
        q = (k*p+k-1) + sum( d.*(p-(d+1)/2) ) + 3;
    otherwise error('tidak terimplementasi!');
end
K = S + p * log(2*pi);
ll = sum(sum(T .* K));
bic = (ll + q * log(N)) / N;

% kembali parameter dan hasilnya %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prms.p = p;
prms.model = model;
prms.bic = bic;
prms.k = k;
prms.d = double(prms.d);
prms.m = prms.m';
cls = double(cls);