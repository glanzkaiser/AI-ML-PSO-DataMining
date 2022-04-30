

clc;
clear;
close all;

%% definisi masalah

CostFunction=@(x) Sphere(x);        % fungsi harga

nVar=10;             % jumlah variabel keputusan

VarSize=[1 nVar];   % Variables Matrix Size

VarMin=-10;         % Decision Variables Lower Bound
VarMax= 10;         % Decision Variables Upper Bound

%% ACOR Parameters

MaxIt=1000;          % Maximum Number of Iterations

nPop=10;            % Population Size (Archive Size)

nSample=40;         %ukuran sampel 

q=0.5;          

zeta=1;             % rasio jarak deviasi

%% Inisialisasi

% buat struktur individual kosong
empty_individual.Position=[];
empty_individual.Cost=[];

% Create Population Matrix
pop=repmat(empty_individual,nPop,1);

% Initialize Population Members
for i=1:nPop
    
    % Create Random Solution
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Evaluation
    pop(i).Cost=CostFunction(pop(i).Position);
    
end

% Sort Population
[~, SortOrder]=sort([pop.Cost]);
pop=pop(SortOrder);

% Update Best Solution Ever Found
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Solution Weights
w=1/(sqrt(2*pi)*q*nPop)*exp(-0.5*(((1:nPop)-1)/(q*nPop)).^2);

% pilih probabilitas
p=w/sum(w);


%% ACOR Main Loop

for it=1:MaxIt
    
    %rata2
    s=zeros(nPop,nVar);
    for l=1:nPop
        s(l,:)=pop(l).Position;
    end
    
    % Standard deviasi
    sigma=zeros(nPop,nVar);
    for l=1:nPop
        D=0;
        for r=1:nPop
            D=D+abs(s(l,:)-s(r,:));
        end
        sigma(l,:)=zeta*D/(nPop-1);
    end
    
    % buat array popolasi baru
    newpop=repmat(empty_individual,nSample,1);
    for t=1:nSample
        
        % inisialisasi posisi matriks
        newpop(t).Position=zeros(VarSize);
        
        % solusi konstruksi
        for i=1:nVar
            
            % pilih Gaussian Kernel
            l=RouletteWheelSelection(p);
            
            % jalankan Gaussian Random Variable
            newpop(t).Position(i)=s(l,i)+sigma(l,i)*randn;
            
        end
        
        % Evaluasi
        newpop(t).Cost=CostFunction(newpop(t).Position);
        
    end
    
    % gabungkan Main Population (Archive) dan New Population (Samples)
    pop=[pop
         newpop]; %#ok
     
    % urutkan populasi
    [~, SortOrder]=sort([pop.Cost]);
    pop=pop(SortOrder);
    
    % hapus Extra Members
    pop=pop(1:nPop);
    
    % Update Best Solution Yang Ada
    BestSol=pop(1);
    
    % Simpan Best Cost
    BestCost(it)=BestSol.Cost;
    
    % Tampilkan informasi Iterasi
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end

%% Hasil

figure;
%plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
xlabel('Iterasi');
ylabel('Best Cost');
grid on;
