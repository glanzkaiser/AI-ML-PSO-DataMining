function A=diagm(D,B)
%DIAGM melipatgandakan D, matriks diagonal sebagai baris dari element doag dengan matriks B
%pakai: A=diagm(D,B)
%   dimana D adalah element diagonal dari matriks diagonal
%          B  adalah matriks yang cocok 
%          A  adalah hasil pelipatgandaan


%check error
if length(D)~=size(B,1),
   error('Matrix sizes are not compatible.');
end;
%akhir dari check error

A=zeros(length(D),size(B,2));

for i=1:length(D),
   A(i,:)=D(i)*B(i,:);
end;
