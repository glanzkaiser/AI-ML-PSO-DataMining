
ndata=10;
kwidth=1;
xTrain=linspace(-1,1,ndata)';
yTrain=xTrain.^2+(0.1/2)*randn(ndata,1);

figure(1),grid on,hold on,plot(xTrain,yTrain);
plot(xTrain,yTrain,'bo');


regulizer =0.001*eye(ndata);
TensorOut = calcTensor(ndata,ndata,xTrain,xTrain,kwidth);
figure(2),imagesc(TensorOut);


%% solusi

theta=inv(TensorOut'*TensorOut+regulizer)*TensorOut*yTrain;


%uji
ntest=100;
xTest=linspace(-1,1,ntest)';
TensorTest= calcTensor(ndata,ntest,xTrain,xTest,kwidth);
ypred=TensorTest'*theta;

figure(1),plot(xTest,ypred,'r');
