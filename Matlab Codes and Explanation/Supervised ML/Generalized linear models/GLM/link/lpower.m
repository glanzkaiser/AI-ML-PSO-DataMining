function answ=lpower(input1,input2,what)
%LPOWER kalkulasikan semua fungsi power link
%pakai:  answ=lpower(input1, input2, what)
%   dimana y adalah vektor y yang diamati
%       
%          answ  adalah solusi
%panggil glmfit and irls.

%  input2 untuk binomial (logit/complg) saat input2=m.
%  untuk finding eta,           input1 = mu
%  untuk finding mu,            input1 = eta
%  untuk finding d(eta)/d(mu),  input1 = mu

extrctgl;
if ~isstr(link), pw=link; link='power';end;

m=input2;
if strcmp(what,'mu'),
   eta=input1;
else
   mu=input1;
end;

if strcmp(what,'eta'),
   answ=mu.^pw;
elseif strcmp(what,'mu'),
   eta=eta.*(eta>0)+(eta<=0);
   answ=exp(1/pw * log(eta));
else
   mu=mu.*(mu>0)+(mu<=0);
   answ=pw.*mu.^(pw-1);
end;
