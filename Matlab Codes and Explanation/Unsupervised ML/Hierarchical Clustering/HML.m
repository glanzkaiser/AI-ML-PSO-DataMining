function [CLUSTER] = HML(X,CLASS,var)
% Cluster = HML(X,class,var)
%
% Hierarchical  algorithm 
%
% Input
%  X: ukuran data NxN (dmn N = jumlah sample;  d = dimensi).
% class: (optional) jika tdk dimasukkkan semua kelas dari 1 ke n
%         akan dijalankan. jika class = k , sample di klasidikasi ke kluster k saja
%batasan ukuran kelas disiapkan
%
% var: hilangkan plot put var = 0. default nilainy 1.
%
[n,d]=size(X);
tol = eps;
if nargin==1
    var=1;
    CLASS=n;
    CLUSTER = zeros(n,n);
elseif nargin==2
    var=1;
    lenCLASS = length(CLASS);
    CLUSTER = zeros(n,lenCLASS);
else
    lenCLASS = length(CLASS);
    CLUSTER = zeros(n,lenCLASS);
end

%# komputasi dimensi efektif ##
if n/4 < d
H=(1/sqrt(n))*(X-ones(n,1)*mean(X,1));
D=svd(H,0);
D=D.^2;
for j=1:length(D)
    P = sum(D(1:j))/sum(D)*100;
    if P > 90 % if lebih dari 90%
        d = j;
        break
    end
end
clear H D 
end

class=1;
s = struct('cluster',[],'Mean',[],'lambda',[]);

for j=1:n
    s(j).cluster = [j];
    s(j).Mean = X(j,:);
    s(j).lambda = ones(d,1);
end
len = length(s);

L = -0.5*1*d*(1+log(2*pi)) + 1*log(1/n);
Ltot(1) = n*L;
level(1) = n;

k=1;

if nargin==1
    CLUSTER(:,n) = cell2mat({s(:).cluster});
else
    col_cnt=lenCLASS;
end

while k<= n-class
cnt=1;
Del=zeros(1,len*(len-1)/2);
if k==1
for i=1:len-1
    for j=i+1:len
        ni = length(s(i).cluster);
        nj = length(s(j).cluster);
        D = norm((s(i).Mean - s(j).Mean)*sqrt((ni*nj)/(ni+nj)));
        D = D.^2;
        D = D(D>tol);
        D = D + (ni+nj);
        D = [D; (ni+nj)*ones(d-length(D),1)];    
        func_n = (ni+nj)*(d+2)*log(ni+nj) -2*(ni*log(ni)+nj*log(nj)); 
        func_lambda = - (ni+nj)*sum(log(D));
        Del(cnt) = func_lambda;%+func_n;
        cnt=cnt+1;
    end
end
else
   [rup,cup]=find((triu(ones(len)))');
   Del = [zeros(len+1,1),[full(sparse(rup,cup,Del1)');zeros(1,len)]];
   Del(:,Clst)=[];
   Del(Clst,:)=[];
   Del(:,block)=zeros(len,1);
   Del(block,:)=zeros(1,len);

   ni = length(s(block).cluster);
   for j=1:len
       if j~=block
          nj = length(s(j).cluster);
          if ni>1 & nj==1
            Hi = X(s(block).cluster,:) - ones(ni,1)*s(block).Mean;
            H = [Hi; (s(block).Mean - s(j).Mean)*sqrt((ni*nj)/(ni+nj))];
            D = svd(H',0);
            D = D.^2;
            D = D(D>tol);
            D = D + nj;
            D = [D; nj*ones(d-length(D),1)];
          else
            Hi = X(s(block).cluster,:) - ones(ni,1)*s(block).Mean;
            Hj = X(s(j).cluster,:) - ones(nj,1)*s(j).Mean;
            H  = [Hi;Hj;(s(block).Mean - s(j).Mean)*sqrt((ni*nj)/(ni+nj))];
            D = svd(H',0);
            D = D.^2;
            D = D(D>tol);
          end
          
          func_lambda = ni*sum(log(s(block).lambda)) + nj*sum(log(s(j).lambda)) - (ni+nj)*sum(log(D));
          func_n = (ni+nj)*(d+2)*log(ni+nj) -2*(ni*log(ni)+nj*log(nj));
          if j<block
              Del(j,block) = func_lambda + func_n;
          else
              Del(block,j) = func_lambda + func_n;
          end
       end
   end
end


% Update
if k>1
    Del = nonzeros(Del')';
end
[block,Clst,inx] = FindRowCol_HML(Del,length(s));
s(block).cluster = [s(block).cluster, s(Clst).cluster];
s(Clst) = [];
s(block).Mean = mean(X(s(block).cluster,:),1);
nb = length(s(block).cluster);
H = [X(s(block).cluster,:) - ones(nb,1)*s(block).Mean]*(1/sqrt(nb));
s(block).lambda = svd(H',0);
s(block).lambda = (s(block).lambda).^2;
s(block).lambda = s(block).lambda(s(block).lambda > tol);
len = length(s);

if nargin==1
    for j=1:n-k
        CLUSTER(s(j).cluster,n-k)=j;
    end
else
    if sum(CLASS==n-k)>0
        for j=1:n-k
            CLUSTER(s(j).cluster,col_cnt)=j;
        end 
        col_cnt = col_cnt-1;
    end
end

Del1 = Del;
k=k+1;

%## komputasi Ltot ##
    L=0;
    for nclass=1:len
        ni = length(s(nclass).cluster);
        L = L + (-0.5*ni*d*(1+log(2*pi)) -0.5*ni*sum(log(s(nclass).lambda)) +ni*log(ni/n));
    end
    Ltot(k)=L;
    level(k)=n-k+1;
    %fprintf('\nProses level = %d\n',n-k+1);
%########################
end

fprintf('\nNo. of samples = %d, d = %d\n',n,d);

PLOT_yes=1;
%############# PLOT ############
if d==2 | d==3
if var==1
  if class<=60
    if nargin>1
        cnt=1;
        for fgs=1:lenCLASS
        figure
        if d==3
            view(3);
        end
        hold on;
        S={'b.','g.','r.','c.','m.','k.','bo','go','ro','co','mo','ko',...
          'b+','g+','r+','c+','m+','k+','b*','g*','r*','c*','m*','k*',...
          'bs','gs','rs','cs','ms','ks','bd','gd','rd','cd','md','kd',...
          'b^','g^','r^','c^','m^','k^','b>','g>','r>','c>','m>','k>',...
          'bp','gp','rp','cp','mp','kp','bh','gh','rh','ch','mh','kh'};
        for j=1:CLASS(fgs)
            if d==2
                plot(X(CLUSTER(:,fgs)==j,1),X(CLUSTER(:,fgs)==j,2),char(S(j)));
            elseif d==3
                plot3(X(CLUSTER(:,fgs)==j,1),X(CLUSTER(:,fgs)==j,2),X(CLUSTER(:,fgs)==j,3),char(S(j)));
            end
        end
        title(['Cluster = ',num2str(CLASS(fgs))]);
        if d==2
            xlabel('PCA1'); ylabel('PCA2');
        elseif d==3
            xlabel('PCA1'); ylabel('PCA2');zlabel('PCA3');
        end
        hold off;
        box on;
      end
    end
  end
end
end


% Ltot vs level curve
if var==1
figure; plot(level,Ltot,'.-');title('Ltot vs level');xlabel('levels');ylabel('Ltot');
set(gca,'XDir','reverse');
end

% perbedaan Ltot vs level curve
if length(level)>1
lenEr = length(Ltot);
Diff=zeros(1,lenEr-1);
for er=1:lenEr-1
    Diff(er) = ((Ltot(er)-Ltot(er+1))/Ltot(er))*100;
end
if var==1
figure; plot(level(2:lenEr),Diff,'.-');title('Difference Ltot vs level');xlabel('levels');ylabel('Diffference Ltot %');
set(gca,'XDir','reverse');
end
end

end
%##############################
