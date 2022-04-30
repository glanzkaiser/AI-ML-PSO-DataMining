function Show_EWT2D_Curvelet(ewtc)

Ns=length(ewtc);

% tampilkan LPL low pass filter
figure;
imshow(ewtc{1},[]);


for s=2:Ns
   Nt=length(ewtc{s});
   figure;
   Nr=ceil(sqrt(Nt));
   for t=1:Nt
      subplot(Nr,Nr,t);
      imshow(ewtc{s}{t},[]);
   end
end