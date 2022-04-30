% NAIVE BAYES CLASSIFIER

clear
tic
disp('--- start ---')

distr='normal';
distr='kernel';

% baca data
White_Wine = dataset('xlsfile', 'White_Wine.xlsx');
X = double(White_Wine(:,1:11));
Y = double(White_Wine(:,12));

% Buat cvpartition objek yang menjelaskan fold
c = cvpartition(Y,'holdout',.2);

% Membuat data training
x = X(training(c,1),:);
y = Y(training(c,1));
% test set
u=X(test(c,1),:);
v=Y(test(c,1),:);

yu=unique(y);
nc=length(yu); % Jumlah kelas
ni=size(x,2); % Variabel independen
ns=length(v); % test set

% komputasi probabilitas kelas
for i=1:nc
    fy(i)=sum(double(y==yu(i)))/length(y);
end

switch distr
    
    case 'normal'
        
        % normal distribution
        % parameter dari data latih
        for i=1:nc
            xi=x((y==yu(i)),:);
            mu(i,:)=mean(xi,1);
            sigma(i,:)=std(xi,1);
        end
        % probabilitas dari data uji
        for j=1:ns
            fu=normcdf(ones(nc,1)*u(j,:),mu,sigma);
            P(j,:)=fy.*prod(fu,2)';
        end

    case 'kernel'

        % distribusi kernel
        % probabilitas data uji diestimasi dari data latih 
        for i=1:nc
            for k=1:ni
                xi=x(y==yu(i),k);
                ui=u(:,k);
                fuStruct(i,k).f=ksdensity(xi,ui);
            end
        end
        % re-structure
        for i=1:ns
            for j=1:nc
                for k=1:ni
                    fu(j,k)=fuStruct(j,k).f(i);
                end
            end
            P(i,:)=fy.*prod(fu,2)';
        end

    otherwise
        
        disp('invalid distribusi')
        return

end

% prediksi output
[pv0,id]=max(P,[],2);
for i=1:length(id)
    pv(i,1)=yu(id(i));
end

% bandingkan prediksi output dengan aktual output
confMat=myconfusionmat(v,pv);
disp('confusion matrix:')
disp(confMat)
conf=sum(pv==v)/length(pv);
disp(['accuracy = ',num2str(conf*100),'%'])

toc