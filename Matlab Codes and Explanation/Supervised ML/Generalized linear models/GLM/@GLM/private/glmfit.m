function [ obj ] = glmfit(obj,yvar,xvar,wvar,ovar)
%pakai: [beta,serrors,fits,res,covarbeta,covdiff,devlist,linpred]=glmfit(y,x)
%   kalo  y  is variabel penerima
%             (Untuk binomial penerima, y punya 2 kolom; pertama y kedua samples sizes
%          x  is matriks kovariat
%             (jumlah kolom x adalah nomor variabel
%          beta berisi estimasi parameter
%          serrors   adalah error standar
%          fits  adalah nilai yg dicocokan;
%          covarbeta  covariance matrix dari parameter terestimasi;
%          res  adalah residual standar:
%             (y-fits)*sqrt(prior wt / (scale parameter*variance function))
%          covdiff  adalah var/matriks kovarian dari parameter standar
%          devlist  adalah vrktor residual untuk iterasi.
%          linpred  adalah presiktor lineara
%          xnames adalah array string dari nama variabel
%
% Tiap vektor y dan x punya ukuran yang sama; ukuran yang diamati.
%
% Hanya y yang dibutuhkan. 
%
%Set
covarbeta=[];
covdiff=[];
y=yvar;
fprintf('\n');

%beberapa yg diperlukan
[yrows,ycols]=size(y);

if nargin < 4 || isempty(wvar)
    wvar = ones(yrows,1);
end
if nargin < 5 || isempty(ovar)
    ovar = zeros(yrows,1);
end

%Buat tiap baris diamati
%Tidak bisa gunakan y=y(:) sejak binomial punya 2 kolom 
if yrows<ycols, 
   y=y';
end;

ylen=length(y);

if ycols==2,                %Binomial case: Bagikan penerima dan ukuran yg dicontohkan
   m=y(:,2);
   y=y(:,1);
else
   m=ones(size(y));
end;
m=m(:);

if exist('rownamexv')==1,   %rownamexv = GLMLAB_INFO_{13}
   namelist=rownamexv;
end;

%X variables names
if strcmp(obj.Intercept,'on'),    %Kalau include_constant, tag kan
   x=[ones(yrows,1),xvar];
   if ismember('(Intercept)',obj.Xlabel) == 0
        obj.Xlabel = ['(Intercept)', obj.Xlabel];
   end
else
   x=xvar;
end;

zerowts=sum(wvar==0);			%Jumlah point dengan zero wight
effpts=ylen-zerowts;			%Efektifkan jumlah point

% Bobot juga sbagai form yang kecil
w = wvar;
o = ovar;

[beta,mu,xtwx,devlist,~,eta] = irls(obj,y,x,w,m,o,true);

% Kalkulasikan statistik lainnya.
if ~isempty(devlist),               %Kalau kosong, error
   curdev = devlist(end);           
   curdf = effpts-length(beta);     %df untuk model yg sama
   if (curdf<0), 		    %kalau estimasi lebih dari point
      curdf=0;
   end;
   if (strcmp(obj.Distribution,'normal') || ...
           strcmp(obj.Distribution,'gamma') ) && (curdf==0),
      dispers = Inf;                 %Jika tidak berikan peringatan
   else
      if ~ischar(obj.Scale),
         dispers = obj.Scale;
      else
         dispers = curdev/curdf;
      end;
   end;
   covarbeta = real(pinv(xtwx)*dispers);
   
   % Update
   devlist=[devlist;curdev];
   
   %Tampilkan hasil
   if strcmp(obj.Display,'on'), %Tampilkan parameter

        line=' ============================================================';
        if strcmp(obj.ShowEquation,'on')
            total = 11;
            total = total + length(obj.Ylabel);
            total = total + length(strjoin(obj.Xlabel));
            total = total + length(obj.Link);
            total = total + 2*length(obj.Xlabel);
            total = total + 3*(length(obj.Xlabel)-1);
            sline = [' ' repmat('-',1,total)];
            disp(sline);
            fprintf('    dependent: %s',obj.Ylabel);
            fprintf('\n  independent: %s',strjoin(obj.Xlabel,','));
            fprintf('\n');
            disp(sline);
            fprintf('  %s(E[%s]) = ',obj.Link,obj.Ylabel);
            for v = 1:length(obj.Xlabel)
                if v > 1
                    fprintf(' + ');
                end
                fprintf('ß%d×%s',v,obj.Xlabel{v});
            end
            fprintf('\n');
            disp(sline);
        else
            fprintf('\n');
        end
        fprintf(' distribution: %s',upper(obj.Distribution));
        fprintf('\n         link: %s',upper(obj.Link));
        fprintf('\n       weight: %s',obj.Wlabel);
        fprintf('\n       offset: %s',obj.Olabel);
        fprintf('\n');
        disp(line);
        disp('     Variable    Estimate     S.E.    z-value    Pr(>|z|)');
        disp(line);

        for k = 1:size(x,2)
            name = obj.Xlabel{1,k}(1:min(12,end));
            se = sqrt(covarbeta(k,k));
            zval = beta(k)/se;
            pval = 2*(1-cdfnorm(abs(zval),0,1));
            fprintf('  %12s   %8.3f   %7.3f   % 3.3f \t %3.5f\n',name,beta(k),se,zval,pval);
        end
        disp(line);
   end

    k = 1; %Scale parameter digunakan
    if ~isempty(obj.Scale), 
        if ~ischar(obj.Scale), 
            k=obj.Scale; 
        end; 
    end;

    % Kalkulasikan residual
    res = findres(obj,y,m,mu,k,wvar,lower(obj.Residual));

    % Kalkulasikan deviance
    if ischar(obj.Scale), 
       sdev = curdev;
    else 
       sdev = curdev/obj.Scale; 
    end;
    
    % Hitung model kosong
    [~,~,~,iclist,~,~] = irls(obj,y,ones(ylen,1),w,m,o,false);
    nullDeviance = iclist(end);

    % Hitung output lain
    McFaddenR2 = 1 - curdev/nullDeviance;
    MSE_deviance = mean(findres(obj,y,m,mu,k,wvar,'deviance').^2);
    MSE_pearson  = mean(findres(obj,y,m,mu,k,wvar,'pearson').^2);
    DIC = curdev + var(findres(obj,y,m,mu,k,wvar,'deviance'));
    
    covdiff=zeros(size(covarbeta));
    for ii=1:length(covarbeta),
        for jj=ii+1:length(covarbeta),
            cvd=real(sqrt(covarbeta(ii,ii)+covarbeta(jj,jj)-2*covarbeta(ii,jj)));
            covdiff(ii,jj)=cvd;
            covdiff(jj,ii)=cvd;
        end;
    end;
    
    if strcmp(obj.Display,'on'), %Tampilkan parameter estimasi
        fprintf('  Residual deviance:  %9.4f     Deviance MSE: %-5.4f\n',sdev,MSE_deviance);
        fprintf('  Null deviance:      %9.4f     Pearson MSE:  %-5.4f\n',nullDeviance,MSE_pearson);

        if ~isfinite(dispers),
          fprintf('  Dispersion parameter cannot be found: 0 degrees of freedom.\n');
        else
          fprintf('  Dispersion:         %9.4f     Deviance IC:  %-5.4f\n',dispers,DIC);
        end;
        fprintf('  McFadden R^2:       %9.4f     Residual df:  %-5.0f\n',McFaddenR2,curdf);
        
        disp(line);
        disp(' ');

        if ~isfinite(dispers)
           disp(' WARNING:  Non-finite dispersion.');
        end
    end
else
    errordlg('The model cannot be fitted sensibily; check the inputs and settings.',...
            'Model not fitted.')
    res = [];
end

% Simpan output ke object
obj.Y = y;
obj.X = x;
obj.W = w;
obj.Beta = beta;
obj.StErrors = diag(covarbeta);
obj.Fitted = mu;
obj.FittedEta = eta;
obj.XWX = xtwx;
obj.Df = curdf;
obj.ResidDeviance = curdev;
obj.NullDeviance = nullDeviance;
obj.McFaddenR2 = McFaddenR2;
obj.MSE_deviance = MSE_deviance;
obj.MSE_pearson = MSE_pearson;
obj.Dispersion = dispers;
obj.Residuals = res;
obj.BetaCov = covarbeta;
obj.DiffCov = covdiff;
obj.DIC = DIC;

end

