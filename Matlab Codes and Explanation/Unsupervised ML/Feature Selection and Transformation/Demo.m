%% DEMO FILE
clear all
close all
clc;
fprintf('\nFEATURE SELECTION  \n');
% termasuk yang bergantung didalamnya
addpath('./lib'); % ketergantungan
addpath('./methods'); % FS methods
addpath(genpath('./lib/drtoolbox'));

% pilih metode nya yang mana
listFS = {'ILFS','InfFS','ECFS','mrmr','relieff','mutinffs','fsv','laplacian','mcfs','rfe','L0','fisher','UDFS','llcfs','cfs'};

[ methodID ] = readInput( listFS );
selection_method = listFS{methodID}; % Select

% Load data dan pilih utk klasifikasi
load fisheriris
X = meas; clear meas
% Extract kelas Setosa
Y = nominal(ismember(species,'setosa')); clear species

% partisi scara acak sampai training dan test terset 
P = cvpartition(Y,'Holdout',0.20);

X_train = double( X(P.training,:) );
Y_train = (double( Y(P.training) )-1)*2-1; % labels: neg_class -1, pos_class +1

X_test = double( X(P.test,:) );
Y_test = (double( Y(P.test) )-1)*2-1; % labels: neg_class -1, pos_class +1

% jumlah fitur
numF = size(X_train,2);


% feature Selection di training data
switch lower(selection_method)
    case 'ilfs'
        [ranking, weights, subset] = ILFS(X_train, Y_train , 4, 0 );
    case 'mrmr'
        ranking = mRMR(X_train, Y_train, numF);
        
    case 'relieff'
        [ranking, w] = reliefF( X_train, Y_train, 20);
        
    case 'mutinffs'
        [ ranking , w] = mutInfFS( X_train, Y_train, numF );
        
    case 'fsv'
        [ ranking , w] = fsvFS( X_train, Y_train, numF );
        
    case 'laplacian'
        W = dist(X_train');
        W = -W./max(max(W)); % jarak
        [lscores] = LaplacianScore(X_train, W);
        [junk, ranking] = sort(-lscores);
        
    case 'mcfs'
        % MCFS: Feature Selection utk Multi-Cluster Data
        options = [];
        options.k = 5; %utk unsupervised feature selection, pilih parameter k
        %default k = 5.
        options.nUseEigenfunction = 4;  %pilih parameter.
        [FeaIndex,~] = MCFS_p(X_train,numF,options);
        ranking = FeaIndex{1};
        
    case 'rfe'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(selection_method));
        
    case 'l0'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(selection_method));
        
    case 'fisher'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(selection_method));
        
    case 'inffs'
        alpha = 0.5;    % default, cross-validated.
        sup = 1;        % Supervised atau gak
        [ranking, w] = infFS( X_train , Y_train, alpha , sup , 0 );    
        
    case 'ecfs'
        % Features Selection via Eigenvector 
        alpha = 0.5; % default, harusnya cross-validated.
        ranking = ECFS( X_train, Y_train, alpha )  ;
        
    case 'udfs'
        % Regularized Discriminative Feature Selection utk Unsupervised Learning
        nClass = 2;
        ranking = UDFS(X_train , nClass ); 
        
    case 'cfs'
        %urutkan feature yg berpasangan dg korrelasi
        ranking = cfs(X_train);     
        
    case 'llcfs'   
        % Feature Selection dan Kernel Learning utk Local Learning-Based Clustering
        ranking = llcfs( X_train );
        
    otherwise
        disp('method tidak diketahui.')
end

k = 2; % select  2 features

% gunakan svm linear classifier
svmStruct = svmtrain(X_train(:,ranking(1:k)),Y_train,'showplot',true);
C = svmclassify(svmStruct,X_test(:,ranking(1:k)),'showplot',true);
err_rate = sum(Y_test~= C)/P.TestSize; 
conMat = confusionmat(Y_test,C);

disp('X_train size')
size(X_train)

disp('Y_train size')
size(Y_train)

disp('X_test size')
size(X_test)

disp('Y_test size')
size(Y_test)


fprintf('\nMethod %s (Linear-SVMs): Accuracy: %.2f%%, Error-Rate: %.2f \n',selection_method,100*(1-err_rate),err_rate);


