function [y] = cdfpoiss(X, lambda)
% CDFPOISS mengembalikan poisson kumulative
%     
% pakai: [y] = cdfpoiss(X,LAMBDA)
%	where  X adalah vektor yang diamati 
%              LAMBDA  adalah vektor rata-rata
%              y adalah vektor cdfs 



for j=1:length(X),

   x=X(j);

   if (x<0),

      y(j) = 0;				%If x<0, cdf = 0

   else

      pdf(j)=exp(-lambda(j)); cdf(j)=pdf(j);
      for i=1:x,
         pdf(j)=pdf(j)*lambda(j)/(i);
         cdf(j)=cdf(j)+pdf(j);
      end;
      y(j) = cdf(j);

   end;

end;

y=y';
