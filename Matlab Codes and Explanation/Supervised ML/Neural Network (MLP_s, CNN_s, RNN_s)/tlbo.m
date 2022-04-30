function [x,err]=tlbo(CostFunction,nVar)
% CostFunction= Cost Function
% nVar=Jumlah variabel keputusan
VarSize = [1 nVar]; % Ukuran matriks dg variabel unknown

VarMin = -5;       % variabel unknown batas bawah
VarMax =  5;       % variabel unknown batas atas 

%% TLBO Parameters

MaxIt = 50;        % Jumlah Max Iterasi

nPop = 50;           % Ukuran Populasi

%% Inisialisasi

% Struktur individual
empty_individual.Position = [];
empty_individual.Cost = [];

% Inisialisasi array populasi
pop = repmat(empty_individual, nPop, 1);

% Inisialisasi solusi terbaik
BestSol.Cost = inf;

% Inisialisasi member populasinya 
for i=1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
    
    if pop(i).Cost < BestSol.Cost
        BestSol = pop(i);
    end
end

% Inisialisasi Cost yang terbaik 
BestCosts = zeros(MaxIt,1);

%% TLBO Main Loop

for it=1:MaxIt
    
    % kalkulasikan mean populasi
    Mean = 0;
    for i=1:nPop
        Mean = Mean + pop(i).Position;
    end
    Mean = Mean/nPop;
    
    % Pilih Teacher
    Teacher = pop(1);
    for i=2:nPop
        if pop(i).Cost < Teacher.Cost
            Teacher = pop(i);
        end
    end
    
    % Tahapan Teacher 
    for i=1:nPop
        % Buat Empty solusi
        newsol = empty_individual;
        
        % Teaching Faktor
        TF = randi([1 2]);
        
        % Teaching (moving towards teacher)
        newsol.Position = pop(i).Position ...
            + rand(VarSize).*(Teacher.Position - TF*Mean);
        
        % Clipping
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        % Evaluasi
        newsol.Cost = CostFunction(newsol.Position);
        
        % Perbandingan
        if newsol.Cost<pop(i).Cost
            pop(i) = newsol;
            if pop(i).Cost < BestSol.Cost
                BestSol = pop(i);
            end
        end
    end
    
    %Tahapan Learner 
    for i=1:nPop
        
        A = 1:nPop;
        A(i)=[];
        j = A(randi(nPop-1));
        
        Step = pop(i).Position - pop(j).Position;
        if pop(j).Cost < pop(i).Cost
            Step = -Step;
        end
        
        % Create Empty Solution
        newsol = empty_individual;
        
        % Teaching (moving towards teacher)
        newsol.Position = pop(i).Position + rand(VarSize).*Step;
        
        % Clipping
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        % Evaluation
        newsol.Cost = CostFunction(newsol.Position);
        
        % Comparision
        if newsol.Cost<pop(i).Cost
            pop(i) = newsol;
            if pop(i).Cost < BestSol.Cost
                BestSol = pop(i);
            end
        end
    end
    
    % Store Record for Current Iteration
    BestCosts(it) = BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
    
end

x=BestSol.Position';
err=BestSol.Cost;
%% Results

figure;
%plot(BestCosts, 'LineWidth', 2);
semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
