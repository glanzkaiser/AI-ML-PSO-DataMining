function ShowCurveletFilters(mfb)

mfb{1}=fftshift(mfb{1});
sum=mfb{1}.^2;
for s=2:length(mfb)
   for a=1:length(mfb{s})
     	mfb{s}{a}=fftshift(mfb{s}{a});
      	sum=sum+mfb{s}{a}.^2;
   end
end

Show_EWT2D_Curvelet(mfb)
figure;imshow(255*sqrt(sum));
