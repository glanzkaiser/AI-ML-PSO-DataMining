function [X, FVAL, BestFVALIter, pop] = SanitizedTLBO(FITNESSFCN,lb,ub,T,NPop)

% simpan fungsi objektif tiap iterasi
% objective function value
BestFVALIter = NaN(T,1);
obj = NaN(NPop,1);

% ukuran 
D = length(lb);

%inisial populasi
pop = repmat(lb, NPop, 1) + repmat((ub-lb),NPop,1).*rand(NPop,D);


% evaluasi fungsi objective 
% bisa divektorisasi
for p = 1:NPop
    [obj(p), pop(p,:)] = FITNESSFCN(pop(p,:));
end


for gen = 1: T
    
    for i = 1:NPop
        
        % ---------------teacher phase-------------- %
        mean_stud = mean(pop);
        
        % determinasi  teacher
        [~,ind] = min(obj);
        best_stud = pop(ind,:);
        
        % determinasi teaching factor
        TF = randi([1 2],1,1);
        
        % generasi kan new solution 
        NewSol = pop(i,:) + rand(1,D).*(best_stud - TF*mean_stud);
        
        % Batasi solusi
        NewSol = max(min(ub, NewSol),lb);
        
        % evaluasi fungsi obbjective
        [NewSolObj,NewSol] = FITNESSFCN(NewSol);
        
        % seleksi Greedy
        if (NewSolObj < obj(i))
            pop(i,:) = NewSol;
            obj(i) = NewSolObj;
        end
        % seleksi partner 
        Partner = randi([1 NPop], 1,1);
        
        % buat solusi baru
        if (obj(i)< obj(Partner))
            NewSol = pop(i,:) + rand(1, D).*(pop(i,:)- pop(Partner,:));
        else
            NewSol = pop(i,:) + rand(1, D).*(pop(Partner,:)- pop(i,:));
        end
        
        % batasi solusi
        NewSol = max(min(ub, NewSol),lb);
        
        % evaluasi fungsi objektif
        [NewSolObj,NewSol] = FITNESSFCN(NewSol);
        
        %seleksi Greedy
        if(NewSolObj< obj(i))
            pop(i,:) = NewSol;
            obj(i) = NewSolObj;
        end
    end
    
    [BestFVALIter(gen),ind] = min(obj);
end

% ekstraksi solusi terbaik
X = pop(ind,:);
FVAL = BestFVALIter(gen);