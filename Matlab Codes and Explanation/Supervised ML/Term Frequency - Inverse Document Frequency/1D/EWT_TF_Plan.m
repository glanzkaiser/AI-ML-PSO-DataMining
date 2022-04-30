function tf=EWT_TF_Plan(ewt,boundaries,Fe,sig,rf,rt,resf,color)
% fix parameter default jika dibutuhkan 
if (rf<1)
    rf=1;
elseif isempty(rf)
    rf=1;
end

if (rt<1)
    rt=1;
elseif isempty(rt)
    rt=1;
end

if (Fe<0)
    Fe=1;
elseif isempty(Fe)
    Fe=1;
end

if (resf<1)
    resf=1;
elseif isempty(resf)
    resf=1;
end

if isempty(color)
    color=1;
elseif (color~=1) && (color~=0)
    color=1;
end

% komputasikan komponen (amplitude dan frequencies)
hilb=EWT_InstantaneousComponents(ewt,boundaries);

Nt=length(hilb{1}{2});
Nf=round(length(hilb{1}{2})/(2*resf));
tf=zeros(Nf,Nt);
for c=1:size(hilb,1)
   requantified=floor(hilb{c}{2}*(Nf-1)/pi)+1;
   requantified(requantified>Nf)=Nf;
   for t=1:Nt
        M=max(hilb{c}{1}(:));
        m=min(hilb{c}{1}(:));
        
        tf(requantified(t),t)=255*(hilb{c}{1}(t)-m)/(M-m);
   
   end
end

% Siapkan figure
tq = 1:floor(Nt/rt);
t=(tq-1)/Fe;

if color == 0
    figure('colormap', 1.-gray);
else
    figure;
end


if isempty(sig)
    imagesc(t,[0,0.5*Fe/rf],tf(1:floor(end/rf),tq));
    xlabel('time (s)')
    ylabel('frequency (Hz)')   
    set(gca,'YDir','normal')
else 
    subplot(6,1,2:6);
    imagesc(t,[0,0.5*Fe/rf],tf(1:floor(end/rf),tq));
    
    set(gca,'YDir','normal')
    xlabel('time (s)')
    ylabel('frequency (Hz)')

    if color==0
        subplot(6,1,1); plot(t,sig(tq),'Color','Black');
    else
        subplot(6,1,1); plot(t,sig(tq));
    end
    axis([t(1) t(end) min(sig) max(sig)]);
end

