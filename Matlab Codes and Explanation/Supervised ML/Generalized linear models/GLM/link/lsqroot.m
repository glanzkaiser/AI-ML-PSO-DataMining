function answ=lsqroot(input1,input2,what)
%LSQROOT kalkulasikan fungsi square root link
%pakai:  answ=lsqroot(input1, input2, what)
% y adalah vektor y yang diamati
%         
%          answ adalah solusi
%panggil glmfit and irls.


%  input2 diguankan untuk binomial (logit/complg) saat  input2=m.
%  untuk finding eta,           input1 = mu
%  untuk finding mu,            input1 = eta
%  untuk finding d(eta)/d(mu),  input1 = mu

m=input2;
if strcmp(what,'mu'),
   eta=input1;
else
   mu=input1;
end;

if strcmp(what,'eta')
   mu=mu.*(mu>=0)+(mu<0);
   answ=sqrt(mu);
elseif strcmp(what,'mu'),
   answ=eta.^2;
else
   mu=mu.*(mu>0)+(mu<=0);
   answ=1./(2*sqrt(mu));
end;
