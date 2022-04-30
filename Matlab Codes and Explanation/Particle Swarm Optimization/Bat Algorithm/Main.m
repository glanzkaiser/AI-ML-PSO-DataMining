
clear all 
close all
clc

CostFunction=@(x) MyCost(x); % modify atau gantikan dg cost funciton

Max_iteration=500; % jumlah max iterasi
noP=30; % jumlah partikel
noV=100;

A=.25;      % Loudness 
r=.1;      % Pulse rate 

[gBest, gBestScore ,ConvergenceCurve]=BBA(noP, A, r, noV, Max_iteration, CostFunction);

plot(ConvergenceCurve,'DisplayName','BBA','Color', 'r');
hold on


title(['\fontsize{12}\bf Convergence curve']);
xlabel('\fontsize{12}\bf Iteration');ylabel('\fontsize{12}\bf Average Best-so-far');
legend('\fontsize{10}\bf BBA',1);
grid on
axis tight

save resuls

