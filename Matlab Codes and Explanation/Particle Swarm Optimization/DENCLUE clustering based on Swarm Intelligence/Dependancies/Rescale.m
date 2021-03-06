function [ nndata ] = Rescale( psi,eta,data)

d=0:1/(psi):1;
[m,n]=size(data);
neigbourDen=zeros(psi+1,n);
ndata=data-data;
parfor i=1:n
    matrix = pdist2(d',data(:,i))-eta;
    b=(matrix<=0);
    neigbourDen(:,i)=sum(b,2);
end


for i=1:n
    for j=1:m
        nei=neigbourDen(:,i);
        ndata(j,i)=sum(nei(d'<=data(j,i)));
    end
end

nndata=normalize(ndata);
% nndata=ndata;
end

