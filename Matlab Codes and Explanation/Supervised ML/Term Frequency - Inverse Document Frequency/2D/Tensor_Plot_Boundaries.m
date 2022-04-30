function Tensor_Plot_Boundaries(f,BR,BC)

color='white';
figure;
imshow(log(1+abs(fftshift(fft2(f)))),[]);
[r,c]=size(f);

%plot batasan vertikal 
for i=1:length(BR)
   hold on
   p1 = [1 round(c*0.5*(1+BR(i)/pi))];
   p2 = [r round(c*0.5*(1+BR(i)/pi))];
   plot([p1(2),p2(2)],[p1(1),p2(1)],'Color',color,'LineWidth',2)
   hold on
   p1 = [1 round(c*0.5*(1-BR(i)/pi))];
   p2 = [r round(c*0.5*(1-BR(i)/pi))];
   plot([p1(2),p2(2)],[p1(1),p2(1)],'Color',color,'LineWidth',2)
end

%plot batasan horizontal
for i=1:length(BC)
   hold on
   p1 = [round(r*0.5*(1+BC(i)/pi)) 1];
   p2 = [round(r*0.5*(1+BC(i)/pi)) c];
   plot([p1(2),p2(2)],[p1(1),p2(1)],'Color',color,'LineWidth',2)
   hold on
   p1 = [round(r*0.5*(1-BC(i)/pi)) 1];
   p2 = [round(r*0.5*(1-BC(i)/pi)) c];
   plot([p1(2),p2(2)],[p1(1),p2(1)],'Color',color,'LineWidth',2)
end