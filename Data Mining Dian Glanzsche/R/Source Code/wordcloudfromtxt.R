library("tm") 
library("SnowballC")
library("wordcloud")
library("RColorBrewer") 
library("RCurl")
library("XML")
source('http://www.sthda.com/upload/rquery_wordcloud.r')
filePath <- "http://www.sthda.com/sthda/RDoc/example-files/martin-luther-king-i-have-a-dream-speech.txt"
res<-rquery.wordcloud(filePath, type ="file", lang = "english",
                      colorPalette = "PRGn",
                      min.freq = 1,  max.words = 200)

res<-wordcloud("Pertumbuhan ekonomi Indonesia pada 2016 mencapai 5,02 persen atau lebih tinggi dibandingkan dengan pertumbuhan 2015 yang sebesar 4,88 persen. Meski meningkat, pertumbuhan 2016 dinilai masih belum berkualitas karena lebih banyak ditopang oleh sektor konsumsi rumah tangga.

               Selain itu, pertumbuhan juga dinilai belum mampu mengatasi tiga masalah utama, yakni mengurangi kemiskinan, menciptakan lebih banyak lapangan kerja, dan mempersempit kesenjangan ekonomi. Pengamat ekonomi dari Universitas Brawijaya Malang, Adi Susilo, mengungkapkan pemerintah tidak semestinya terlalu membanggakan kenaikan pertumbuhan ekonomi 2016 karena merupakan capaian semu.
               
               “Ini pertumbuhan semu saja, padahal secara kualitas belum menggembirakan. Dikatakan perputaran uang cepat, tapi belanja konsumtif yang banyak sementara pendapatan ekspor turun,” ungkap dia ketika dihubungi, Senin (6/2).
               
               Adi menambahkan, ke depan, pemerintah harus mencari strategi untuk meningkatkan ekspor. Apabila belum mampu mengembangkan sektor teknologi tinggi, semestinya fokus menggenjot sektor padat karya untuk menyerap lapangan kerja, di samping juga harus kompetitif.
               
               “Karena strategi yang seperti itu bisa menghasilkan pertumbuhan yang riil, bukan hanya dari belanja konsumtif,” tukas dia. Sebelumnya, Badan Pusat Statistik (BPS) mengumumkan pertumbuhan ekonomi 2016 mencapai 5,02 persen, terutama ditopang oleh konsumsi rumah tangga dan investasi yang tumbuh masing-masing 5,01 persen dan 4,48 persen. Kepala BPS, Suhariyanto, mengatakan secara keseluruhan sektor konsumsi rumah tangga masih memberikan kontribusi terbesar dalam produk domestik bruto (PDB), yaitu mencapai 56,5 persen, diikuti oleh pembentukan modal tetap bruto 32,57 persen, dan ekspor 19,08 persen.
               
               BPS juga mencatat pertumbuhan ekonomi Indonesia pada triwulan IV-2016 sebesar 4,94 persen, sehingga secara keseluruhan sepanjang tahun mencapai 5,02 persen. Perekonomian Indonesia pada 2016 diukur berdasarkan PDB atas dasar harga berlaku mencapai 12.406,8 triliun rupiah dengan PDB per kapita mencapai 47,96 juta rupiah atau 3.605,1 dollar AS. Secara spasial, struktur ekonomi pada 2016 masih didominasi oleh provinsi di Jawa yang memberikan kontribusi terhadap PDB sebesar 58,49 persen, diikuti Sumatera 22,03 persen dan Kalimantan 7,85 persen.
               
               Rentan Inflasi
               
               Adi memaparkan pertumbuhan ekonomi rendah dalam menyerap tenaga kerja karena banyak ditopang sektor jasa yang minim penyerapan tenaga kerja, bukan dari sektor manufaktur dan sektor pertanian yang kaya akan padat karya.
               
               Akibatnya, dampak pada penurunan angka kemiskinan juga tidak signifikan. Selain itu, lanjut dia, struktur perekonomian nasional pun masih bertumpu pada kekuatan sektor konsumsi rumah tangga sehingga sangat rentan terhadap gejolak inflasi. Saat ini, inflasi umum (headline inflation) cukup rendah.
               
               Namun, tahun ini pemerintah perlu memperbaiki pergerakan inflasi harga barang-barang bergejolak (volatile food), yang jauh di atas inflasi umum. Kelompok utama penyumbang inflasi tersebut adalah kelompok bahan makanan.
               
               “Seharusnya, pemerintah sudah memiliki kebijakan yang fokus untuk mengelola inflasi dari sisi penawaran, karena inflasi ini kan sudah berlangsung lama,” ujar Adi. Dia juga mengemukakan elastisitas pertumbuhan ekonomi terhadap penciptaan lapangan kerja cenderung menurun. Saat ini, 1 persen pertumbuhan ekonomi menyerap sekitar 107 ribu tenaga kerja.
               
               Padahal pada 2014, 1 persen pertumbuhan dapat menyerap 260 ribu tenaga kerja. Bahkan, pada 2004 setiap 1 persen pertumbuhan menyerap 400.000 tenaga kerja. Pengamat ekonomi dari Universitas Indonesia, Wiraguna Bagoes Oka, mengatakan memang sejarah Indonesia sejak 2014–2015 digenjot semua kredit harus tumbuh. Jadi faktor konsumsi memang sangat besar kontribusinya dalam menopang pertumbuhan ekonomi. “Waktu itu malah 70 persen konsumsinya, baru belakangan ini turun 60 persen,” kata Wiraguna.", 
               type ="file", scale=c(5,0.5), rot.per=0.35, 
               colors=brewer.pal(8, "Dark2"),
               min.freq = 2,  max.words = 100)

# Show the top10 words and their frequency
tdm <- res$tdm
freqTable <- res$freqTable
head(freqTable, 10)

# Bar plot of the frequency for the top10
barplot(freqTable[1:10,]$freq, las = 2, 
        names.arg = freqTable[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")

# Create a word cloud of a web page
url = "https://www.google.com/search?hl=id&gl=id&tbm=nws&authuser=0&q=tax+amnesty&oq=tax+amne&gs_l=news-cc.3.1.43j0l10j43i53.398571.400327.0.402287.8.6.0.2.2.0.116.561.4j2.6.0...0.0...1ac.1.-rbQNN4iz2A"
resnews <- rquery.wordcloud(x=url, type="url")


# Show the top10 words and their frequency
tdm <- resnews$tdm
freqTable <- resnews$freqTable
head(freqTable, 1000)

# Bar plot of the frequency for the top10
barplot(freqTable[1:10,]$freq, las = 2, 
        names.arg = freqTable[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")
