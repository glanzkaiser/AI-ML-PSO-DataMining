function x=invnorm(p,mu,sigma)
%INVNORM  Inverse cumulative normal ditsribution
%pakai:  x=invnorm(p,mu,sigma)
%  dimana x adalah invers dari distribusi normal kumulatif
%        p  adalah probabilitas
%        mu adalah mean
%        sigma adalah standard deviasi


if nargin<3,
   sigma=1;
end;
if nargin==1,
   mu=0;
end;

%check error
if ~(sigma>0), 
   error('sigma  harus positive!'); 
end;
if size(p)~=size(mu) | size(p)~=size(sigma),
   error('Inputs arguments harus sama dengan size!');
end;
%hasil errror

x = mu + sqrt(2)*sigma.*erfinv(2*p-1);
