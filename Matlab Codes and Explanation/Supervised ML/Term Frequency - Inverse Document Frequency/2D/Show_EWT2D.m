function Show_EWT2D(ewt)

p=ceil(length(ewt)/2);

figure;
for n=1:length(ewt)
    subplot(2,p,n);imshow(ewt{n},[]);
end