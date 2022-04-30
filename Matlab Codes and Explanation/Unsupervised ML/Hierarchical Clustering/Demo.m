clear all;
close all;


N = 50;
d = [3];
class=4;

randn('seed',120);
X = [3*randn(N,d)+.1*ones(N,d); 0.8*randn(N,d)-ones(N,d);...
      0.05*randn(N,d)-0.1*ones(N,d); .4*randn(N,d)+4*ones(N,d)];


fprintf('\njumlah samples = %d; Dimension = %d\n',size(X,1),size(X,2));
fprintf('Proses HML ... \n');

tic
[CLUSTER] = HML(X,class); 
ClockTime = toc;

fprintf('\nClock Time untuk HML = %6.2f\n',ClockTime);
