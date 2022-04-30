clear
clc
load('S1'); % load a dataset

%% Original version
%%%%%%%%% DBSCAN
SimMatrix=pdist2(data,data,'minkowski',2);
eps=0.02;
MinPts=3;
Tclass=Mdbscan(data,MinPts,eps,SimMatrix)';  
[ ~,~,~,~,~,~,~,~,DBSCAN_Fmeasure,~] = evaluate(class,Tclass) % the best performance

%%%%%%%%% SNN
k=ceil(size(data,1)^0.5);
SimMatrix= SNN(data,k);
SimMatrix=k-SimMatrix;
Eps=10;
MinPts=9;
Tclass=Mdbscan(data,MinPts,Eps,SimMatrix)'; 
[ ~,~,~,~,~,~,~,~,SNN_Fmeasure,~] = evaluate(class,Tclass) % the best performance
 

%% ReCon version
%%%%%%%%%%% DBSCAN
Ratio=1.1;
SimMatrix=pdist2(data,data,'minkowski',2);
eps=0.1523 ;
threshold=  0.8950 ;
eta=eps*Ratio;
 Tclass=DRSCAN(data,threshold,eps,eta,SimMatrix)';
[ ~,~,~,~,~,~,~,~,ReCon_DBSCAN_Fmeasure,~] = evaluate(class,Tclass) % the best performance

%%%%%%%%%%%%%% SNN
Ratio=1.3; 
k=ceil(size(data,1)^0.5);
SimMatrix= SNN(data,k);
SimMatrix=k-SimMatrix;
eps=10;
threshold= 0.5796;
eta=eps*Ratio;
Tclass=DRSCAN(data,threshold,eps,eta,SimMatrix)';
[ ~,~,~,~,~,~,~,~,ReCon_SNN_Fmeasure,~] = evaluate(class,Tclass) % the best performance
 