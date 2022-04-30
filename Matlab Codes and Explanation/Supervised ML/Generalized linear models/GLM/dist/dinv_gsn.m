function answ=dinv_gsn(what,y,mu,m,weights)
%DINV_GSN informasi distribusi dari distribusi gaussian invers
%pakai:  answ=dinv_gsn(what,y,mu,m,weights)
%   dimana y,  mu,  m and  weights cocok.
%             s
%          answ adalah hasil yg dibutuhkan 

if what==1,
   answ=mu.^3;
elseif what==2;
   answ=sum( (weights.*(y-mu).^2)./(mu.^2 .*y));
end;
