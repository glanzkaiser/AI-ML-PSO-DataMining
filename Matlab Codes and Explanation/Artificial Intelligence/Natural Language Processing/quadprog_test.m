clear all; close all; clc
addpath('apm')

H = [1 -1; -1 2]; 
f = [-2; -6];
A = [1 1; -1 2; 2 1];
b = [2; 2; 3];
Aeq = [];
beq = [];
lb = zeros(2,1);
ub = [];
x0 = [];

%% generate APMonitor QP model
y1 = apm_quadprog(H,f,A,b,Aeq,beq,lb,ub,x0);

% bandingkan solusi utk (MATLAB)
y2 = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0)

disp('Hasil Validasi dengan MATLAB linprog')
for i = 1:max(size(H)),
    disp(['x[' int2str(i) ']: ' num2str(y1.values(i)) ' = ' num2str(y2(i))])
end
