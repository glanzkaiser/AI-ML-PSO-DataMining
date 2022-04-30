function p=cdfnorm(x,mu,sigma)
%CDFNORM distribusi normal
%pakai: p=cdfnorm(x,mu,sigma)
%   where  p  is the probability;
%          x  adalah nilai cdf dihitung 
%          mu  adalah mean (defaultnya nol)
%          sigma adalah standar deviasi (defaultnya satu) 

if nargin<3, 
   sigma=1; 
end;

if nargin==1, 
   mu=0; 
end;

%error checks
if ~(sigma>0), 
   error('sigma must be positive!'); 
end;

if (size(x)~=size(mu)) | (size(x)~=size(sigma)),
   error('Inputs arguments must be the same size!');
end;
%akhir check error

p=0.5* (1+erf( (x-mu) ./ (sigma * sqrt(2)) ) );

big=find(p>1);
if any(big), 
   p(big)=ones(size(big)); 
end;
