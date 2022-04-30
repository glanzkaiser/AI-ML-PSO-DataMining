function answ=lcomplg(input1,input2,what)
%LCOMPLOG menghitung semua jenis untuk comp log-log link functions:
%pakai:  answ=lcomplg(input1, input2, what)
%   dimana  y adalah vektor y yang diamati;
%          input1 adalah input1 yang dibutuhkan;
%       
%          answ  solusi nya
%dipanggil glmfit dan irls.


%  input2 hanya digunakan untuk binomial(logit/complg) cases, saat input2=m.
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
   mu=mu-(mu==m)*0.01; mu=mu+(mu==0)*0.01;
   answ=log( -log( 1- mu./m) );
elseif strcmp(what,'mu'),
   answ=m .* (1-exp( -exp(eta)));
else
   mu=mu-(mu==m)*0.01; mu=mu+(mu==0)*0.01;
   answ=1./ ((mu-m).*log( 1- (mu./m)));
end;
