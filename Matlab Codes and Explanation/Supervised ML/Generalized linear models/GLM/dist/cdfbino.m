function [y] = cdfbino(X, N, P)


zz=find(X<0);
zn=find(X>=N);
ze=[1:length(X)]';
ze([zn;zz])=[];

yy=zeros(size(N));

if zn,
   yy(zn)=ones(size(zn));
end;

if ze,
   yy(ze)=1-betainc(P(ze),X(ze)+1,N(ze)-X(ze));
end;

y=yy;
