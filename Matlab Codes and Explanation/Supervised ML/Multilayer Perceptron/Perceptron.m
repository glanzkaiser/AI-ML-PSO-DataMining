%Contoh adalah database penyakit leukimia
%% Load Golub et al. Leukemia Cancer DB
load Database/leukemia

feature_length=5;  % memilih 5 gen paling signifikan 
train_data=train_data(feature_with_mRMr_d(1:feature_length),:)';
test_data=test_data(feature_with_mRMr_d(1:feature_length),:)';

%% Tentukan Parameter Neural Network 
% (size/structure of the MLP)
N1=20;                  % Middle Layer Neuron
N2=1;                   % Output Layer Neuron
N0=feature_length+1;    % Input Layer Neurons (feature length + bias)

% Parameter Data Latih
eta = 0.5; % Pembelajaran rate dari 0-1   contoh .01, .05, .005
epoch=10;  % Iterasi data latih

% Inisialisasi bobot
w1=randn(N1,N0);    % Inisialisasi bobot dari input dan middle layer
w2=randn(N2,N1);    % Inisialisasi bobot dari middle ke output

for j=1:epoch
    %pembelajaran acak untuk data latih buat ningkatin performance
    %pembelajaran 
    ind(j,:)=randperm(length(class_train)); 
    
    for k=1:size(train_data,1)
        
        Input=[1 train_data(ind(j,k),:)];  % {1} is for bias
        
        % Input layer
        n1 = w1*Input';
        a1=tansig(n1);

        % Hidden layer
        n2 = w2*a1;
        a2=logsig(n2);
        
        % output layer
        Output(k)=a2;    
        e = class_train(ind(j,k)) - Output(k);
        
        % Data latih dari NN pake Backpro algoritma
        Y2 = 2*dlogsig(n2,a2)*e;  % Local gradient dari output layerlocal gradient of Output Layer
        Y1 = diag(dtansig(n1,a1),0)*w2'*Y2; % Local gradient dari Hidden Layer
        
        w1 = w1 + eta*Y1*Input;  % input layer neurons weight update
        w2 = w2 + eta*Y2*a1';    % hidden layer neurons weight update
        
        SE(j,k)= e*e';      % squared error
end
MSE(j)=mean(SE(j,:));       %  (mean squared error)

% Error klasifikasi pelatihan dalam %
TCE(j)=length(find((round(Output)-class_train(ind(j,:)))==0))*100/length(Output);
end

figure
semilogy(MSE)
xlabel('Epoch pelatihan')
ylabel('MSE (dB)')
title('Function obj')

figure
plot(TCE)
xlabel('Epochs pelatihan')
ylabel('Akurasi klasifikasi (%)')
title('Performance klasifikasi (Training)')

figure
plot(class_train(ind(j,:)),'or')
hold on
plot(round(Output))

legend('Kelas','Kelas yang diprediksi dengan MLP')
xlabel('Sample latih #')
ylabel('Class Label')
title('Performance klasifikasi (Training)')

Training_Accuracy=length(find((round(Output)-class_train(ind(j,:)))==0))*100/length(Output);

Output=[];

for k=1:size(test_data,1)

        Input=[1 test_data(k,:)];
       
        n1 = w1*Input';     
        a1=tansig(n1);    %%%% Fungsi Aktivasi Hidden Layer   % tansig for [-1,+1] % logsig for [0,1] 
%         
        n2 = w2*a1;
        a2=logsig(n2);    %%%% Fungsi aktivasi Layer Output
        
        Output(k)=a2;                 

end

figure
plot(class_test,'or')
hold on
plot(round(Output))
legend('Kelas','Kelas yang diprediksi dengan MLP')
xlabel('Sample Pelatihan #')
ylabel('Label Kelas')
title('(Performance Kelas(Test)')

Testing_Accuracy=length(find((round(Output)-class_test)==0))*100/length(Output);

[Training_Accuracy Testing_Accuracy]

