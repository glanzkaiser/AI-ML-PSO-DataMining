function Show_EWT(ewt,f,rec)

figure;
x=0:1/length(ewt{1}):(length(ewt{1})-1)/length(ewt{1});
l=1;
if length(ewt)>6
    lm=6;
else
    lm=length(ewt);
end

for k=1:length(ewt)
   hold on; subplot(lm,1,l); plot(x,ewt{k}); %axis off;
   if mod(k,6) == 0
        figure;
        l=1;
   else
    l=l+1;
   end
end

if nargin>1
    figure;
    subplot(2,1,1);plot(x,f);
    subplot(2,1,2);plot(x,rec);
end
