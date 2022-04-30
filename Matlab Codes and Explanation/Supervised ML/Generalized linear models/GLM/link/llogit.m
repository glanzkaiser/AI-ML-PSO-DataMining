function answ=llogit(input1,input2,what)
%LLOGIT kalkulasikan semua fungsi logit
%pakai:  answ=llogit(input1, input2, what)
%   dimana  y  adalah vektor yang diamati

%panggil glmfit and irls.

%  input2 hanya untuk binomial (logit/complg) saat  input2=m.
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
   mu=mu-(mu>m-0.0001)*0.0001;mu=mu+(mu<0.0001)*0.0001;
   answ=log( mu./(m-mu));
elseif strcmp(what,'mu'),
   answ=m.*exp(eta)./(1+exp(eta)); 
   nan=isnan(answ)|(answ>1000);
   if any(nan), answ(nan)=1000*ones(size(answ(nan)));end;
else
   mu=mu-(mu>m-0.0001)*0.0001;mu=mu+(mu<0.0001)*0.0001;
   answ=m./(mu .*(m-mu));
end;
