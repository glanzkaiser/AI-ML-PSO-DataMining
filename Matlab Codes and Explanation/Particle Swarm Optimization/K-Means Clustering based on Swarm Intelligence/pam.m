function result = pam(x,kclus,vtype,stdize,metric,silhplot)

res1=[];
if (nargin<2)
    error('Two input arguments required')
elseif ((nargin<3) & (size(x,2)~=1) & (size(x,1)~=1))
    error('Three input arguments required')
elseif (nargin<3)
    if (size(x,2)==1)
        x = x';
    end
    res1.metric = 'unknown';
    res1.disv = x;
    lookup=seekN(x);
    res1.number = lookup.numb;   %(1+sqrt(1+8*size(x,1)))/2;
    stdize = 0;
    silhplot = 0;
elseif (nargin<4)
    stdize = 0;
    silhplot = 0;
    if (sum(vtype)~=4*size(x,2))
        metric = 'mixed';
    else
        metric = 'eucli';
    end
elseif (nargin<5)
    silhplot = 0;
    if (sum(vtype)~=4*size(x,2))
        metric = 'mixed';
    else
        metric = 'eucli';
    end
elseif (nargin<6)
    silhplot = 0;
end

%Replacement of missing values
for i=1:size(x,1)
    A=find(isnan(x(i,:)));
    if (~(isempty(A)))
        for j=A
            valmisdat=0;
            for c=1:size(x,2)
                if (c~=j)
                    [a,b] = sort(x(:,c));
                    if (~isempty(b(find(a==x(i,c)))))
                        valmisdat=valmisdat+find(a==x(i,c));
                    end
                end
            end
            x(i,j)=prctile(x(isnan(x(:,j))==0,j),100*valmisdat/(size(x,1)*(size(x,2)-1)));
        end
    end
end

%Standardization
if ((stdize==1) & (strcmp(metric,'eucli')))
    x = ((x - repmat(mean(x),size(x,1),1))./(repmat(std(x),size(x,1),1)));
elseif ((stdize==2) & (strcmp(metric,'eucli')))
    x = ((x - repmat(median(x),size(x,1),1))./(repmat(mad(x),size(x,1),1)));
end

%Calculating the dissimilarities with daisy
if (isempty(res1))
    res1=daisy(x,vtype,metric);
end

%Actual calculations (the second for latter use with CLUSPLOT)
[dys,ttd,ttsyl,idmed,obj,ncluv,clusinf,sylinf,nisol]=pamc(res1.number,kclus,[0 res1.disv]');
dys=res1.disv(lowertouppertrinds(res1.number));

%Create a silhouetteplot
if (silhplot==1)
    Y=sylinf(:,3);
    Y1=flipdim(Y,1);
    whitebg([1 1 1]);
    % we calculate b="a but with a bar with length zero if the objects
    % are from another cluster"
    % and h="objects but with a 0 between 2 clusters"="g with a 0 if
    % it is a sparse between 2 clusters"
    a=flipdim(Y1,1);
    b=[];
    g=sylinf(:,4);
    f=sylinf(:,1)-1;
    for j=1:res1.number
        b(j+f(j))=a(j);
        h(j+f(j))=g(j);
    end
    b1=flipdim(b,2);
    h1=flipdim(h,2);
    % we use this b1 and h1 to plot the barh (instead of a and g)
    barh(b1,1);
    title 'Silhouette Plot of Pam' ;
    xlabel('Silhouette width');
    YT=1:res1.number+(sylinf(res1.number,1)-1);
    set(gca,'YTick',YT);
    set(gca,'YTickLabel',h1);
    axis([min([Y' 0]),max([Y' 0]),0.5,res1.number+0.5+f(res1.number)]);
elseif ((silhplot~=0) & (silhplot~=1) & (nargin==6))
    error('silhplot must equals 0 or 1')
end


%Putting things together
result = struct('dys',dys,'metric',res1.metric,'number',res1.number,...
    'ttd',ttd,'ttsyl',ttsyl,'idmed',idmed,'obj',obj,'ncluv',ncluv,...
    'clusinf',clusinf,'sylinf',sylinf,'nisol',nisol,'x',x);

%------------
%SUBFUNCTIONS

function dv = lowertouppertrinds(n)

dv = [];
for i=0:(n-2)
    dv = [dv cumsum(i:(n-2))+repmat(1+sum(0:i),1,n-i-1)];
end

%---
function outn = seekN(x)

ok=0;
numb=0;
k=size(x,2);
sums=cumsum(1:k);
for i=1:k
    if(sums(i)==k)

        numb=i+1;
        ok=1;
    end
end
outn=struct('numb',numb,'ok',ok);
