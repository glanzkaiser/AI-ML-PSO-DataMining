function answ=lprobit(input1,input2,what)
%LPROBIT kalkulasikan fungsi probit link
%pakai:  answ=lprobit(input1, input2, what)
%   dimana y adalah vektor y yang diamati
%        
%panggil glmfit and irls.

%  input2 is only used for binomial (logit/complg/probit) cases, when  input2=m.
%  untuk finding eta,           input1 = mu
%  untuk finding mu,            input1 = eta
%  untuk finding d(eta)/d(mu),  input1 = mu

m=input2;
if strcmp(what,'mu'),
   eta=input1;
else
   mu=input1;
end;

if strcmp(what,'eta'),
   answ=sqrt(2)*erfinv(2*(mu./m)-1);
elseif strcmp(what,'mu'),
   answ=m.*(1+erf(eta/sqrt(2)))/2;
else
   answ=(sqrt(2*pi)./m).*exp((erfinv((2*mu./m)-1)).^2);
end;
