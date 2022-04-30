function answ=dbinomial(what,y,mu,m,weights)
%DBINOMIAL mengkalkulasi semua jenis distribusi binomial
%USE:  answ=dinv_gsn(what,y,mu,m,weights)
%   dimana  y,  mu,  m dan bobot;
%          answ  adalah solusi yang diinginkan
%panggil  irls, glmfit.

if what==1,
   mu=mu+0.0001*(mu<0.0001); mu=mu-0.0001*(mu>m-0.0001);
   answ=mu-(mu.^2 ./ m);
elseif what==2,
   %lim(x->0) x*ln(x)=0 menghasilkan NaN
   mu=mu+(mu==0);yfix=y+(y==0).*mu;
   part1=yfix.*log(yfix./mu);
   mmmu=(m-mu)+(m==mu);
   yy=m-y; yy=yy+(yy==0).*(mmmu);
   part2=yy.*log(yy./mmmu);
   answ=2*sum(weights.*(part1+part2));
end;
