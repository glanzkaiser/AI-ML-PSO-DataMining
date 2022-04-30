function [cls,pnode]=gclust(X,r)
%{
    X: data matrik yang mau dikluster.
 tiap baris itu = objek dalam data set
dan tiap kolom atribut objeknya
    r: jarak threshold yg  mengatur algoritma
Outputs:
    cls: vector dari kluster dari objek
    pnode: vektor dari atasnya tiap objek 
%}
[N,~]=size(X);
pnode=1:N; % semua objek 
r2=r^2; % square r untuk perbandingan cepat
%
% buat matriks konektiv
%
B=floor(N^2/20); % block size
nlist=zeros(B,2); % allocate one block
NP=0;
NPmax=B;
for i=2:N % for all i,j terutama j < i
    for j=1:i-1
        if (sum((X(i,:)-X(j,:)).^2)<=r2) % tetangga?
            NP=NP+1;
            if NP>NPmax % butuh spase lagi?
                nlist=[nlist; zeros(B,2)];
                NPmax=NPmax+B;
            end
            nlist(NP,1)=i;
            nlist(NP,2)=j;
        end
    end
end
if NP==0 % r terlalu kecil?
    cls=1:N; % tiap objek ada kelas nya
    return
end
%
% buat graph yang terhubung
%
G=graph(nlist(1:NP,1),nlist(1:NP,2),[],N);

nbrs=degree(G); % hitung tetangga
for n=1:N
    for m=neighbors(G,n)' % cari tetangga terdekat
        if (nbrs(m)>nbrs(pnode(n))) ||...
                ((nbrs(m)==nbrs(pnode(n)))&&m>pnode(n))
            pnode(n)=m;
        end
    end
end
%
% tiap yg baru jadi node terakhir di kluster
%
M=0;
cls=zeros(N,1);
for n=1:N
    if pnode(n)==n 
        M=M+1;
        cls(n)=M;
    end
end
%
% kluster berulang2
%
for n=1:N
    pn=n;
    while cls(pn)==0
        pn=pnode(pn);
    end
    cls(n)=cls(pn);
end