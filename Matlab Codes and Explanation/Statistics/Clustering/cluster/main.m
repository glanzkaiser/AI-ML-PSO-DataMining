disp('Algoritma K-Medoids Clustering');
disp('Contoh: Penentuan jurusan siswa berdasarkan nilai skor siswa');
disp('Diasumsikan ada 20 orang siswa, yaitu siswa A sampai dengan T');
disp('Masing-masing siswa memiliki rata-rata nilai IPA, IPS, dan Bahasa yang berbeda-beda');
disp('Maka tentukan semua siswa tersebut akan masuk ke dalam jurusan apa berdasarkan nilai skor yang dimiliki');
disp('Diasumsikan data awal nilai siswa adalah sebagai berikut');
disp('Nama Siswa, Nilai IPA, Nilai IPS, Nilai Bahasa');
disp('Siswa A   ,        50,        60,           70');
disp('Siswa B   ,        65,        80,           73');
disp('Siswa C   ,        72,        70,           65');
disp('Siswa D   ,        83,        65,           80');
disp('Siswa E   ,        40,        82,           73');
disp('Siswa F   ,        95,        71,           85');
disp('Siswa G   ,        60,        74,           96');
disp('Siswa H   ,        75,        75,           92');
disp('Siswa I   ,        83,        55,           70');
disp('Siswa J   ,        91,        60,           65');
disp('Siswa K   ,        92,        91,           55');
disp('Siswa L   ,        76,        80,           59');
disp('Siswa M   ,        75,        65,           74');
disp('Siswa N   ,        74,        76,           89');
disp('Siswa O   ,        63,        79,           69');
disp('Siswa P   ,        58,        93,           76');
disp('Siswa Q   ,        82,        50,           80');
disp('Siswa R   ,        81,        65,           88');
disp('Siswa S   ,        76,        74,           70');
disp('Siswa T   ,        77,        71,           55');
disp(char(10));

data=[50, 60, 70; ...
    65, 80, 73; ...
    72, 70, 65; ...
    83, 65, 80; ...
    40, 82, 73; ...
    95, 71, 85; ...
    60, 74, 96; ...
    75, 75, 92; ...
    83, 55, 70; ...
    91, 60, 65; ...
    92, 91, 55; ...
    76, 80, 59; ...
    75, 65, 74; ...
    74, 76, 89; ...
    63, 79, 69; ...
    58, 93, 76; ...
    82, 50, 80; ...
    81, 65, 88; ...
    76, 74, 70; ...
    77, 71, 55]';

atribut = {'IPA';'IPS';'Bahasa'};

%Tentukan Jumlah Cluster
%Jumlah Cluster adalah jumlah dari pengelompokan data yang ingin dilakukan
%Jumlah Cluster nilainya harus diantara 2 dan jumlah data
%Diasumsikan dalam kasus ini, jumlah pengelompokan data ada 3 kelompok, yaitu jurusan IPA, jurusan IPS, jurusan Bahasa
jumlahCluster = 3;

disp(['Jumlah Cluster = ', num2str(jumlahCluster)]);
disp(char(10));

%* Lakukan proses pengelompokan dengan metode Clustering
%Penjelasan tentang fungsi ini akan dijelaskan pada perhitungan dibawah ini (poin 1 - 6)
daftarCluster = kMedoids(data,jumlahCluster);

disp('Data yang sudah dikelompokkan:');
disp('------------------------------');
%* Tampilkan semua data yang sudah dimasukan ke dalam cluster
%Hitung nilai skornya untuk masing-masing kriteria dalam cluster tersebut
%Ambil nilai skor tertinggi sebagai jawaban jurusan yang seharusnya diambil
data = data';
st = zeros(1,size(data,2),'uint8');

for k = 1:jumlahCluster
    skor = zeros(1,size(data,2),'double');
    for i = 1:size(data,1)
        s = '';
        if daftarCluster(i) == k,
            s = strcat([s, 'Siswa ', char(i + 64), '   ']);
            for j = 1:size(data,2)
                s = strcat([s, ' ', num2str(data(i,j)), ' ']);

                if st(j) == 0, skor(j) = skor(j) + data(i,j); end;
            end
            disp(s);
        end;
    end;

    maks = -inf;
    idxmaks = -1;
    for i = 1:size(data,2)
        if maks < skor(i),
            maks = skor(i);
            idxmaks = i;
        end
    end

    disp(['Kelompok ini memiliki skor terbanyak pada kolom ke ' , num2str(idxmaks) , ...
        ' , -> kelompok data ' , char(atribut(idxmaks))]);
    disp('------------------------------');

    st(idxmaks) = 1;
end;
disp(char(10));