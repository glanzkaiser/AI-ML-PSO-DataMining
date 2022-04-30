%% Loading a FIS dan bagi ukuran  optimisasi
Tuning_FIS_Name = input('Enter the FIS name: ','s');
fuzinfsys = readfis(Tuning_FIS_Name);

AddConvert_1 % alasan utk gunakan kalkulasi redundant
             %yaitu menyiapkan compability antara 1 bagian 
             %dan yang besar yg diambil dari 
             % tuned dari GA dan menaikkan 
             % harga komputasional 

dist = str2num(input('Increase the range of each dataset attribute by: ','s'));


%% buat dataset tuning
RandTrainTestArray_Design;

%% spesifikasikan masalah optimisasi 
boundlength = 0;
for i=1:1:length(fuzinfsys.input)
    for j=1:1:length(fuzinfsys.input(i).mf)
        boundlength = boundlength+1;  
    end
end
boundlength = boundlength*3; % {jumlah variabel yg tuned =jumlah atribut*3

LB = zeros(1,boundlength);
RB = zeros(1,boundlength);

delta_num = 0;
for i=1:1:length(fuzinfsys.input)
    for j=1:1:length(fuzinfsys.input(i).mf)
        delta_num = delta_num + 1;
        LB(delta_num) = -(fuzinfsys.input(i).mf(j).params(1)-fuzinfsys.input(i).range(1))-dist;
        RB(delta_num) = (fuzinfsys.input(i).mf(j).params(2)- fuzinfsys.input(i).mf(j).params(1))/2;
        
        delta_num = delta_num + 1;
        LB(delta_num) = -(fuzinfsys.input(i).mf(j).params(2)- fuzinfsys.input(i).mf(j).params(1))/2;
        RB(delta_num) = (fuzinfsys.input(i).mf(j).params(4)- fuzinfsys.input(i).mf(j).params(2))/2;
        
        delta_num = delta_num + 1;
        LB(delta_num) = -(fuzinfsys.input(i).mf(j).params(4)- fuzinfsys.input(i).mf(j).params(2))/2;
        RB(delta_num) = fuzinfsys.input(i).range(2)-fuzinfsys.input(i).mf(j).params(4)+dist;
    end
end
disp('--------------------');
%% spesifikasikan options optimisasi 
popsize = str2num(input('Enter the population size: ','s'));
maxgen  = str2num(input('Enter the number of iterations: ','s'));
maxtime = str2num(input('Enter the time limit: ','s'));
fitnesslimit = str2num(input('Enter the fitness limit: ','s'));

ga_options = optimoptions(@ga,'Display','diagnose','PopulationSize',popsize,...
    'MaxGenerations',maxgen,'MaxTime',maxtime,'FitnessLimit',fitnesslimit);
ga_choice = str2num(input('Console (1) or window (2) mode: ','s'));

%% jalankan proses optimasi genetik
tic
if ga_choice == 1
    [x,fval,exitflag,output,population,scores]=ga(@mod_fis_1,boundlength,[],[],[],[],LB,RB,[],ga_options);
elseif ga_choice == 2    
    ga_problem = struct('fitnessfcn',@mod_fis_1,'nvars',boundlength,'Aineq',[],...
        'bineq',[],'Aeq',[],'beq',[],'lb',LB,'ub',RB,...
        'nonlcon',[],'intcon',[],'rngstate',[],'solver','ga','options',ga_options);
    optimtool(ga_problem);
else
    error('Non-existing mode!');
end
toc