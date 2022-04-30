function Show_EWT_Boundaries(magf,boundaries,R,SamplingRate,InitBounds,presig)

figure;
freq=2*pi*[0:length(magf)-1]/length(magf);

if SamplingRate~=-1
    freq=freq*SamplingRate/(2*pi);
    boundaries=boundaries*SamplingRate/(2*pi);
end

if R<1
    R=1;
end
R=round(length(magf)/(2*R));
plot(freq(1:R),magf(1:R));
hold on
if nargin>5
   plot(freq(1:R),presig(1:R),'color',[0,0.5,0],'LineWidth',2); 
end
NbBound=length(boundaries);
 
for i=1:NbBound
     if boundaries(i)>freq(R)
         break
     end
     line([boundaries(i) boundaries(i)],[0 max(magf)],'LineWidth',2,'LineStyle','--','Color',[1 0 0]);
end
 
if nargin>4
    NbBound=length(InitBounds);
    InitBounds=InitBounds*2*pi/length(magf);
    
    for i=1:NbBound
        if InitBounds(i)>freq(R)
            break
        end
        line([InitBounds(i) InitBounds(i)],[0 max(magf)],'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
    end
end
