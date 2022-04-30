function [solution] = stateofmattersearch(NoPob)
if nargin<1,
    % Number of poblation
    NoPob=50;
end

%paremeters
dim     = 30;
phase   = 1;               %gas phase
beta    = [0.9, 0.5, 0.1]; %movement
alpha   = [0.3, 0.05, 0];  %colides
H       = [0.9, 0.2,  0];  %random
phases  = [0.5, 0.1,-0.1]; %percent of phases
param   = [0.85 0.35 0.1]; %adjust Param

%graph stuff
plotGraph = 0;
if plotGraph == 1
    x=0:1/50:1;
    y=x;
    [X,Y]=meshgrid(x,y);
    [row,col]=size(X);
    for l=1:col
        for h=1:row
            Z(h,l)=scwefelFnc([X(h,l),Y(h,l)]);
        end
    end
end

N_IterTotal=1000;

% Random initial solutions
pob = rand(NoPob,dim);
dir = rand(NoPob,dim)*2-1;
% Eval Fitness
fitness = evalPob(pob);

% Get Best
[bestSol, bestFit] = getBest(pob,fitness, zeros(1,dim), 100000000);

for ite = 1:N_IterTotal
    % movement
    best = repmat(bestSol, NoPob, 1);
    b = sqrt(sum((best-pob+eps).^2,2));
    b = repmat(b,1,dim);
    a = (best-pob)./b;
    dir = dir * (1 - ite/N_IterTotal)*0.5 + a;

    % colis
    r = 1 * alpha(phase);
    for i = 1:NoPob - 1
        for j = i+1:NoPob
            rr = norm(pob(i,:) - pob(j,:));
            if rr < r
                c = dir(i,:);
                d = dir(j,:);
                dir(i,:)=d;
                dir(j,:)=c;
            end
        end
    end

    v = 1 * beta(phase) * dir; 
    pob = pob + v * rand * param(phase);

    % random
    for i=1:NoPob
        if rand< H(phase)
            j = fix(rand*dim)+1;
            pob(i,j)= rand;
        end
    end

    % change of phase
    if 1 - ite/N_IterTotal < phases(phase)
        phase = phase + 1;
    end
    
    %check limits [0-1]
    pob = checkLimits(pob);
    
    % Eval Fitness
    fitness = evalPob(pob);

    % Get Best
    [bestSol, bestFit] = getBest(pob,fitness, bestSol, bestFit);
    
    if plotGraph == 1
        graph2d(X, Y, Z, pob, bestSol);
    end
end

solution = [bestSol, bestFit]



function [ r, x ] = scwefelFnc(vector)
%The schwefel function was used as example
% r=Fitness value, x=descicion variables
x = vector;
x = x * 1000 - 500; %scale to the bounds
[~,m]=size(vector);
r = 418.9829*m + sum( -x.*sin(sqrt(abs(x))) );

function f = evalPob(pob)
f = zeros(size(pob,1),1);
for i=1:size(pob,1)
    f(i) = scwefelFnc(pob(i,:));%Objective function used as example
end

function [bestSol, bestFit] = getBest(pob, fitness, bestSol, bestFit)
[~, p] = min(fitness);
if fitness(p) < bestFit
    bestFit = fitness(p);
    bestSol = pob(p,:);
end

function pob = checkLimits(pob)
for i=1:size(pob,1)
    A = pob(i,:) > 1;
    B = pob(i,:) < 0;
    pob(i,A) =1;
    pob(i,B) =0;
end

function graph2d(X, Y, Z, pob, bestSol)
hold off
contour(X,Y,Z,5);
hold on
plot(pob(:,1), pob(:,2),'ob');
plot(bestSol(1), bestSol(2),'og');
drawnow