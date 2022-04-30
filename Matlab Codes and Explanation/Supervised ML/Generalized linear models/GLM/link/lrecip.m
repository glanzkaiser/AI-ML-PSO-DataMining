function answ=lrecip(input1,input2,what)
%LRECIP kalkulasikan fungsi link reciprocal
%USE:  answ=lrecip(input1, input2, what)
%   dimana y adalah vektor y yang diamati
%        
%          answ adalah solusi
%panggil glmfit and irls.

%  input2 digunakan untuk binomial (logit/complg) saat  input2=m.
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
   mu=mu+(mu==0);
   answ=1./mu;
elseif strcmp(what,'mu'),
   eta=eta+(eta==0);
   answ=1./eta;
   answ=answ.*(answ>0)+(answ<=0); % mu>0
else
   mu=mu+(mu==0);
   answ=-1./(mu.^2);
end;
