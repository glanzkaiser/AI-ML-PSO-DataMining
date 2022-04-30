function answ=lstyle(input1,input2,what)
%LSTYLE template untuk fungsi user defined
%pakai:  answ=lstyle(input1,input2,what)
%  dimana  input1 and input2 adalah input yan dicari
%         
%          answ adalah solusi
%panggil  irls, glmfit.

%  input2 untuk binomial (logit/complg) saat  input2=m.
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
elseif strcmp(what,'mu');
else
end;
