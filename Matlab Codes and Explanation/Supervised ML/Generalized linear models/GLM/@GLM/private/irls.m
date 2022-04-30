function [b,mu,xtwx,devlist,l,eta]=irls(obj,y,x,w,m,o,display)
%IRLS Iteratively reweighted least squares untuk with glmlab
%pakai: [b,mu,xtwx,devlist,l,eta]=irls(y,x,m)
%   dimana y adalah vektor y yang diamati
%          x  adalah variabel x
%          m adalah vektor sample size untuk distribusi binomial  
%          b  adalah vektor paramater 
%          mu  nilai fit
%          xtwx  adalah  X'*W*X
%          devlist  adalah deviance 
%          l  adalah labels 
%          eta adalah predictor

% Load dari objek
toler = obj.toler;
maxits = obj.maxit;
illctol = obj.illctol;

%berisi informasi tentang model fit
distn=obj.Distribution;               %distribution
link=obj.Link;                        %link function
format=obj.Display;                   %output display
fitvals=obj.Fitted;                   %fitted values
weights=w;                            %prior weights
offset=o;                             %offsets


%menentukan files yang berisi distribusi dan informasi link
if ischar(link),
   linkinfo=['l',link];               %file berisi link info
else
   linkinfo='lpower';                 %link info
end;
distinfo=['d',distn];                 % distribution info

%hapus variabel dari fit 
xx=x;                                 %duplikasi
oo=offset;
mm=m;
l=alias(x,toler);                    
x=x(:,l);                           

%hapus points dengan bobot zero
if any(weights==0),                   %hapus weights==0 dari fittng

   zeroind= weights==0;
   allmat=[y,m,weights,offset,x,fitvals]; 
   allmat(zeroind,:)=[];

   if isempty(fitvals),
      x=allmat(:,5:size(allmat,2));
   else
      x=allmat(:,5:size(allmat,2)-1);
   end

   y=allmat(:,1);
   m=allmat(:,2);
   weights=allmat(:,3);
   offset=allmat(:,4);

   %check again dari aliasing
   l=alias(x,toler);
   x=x(:,l);

end;

%Mulai nilai
if strcmp(obj.Recycle,'on') && (~isempty(fitvals)),

   %jika `Recycle fitted values' opsi dipilih, pakai fitted values 
   %sebagai starting point:
   mu=fitvals;

else

  
   if strcmp(link,'logit')||strcmp(link,'complg')||strcmp(link,'probit'),
      mu= m.*(y+0.5)./(m+1); %lebihi m+1 dalam kasus umum; McC dan Nelder p 117
   elseif strcmp(link,'log')||strcmp(link,'recip'),
      mu=y+(y==0);           %hapus 0
   else
      mu=y;
   end;

end;

%inisialisasi
its=-1;                      %jumlah iterasi
devlist=[];                  %list deviasi
clear allmat

rdev=sqrt(sum( y.^2));      %residual deviance
rdev2=0;                    %enter loop

b=[zeros(size(x,2),1)];     %initial beta
b2=100*ones(size(x,2),1);   %dummy to enter loop
b(1)=-10;                   

eta=feval(linkinfo,mu,m,'eta'); %eta=Xb + offset

%iterasi
while ( ( abs(rdev-rdev2) > toler) ) && (its<maxits),

   %dimana: (rdev berubahg;atau max ) dan b masih berjalan

   detadmu=feval(linkinfo,mu,m,'detadmu');          %d(eta)/d(mu)
   vfun=feval(distinfo,1,y,mu,m,weights);           %variance function
   fwts=( 1./( (detadmu).^2) ./ vfun).*weights;     %fitting weights
   z=(eta-offset+(y-mu).*detadmu);                  %adjusted dependent var
   xtwx=x'*diagm(fwts,x);                           %X'WX

   b2=b;
   b=(xtwx)\( x'*diagm(fwts,z) );                   %beta

   eta=(x*b)+offset;                                %linear predictor, eta
   mu=feval(linkinfo,eta,m,'mu');                   %means, mu
   rdev2=rdev;                                      %residual deviance terakhir
   rdev=feval(distinfo,2,y,mu,m,weights);           %residual deviance
   its=its+1;                                       %update iterations
   devlist=[devlist;rdev];                          %jumlah deviansi untuk fits

end;

devlist(1)=[]; %hapus initial kosong

if its>=maxits,
   disp(' ');disp(' * MAXIMUM ITERATIONS REACHED WITHOUT CONVERGENCE');
   disp(['   (This is currently set at ',num2str(maxits),')']);
end;

if (rcond(xtwx)<illctol), 
   disp('              * ILL-CONDITIONED COVARIATE MATRIX');
end;

if (rcond(xtwx)<illctol)||(its==maxits),
   disp(' ---------------------------------------------------------------------'); 
   disp(' PLEASE NOTE: INACCURACIES MAY EXIST IN THE SOLUTION.');
end;

%Pesan untuk fit
if format(1),
   if (its<maxits),
      tag='';
      if its~=1, 
         tag='s';
      end;
      if display == 1
        disp([' :: convergence in ',num2str(its),' iteration',tag]);
      end
   end;
end;

x=xx(:,l); 
eta=(x*b)+oo;
mu=feval(linkinfo,eta,mm,'mu');


%%%SUBFUNCTION DIAGM
function A=diagm(D,B)
%DIAGM multiplikasikan D, sebuah matriks diagonal sebagai baris dari elemen
%diagram dengan matriks B
%pakai: A=diagm(D,B)
%   dimana D adalah elemen diagonal dari matriks diagonal 
%          B  adalah matriks yang cocok
%          A adalah hasil multiplikasi 


%error checks
if length(D)~=size(B,1),
   error('Matrix sizes are not compatible.');
end;
%end error checks

A=zeros(length(D),size(B,2));
for i=1:length(D),
   A(i,:)=D(i)*B(i,:);
end;

%%%SUBFUNCTION ALIAS
function label=alias(X,toler)


XX=X(:,1); 
i=1;label=[1];
for j=1:size(X,2);
   i=i+1; 
   XX=[XX X(:,j)];
   if det(XX'*XX)<toler,
      XX=[ XX(:,1:size(XX,2)-1) ];
   else
      label=[label j];
   end;
end;
