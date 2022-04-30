function result = daisy(x,vtype,metric)

if (nargin<2)
    error('Two input arguments required')
elseif (nargin<3)
    if (sum(vtype)~=4*size(x,2))
        metric = 'mixed';
        metr = 0;
    else
        metric = 'eucli';
        metr = 1;
    end
elseif (nargin==3)
    if strcmp(metric,'eucli')
        metr=1;
    elseif strcmp(metric,'manha')
        metr=2;
    elseif strcmp(metric,'mixed')
        metr=0;
    end
end

%Standardizing in case of mixed metric
if (sum(vtype)~=4*size(x,2))
    colmin = min(x);
    colextr = max(x)-colmin;
    x = (x - repmat(colmin,size(x,1),1))./repmat(colextr,size(x,1),1);
end

%Replacement of missing values
jtmd = repmat(1,1,size(x,2))-2*(sum(isnan(x))>0);
valmisdat = min(min(x))-0.5;
x(isnan(x)) = valmisdat;
valmd = repmat(valmisdat,1,size(x,2));

%Actual calculations
disv=daisyc(size(x,1),size(x,2),x,valmd,jtmd,vtype,metr);

%Putting things together
result = struct('disv',disv,'metric',metric,'number',size(x,1));


