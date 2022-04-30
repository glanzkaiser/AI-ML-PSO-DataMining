function answ=lid(input1,input2,what)
%LID menghitung semua jenis id link functions:
%pakai:  answ=lid(input1, input2, what)
% dimana  y  is the vektor y yang diamati
%     
%          answ adalah solusinya

%  input2 adalah binomial (logit/complg) cases, saat  input2=m.
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
   answ=mu;
elseif strcmp(what,'mu'),
   answ=eta;
else
   answ=ones(size(mu));
end;
