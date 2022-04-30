

function [MinCost] = GCMBO(ProblemFunction, DisplayFlag, RandSeed)


tic

if ~exist('ProblemFunction', 'var')
    ProblemFunction = @Ackley;
end
if ~exist('DisplayFlag', 'var')
    DisplayFlag = true;
end
if ~exist('RandSeed', 'var')
    RandSeed = round(sum(100*clock));
end

[OPTIONS, MinCost, AvgCost, InitFunction, CostFunction, FeasibleFunction, ...
    MaxParValue, MinParValue, Population] = Init(DisplayFlag, ProblemFunction, RandSeed);


% % % % % % % % % % % %             Initial parameter setting          % % % % % % % % % % % %%%%
%% Initial parameter setting
Keep = 2; % elitism parameter: how many of the best habitats to keep from one generation to the next
maxStepSize = 1.0;        %Max Step size
partition = OPTIONS.partition;
numButterfly1 = ceil(partition*OPTIONS.popsize);  % NP1 in paper
numButterfly2 = OPTIONS.popsize - numButterfly1; % NP2 in paper
period = 1.2; % 12 months in a year
Land1 = zeros(numButterfly1, OPTIONS.numVar);
Land2 = zeros(numButterfly2, OPTIONS.numVar);
BAR = partition; % you can change the BAR value in order to get much better performance
C_flag =1 ;
% % % % % % % % % % % %       End of Initial parameter setting       % % % % % % % % % % % %%
%%

for GenIndex = 1 : OPTIONS.Maxgen
    
    %% Save the best monarch butterflis in a temporary array.
    for j = 1 : Keep
        chromKeep(j,:) = Population(j).chrom;
        costKeep(j) = Population(j).cost;
    end
    for popindex = 1 : OPTIONS.popsize
        if popindex <= numButterfly1
            Population1(popindex).chrom = Population(popindex).chrom;
        else
            Population2(popindex-numButterfly1).chrom = Population(popindex).chrom;
        end
    end
    % % % % % % % % % % %    End of Divide the whole population into two subpopulations  % % %%%
    %%
    
    % % % % % % % % % % % %%            Migration operator          % % % % % % % % % % % %%%%
    %% Migration operator
    for k1 = 1 : numButterfly1
        for parnum1 = 1 : OPTIONS.numVar
            r1 = rand*period;
            if r1 <= partition
                r2 = round(numButterfly1 * rand + 0.5);
                Land1(k1,parnum1) = Population1(r2).chrom(parnum1);
            else
                r3 = round(numButterfly2 * rand + 0.5);
                Land1(k1,parnum1) = Population2(r3).chrom(parnum1);
            end
        end %% for parnum1
        NewPopulation1(k1).chrom =  Land1(k1,:);
        
        % buat 2 member population to decide whether to keep the trial vector or target vector
        PopTest(1).chrom = Land1(k1,:);
        SavePopSize = OPTIONS.popsize;
        OPTIONS.popsize = 1;
        % Make sure the trial vector is feasible
        PopTest = FeasibleFunction(OPTIONS, PopTest);
        % Compute the cost of the trial vector and the test vector
        PopTest = CostFunction(OPTIONS, PopTest);
        % Restore the original population size
        OPTIONS.popsize = SavePopSize;
        
        % Only accept better monarch butterfly 
        if PopTest(1).cost < Population(k1).cost
            Population(k1) = PopTest(1);
        end
        
    end  %% for k1
    
    % % % % % % % % % % % %%%       End of Migration operator      % % % % % % % % % % % %%%
    %%
    
    
    % % % % % % % % % % % %             Butterfly adjusting operator          % % % % % % % % % % % %%
    %% Butterfly adjusting operator
    for k2 = 1 : numButterfly2
        scale = maxStepSize/(GenIndex^2); %Smaller step for local walk
        StepSzie = ceil(exprnd(2*OPTIONS.Maxgen,1,1));
        delataX = LevyFlight(StepSzie,OPTIONS.numVar);
        for parnum2 = 1:OPTIONS.numVar,
            if (rand >= partition)
                Land2(k2,parnum2) = Population(1).chrom(parnum2);
            else
                r4 = round(numButterfly2*rand + 0.5);
                Land2(k2,parnum2) =  Population2(r4).chrom(1);
                if (rand > BAR) % Butterfly-Adjusting rate
                    Land2(k2,parnum2) =  Land2(k2,parnum2) +  scale*(delataX(parnum2)-0.5);
                end
            end
        end  %% for parnum2
        
        
        % % % % % % % % % % % % % Crossover % % % % % % % % % % % % %
        if C_flag ==1
            C_rate = 0.8 + 0.2*(Population(k2 + numButterfly1).cost-Population(1).cost)/(Population(50).cost-Population(1).cost);
            Cr = rand(OPTIONS.numVar,1) < C_rate ;
            
            % Crossover scheme
            NewPopulation2(k2).chrom = Land2(k2,:).*(1-Cr')+Population(k2).chrom.*Cr';
        end
        
        % Create a small two-member population to decide whether to keep the trial vector or target vector
        PopTest(1).chrom = Land2(k2,:);
        PopTest(2).chrom = NewPopulation2(k2).chrom;
        SavePopSize = OPTIONS.popsize;
        OPTIONS.popsize = 2;
        % Make sure the trial vector is feasible
        PopTest = FeasibleFunction(OPTIONS, PopTest);
        % Compute the cost of the trial vector and the test vector
        PopTest = CostFunction(OPTIONS, PopTest);
        % Restore the original population size
        OPTIONS.popsize = SavePopSize;
        
        if PopTest(1).cost < PopTest(2).cost
            Population(numButterfly1 +k2) = PopTest(1);
        else
            Population(numButterfly1 +k2) = PopTest(2);
        end
        
    end %% for k2
    % % % % % % % % % % % %       End of Butterfly adjusting operator      % % % % % % % % % % % %
    %%
    
    % Sort from best to worst
    Population = PopSort(Population);
    
    
    % % % % % % % % % % % %            Elitism Strategy          % % % % % % % % % % % %%% %% %
    %% Replace the worst with the previous generation's elites.
    n = length(Population);
    for k3 = 1 : Keep
        Population(n-k3+1).chrom = chromKeep(k3,:);
        Population(n-k3+1).cost = costKeep(k3);
    end % end for k3
    % % % % % % % % % % % %     End of  Elitism Strategy      % % % % % % % % % % % %%% %% %
    %%
    
    % % % % % % % % % %           Precess and output the results          % % % % % % % % % % % %%%
    % Sort from best to worst
    Population = PopSort(Population);
    % Compute the average cost
    [AverageCost, nLegal] = ComputeAveCost(Population);
    % Display info to screen
    MinCost = [MinCost Population(1).cost];
    AvgCost = [AvgCost AverageCost];
    if DisplayFlag
        disp(['The best and mean of Generation # ', num2str(GenIndex), ' are ',...
            num2str(MinCost(end)), ' and ', num2str(AvgCost(end))]);
    end
    
end % end for GenIndex
Conclude1(DisplayFlag, OPTIONS, Population, nLegal, MinCost, AvgCost);

toc

% % % % % % % % % %     End of Monarch Butterfly Optimization implementation     %%%% %% %
%%


function [delataX] = LevyFlight(StepSize, Dim)

%Allocate matrix for solutions
delataX = zeros(1,Dim);

%Loop over each dimension
for i=1:Dim
    % Cauchy distribution
    fx = tan(pi * rand(1,StepSize));
    delataX(i) = sum(fx);
end
