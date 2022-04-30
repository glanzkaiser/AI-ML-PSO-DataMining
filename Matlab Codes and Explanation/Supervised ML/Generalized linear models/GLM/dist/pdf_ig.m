function pdf=pdf_ig(y,mu,sig2)
%pakai: pdf=pdf_ig(y,lmu,lambda)

lambda=1./sig2;

z=find(y==0);
y(z)=y(z)+eps;
pdf=sqrt(lambda./(2*pi*y.^3)).*exp( (-lambda*(y-mu).^2)./(2*mu.^2.*y) );
