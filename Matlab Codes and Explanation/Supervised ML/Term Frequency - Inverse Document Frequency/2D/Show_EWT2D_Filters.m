function Show_EWT2D_Filters(fil)

p=ceil(length(fil)/2);

figure;
for n=1:length(fil)
    subplot(2,p,n);imshow(fftshift(abs(fil{n})),[]);
end
