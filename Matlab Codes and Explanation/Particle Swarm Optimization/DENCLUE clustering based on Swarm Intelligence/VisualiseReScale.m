
load('hard') % load a dataset

%% Visualise original data
figure
if size(data,2)==2
    gscatter(data(:,1),data(:,2),class,'rgbmykc','xdo+ps*')
    box off
    set(gcf,'color','w');
else
    Matrix=pdist2(data,data,'minkowski',2);    %% plot MDS if ndata has more than 2 attributes
    Y = mdscale(Matrix,2,'criterion','stress','start','random');
    gscatter(Y(:,1),Y(:,2),class,'rgbmykc','xdo+ps*')
    box off
    set(gcf,'color','w');
end
title('Original data')
%% ReScale
psi=100
eta=0.1
[ ndata ] = Rescale( psi,eta,data);


%% Visualise scaled data
figure
if size(data,2)==2
    gscatter(ndata(:,1),ndata(:,2),class,'rgbmykc','xdo+ps*')
    box off
    set(gcf,'color','w');
else
    Matrix=pdist2(ndata,ndata,'minkowski',2);    %% plot MDS if ndata has more than 2 attributes
    Y = mdscale(Matrix,2,'criterion','stress','start','random');
    gscatter(Y(:,1),Y(:,2),class,'rgbmykc','xdo+ps*')
    box off
    set(gcf,'color','w');
end
title('ReScaled data')