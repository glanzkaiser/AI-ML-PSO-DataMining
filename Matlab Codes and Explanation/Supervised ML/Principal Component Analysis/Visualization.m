clc
clear all;

load iris;
[r,c]=size(data);

% hitung ratarata dari matriks data
m=mean(data')';

% kurangi matrik data dengan matrik rata-rata m
d=data-repmat(m,1,c);

% hitung matriks kovariannya
co=1 / (c-1)*d*d';

% hitung eigen value dan eigen vector dari cov matriksnya
[eigvector,eigvl]=eig(co);



