function [block,Clst,inx] = FindRowCol_HML(D,n)
[maxD,inx] = max(D);
k = ((2*n+1)-sqrt((2*n-1)^2-8*(inx-1)))/2;
k = floor(k);
Low  = (k-1)*n-(k-1)*k/2+1;
block = k; % baris matriks
Clst = inx - (Low-1) + block; % inx - (k-1)*n + k*(k+1)/2; kolom matriks
end

