function [daftarCluster, nilaiEnergi, idxD] = kMedoids(data,jumlahCluster)
%1. Hitung jumlah data pada matriks data
jumlahData = size(data,2);

%2. Hitung matriks v
%Lakukan perkalian matriks data dengan dirinya sendiri
%dan jumlahkah nilai yang terdapat dalam masing-masing dimensi untuk setiap data
v = dot(data,data,1);

%3. Hitung matriks jarak, yg disimbolkan dengan D
%Lakukan penjumlahan nilai baris matriks v dengan nilai kolom dari transpos matriks v
%Kemudian kurangkan dengan 2 kali dari matriks data dikali dengan transpos matriks data
D = bsxfun(@plus,v,v')-2*(data'*data);

for i=1:jumlahData,
    D(i,i) = 0;
end

%4. Tentukan medoid awal mula, yang diisi dengan nilai acak dari angka 1 sampai jumlah data, sebanyak jumlah cluster
%Ambil semua nilai dari masing-masing baris data pada nilai acak tersebut
%Kemudian bandingkan nilai minimal dari masing-masing data untuk membentuk daftar cluster mula-mula
[~, daftarCluster] = min(D(randsample(jumlahData,jumlahCluster),:),[],1);

%5. lakukan perhitungan selama masih ada data yang berpindah cluster (poin 5a -5c)
daftarClusterTerakhir = 0;
while any(daftarCluster ~= daftarClusterTerakhir)
    %5a. Ambil daftar cluster lama sebagai daftar cluster terakhir
    daftarClusterTerakhir = daftarCluster;    
    
    %5b. Tentukan data acak selain medoid lama untuk menggantikan nilai medoid lama
    %Lakukan pencatatan indeks cluster yang lama
    %Lakukan perkalian indeks tersebut dengan matriks D
    %Kemudian cari indeks data yang nilai minimal pada masing-masing cluster
    [~, idxD] = min(D*sparse(1:jumlahData,daftarCluster,1,jumlahData,jumlahCluster,jumlahData),[],1);
    
    %5c. Ambil semua nilai dari masing-masing baris data pada indeks yang telah ditentukan sebelumnya
    %Kemudian hitung nilai minimal dari matriks indeks D untuk mendapatkan nilai minimal dan daftar cluster yang baru
    [nilaiMinimal, daftarCluster] = min(D(idxD,:),[],1);
end

%6. Jika diperlukan, hitung penjumlahan nilai minimal yang didapatkan pada matriks D akhir
nilaiEnergi = sum(nilaiMinimal);
