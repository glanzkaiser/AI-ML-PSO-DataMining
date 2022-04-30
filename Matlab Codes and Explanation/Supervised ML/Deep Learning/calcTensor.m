
function TensorOut = calcTensor(nDataA,nDataB,xtrain,xtest,kwidth)

TensorOut=zeros(nDataA,nDataB);

for(ii=1:nDataA)
    for(jj=1:nDataB)
        TensorOut(ii,jj)=calcphi(xtrain(ii),xtest(jj),kwidth);
   end
end