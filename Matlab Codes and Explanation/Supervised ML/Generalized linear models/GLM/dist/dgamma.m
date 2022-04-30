function answ=dgamma(what,y,mu,m,weights)
%DGAMMA menghitung semua jenis dari distribusi gamma
%pakai:  answ=dgamma(what,y,mu,m,weights)
%          answ  is the answer asked for.
%panggil  irls, glmfit.


if what==1,
   answ=(mu.^2)+0.00000001*(mu==0);      %dalam kasus  mu=0
   answ=answ.*(answ>0)+(answ<=0);       
elseif what==2,
   mu=mu+0.00000001*(mu==0);             %dalam kasus  mu=0
   yy=y+(y==0).*mu;                     %dalam kasus  mu=0
   answ=2*sum( weights.*(-log(yy./mu) + (y-mu)./mu ) );
end
