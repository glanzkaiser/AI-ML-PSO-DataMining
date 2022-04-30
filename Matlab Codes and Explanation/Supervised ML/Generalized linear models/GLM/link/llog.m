function answ=llog(input1,input2,what)
%LLOG hitung semua log link fuction
%pakai:  answ=llog(input1, input2, what)
%   dimana  y  adlah vektor yang diamati
%          input1 adalah input1 yang dibutuhkan
%     
%          answ  adalah solusi

%  input2 is only used for binomial (logit/complg) cases, when  input2=m.
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
   mu=mu.*(mu>0)+(mu<=0);
   answ=log(mu);
elseif strcmp(what,'mu'),
   answ=exp(eta);
else
   mu=mu+0.001*(mu==0);
   answ=1./mu;
end;
