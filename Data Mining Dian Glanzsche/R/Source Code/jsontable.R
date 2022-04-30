require(RJSONIO)
library(jsonlite)

all.equal(mtcars, fromJSON(toJSON(mtcars)))

json_file <-  '[{
	"Link": "http://nasional.kompas.com/read/2017/01/24/23012981/ini.alasan.fahri.hamzah.hapus.kicauan.soal.tki",
"Title": "Fahri Hamzah Hapus Kicauan soal TKI di Twitter, Ini Alasannya"
}, {
"Link": "https://news.detik.com/berita/3404266/polri-dan-polisi-sudan-investigasi-tuduhan-penyelundupan-senjata",
"Title": "Polri dan Polisi Sudan Investigasi Tuduhan Penyelundupan Senjata"
}, {
"Link": "http://www.cnnindonesia.com/kursipanasdki1/20170124194130-516-188673/debat-pilkada-dianggap-tak-pengaruhi-elektabilitas-cagub-dki/",
"Title": "Debat Pilkada Dianggap Tak Pengaruhi Elektabilitas Cagub DKI"
}, {
"Link": "https://news.detik.com/berita/3404315/megawati-dipolisikan-pdip-apa-motifnya-kalau-suruhan-kan-aneh",
"Title": "Megawati Dipolisikan, PDIP: Apa Motifnya, Kalau Suruhan Kan Aneh"
}, {
"Link": "https://finance.detik.com/moneter/d-3404225/ojk-baru-30-dari-100-orang-ri-yang-paham-produk-dan-jasa-keuangan",
"Title": "OJK: Baru 30 dari 100 Orang RI yang Paham Produk dan Jasa"
}, {
"Link": "http://nasional.kompas.com/read/2017/01/24/14132301/bertemu.tiga.jam.ini.yang.dibahas.jokowi.dan.pimpinan.mpr",
"Title": "Bertemu Tiga Jam, Ini yang Dibahas Jokowi dan Pimpinan MPR"
}, {
	"Link": "https://news.detik.com/berita/3404549/soal-lawatan-pejabatnya-ke-israel-mui-bentuk-tim-tabayun",
"Title": "Soal Lawatan Pejabatnya ke Israel, MUI Bentuk Tim Tabayun"
}, {
"Link": "http://www.voaindonesia.com/a/china-tak-mundur-dari-klaim-laut-china-selatan-/3689785.html",
"Title": "Beijing Tegaskan Tak Mundur dari Klaim atas Laut China Selatan"
}, {
"Link": "http://www.voaindonesia.com/a/kementerian-pertahanan-jepang-luncurkan-satelit-pertama/3689427.html",
"Title": "Kementerian Pertahanan Jepang Luncurkan Satelit Pertama"
}, {
"Link": "http://www.voaindonesia.com/a/senat-trump-cia-calon-menlu/3689233.html",
"Title": "Senat Kukuhkan Pilihan Trump untuk CIA, Dahului Calon Menlu"
}, {
"Link": "https://news.detik.com/berita/3404516/teten-masduki-somasi-ustaz-alfian-tanjung-yang-ceramah-soal-pki",
"Title": "Teten Masduki Somasi Ustaz Alfian Tanjung yang Ceramah Soal PKI"
}, {
"Link": "http://nasional.kompas.com/read/2017/01/24/21243221/wapres.akui.pengamalan.sila.kelima.pancasila.belum.optimal",
"Title": "Wapres Akui Pengamalan Sila Kelima Pancasila Belum Optimal"
}, {
"Link": "https://news.detik.com/berita/d-3404599/anies-sebut-2-moderator-jadikan-debat-menarik",
"Title": "Anies Sebut 2 Moderator Jadikan Debat Menarik"
}, {
"Link": "http://news.liputan6.com/read/2835860/uang-hasil-jual-beli-jabatan-diduga-mengalir-ke-anggota-dpr",
"Title": "Uang Hasil Jual Beli Jabatan Diduga Mengalir ke Anggota DPR"
}, {
	"Link": "http://ekonomi.metrotvnews.com/energi/zNPADJAb-jokowi-minta-harga-gas-dikalkulasi-kembali",
"Title": "Jokowi Minta Harga Gas Dikalkulasi Kembali"
}, {
"Link": "http://tekno.kompas.com/read/2017/01/24/18462397/10.video.iklan.terbaik.youtube.indonesia.juli-desember.2016",
"Title": "10 Video Iklan Terbaik YouTube Indonesia Juli-Desember 2016"
}, {
"Link": "http://www.cnnindonesia.com/ekonomi/20170124185522-92-188653/menko-darmin-belum-temukan-payung-hukum-pajak-tanah-nganggur/",
"Title": "Menko Darmin Belum Temukan Payung Hukum Pajak Tanah Nganggur"
}, {
"Link": "http://www.cnnindonesia.com/ekonomi/20170124190249-85-188655/duit-pertamina-menguap-us-70-juta-akibat-gangguan-kilang/",
"Title": "Duit Pertamina Menguap US$70 juta Akibat Gangguan Kilang"
}, {
"Link": "http://www.cnnindonesia.com/teknologi/20170124160731-185-188597/waspada-serangan-malware-project-sauron/",
"Title": "Waspada Serangan Malware Project Sauron"
}, {
"Link": "http://tekno.kompas.com/read/2017/01/24/16140047/8.langkah.samsung.cegah.tragedi.note.7.terulang",
"Title": "8 Langkah Samsung Cegah Tragedi Note 7 Terulang"
}, {
"Link": "http://teknologi.metrotvnews.com/news-teknologi/ybJyAD4N-segera-masuk-indonesia-begini-kesan-pertama-menjajal-vivo-v5-plus",
"Title": "Segera Masuk Indonesia, Begini Kesan Pertama Menjajal Vivo V5 Plus"
}, {
"Link": "http://teknologi.news.viva.co.id/news/read/874743-tri-yakin-jadi-operator-pemenang-lelang-frekuensi-kosong",
"Title": "Tri Yakin Jadi Operator Pemenang Lelang Frekuensi Kosong"
}, {
"Link": "http://www.bbc.com/indonesia/majalah-38733822",
"Title": "Film musikal La La Land mendapat nominasi 14 Oscar"
}, {
"Link": "http://www.bintang.com/celeb/read/2836038/sindir-ulama-di-twitter-uus-diberhentikan-dari-dua-program",
"Title": "Sindir Ulama di Twitter, Uus Diberhentikan dari Dua Program?"
}, {
"Link": "http://pojoksatu.id/seleb/2017/01/24/uus-mundur-ovj-andhika-pratama-penggantinya/",
"Title": "Uus Mundur dari OVJ, Andhika Pratama Penggantinya?"
}, {
"Link": "http://www.bintang.com/celeb/read/2835891/running-man-tetap-berlanjut-di-tahun-2017",
"Title": "Running Man Tetap Berlanjut di Tahun 2017"
}, {
"Link": "http://bola.kompas.com/read/2017/01/24/21465398/tanggapan.klub.soal.persaingan.piala.presiden.2017",
"Title": "Tanggapan Klub soal Persaingan Piala Presiden 2017"
}, {
"Link": "https://oto.detik.com/read/2017/01/24/133645/3404040/1207/sedan-mewah-mercy-e-class-kini-dibuat-di-indonesia?mpoto",
"Title": "Sedan Mewah Mercy E-Class Kini Dibuat di Indonesia"
}, {
"Link": "http://bola.liputan6.com/read/2836246/jokowi-bentuk-tim-gabungan-pengembangan-sepak-bola-nasional",
"Title": "Jokowi Bentuk Tim Gabungan Pengembangan Sepak Bola Nasional"
}, {
"Link": "http://nasional.kompas.com/read/2017/01/24/19461991/ketua.pssi.menunjukkan.foto.yang.menyinggung.harga.diri.jokowi",
"Title": "Ketua PSSI Menunjukkan Foto yang Menyinggung Harga Diri Jokowi"
}, {
"Link": "http://sorotindonesia.com/2017/01/24/edukasi-gunakan-internet-dengan-lebih-cerdas/",
"Title": "Edukasi Gunakan Internet Dengan Lebih Cerdas"
}, {
"Link": "http://makassar.tribunnews.com/2017/01/24/budi-cilok-bakal-hibur-tamu-knpi-sulsel-versi-eka-imran",
"Title": "Budi Cilok Bakal Hibur Tamu KNPI Sulsel Versi Eka Imran"
}, {
"Link": "http://edukasi.kompas.com/read/2017/01/24/20382461/binus.kantongi.akreditasi.a",
"Title": "Binus Kantongi Akreditasi A"
}, {
"Link": "http://www.beritajakarta.com/read/40930/dinas-lingkungan-hidup-terima-rekomendasi-kualitas-udara",
"Title": "Dinas Lingkungan Hidup Terima Rekomendasi Kualitas Udara"
}, {
"Link": "http://health.kompas.com/read/2017/01/24/191407223/berkat.implan.koklea.anak.ini.lancar.bicara",
"Title": "Berkat Implan Koklea, Anak Ini Lancar Bicara"
}, {
"Link": "https://news.detik.com/berita/d-3404422/djarot-batal-blusukan-di-jaktim-gara-gara-sakit-gigi",
"Title": "Djarot Batal Blusukan di Jaktim Gara-gara Sakit Gigi"
}, {
"Link": "http://lifestyle.bisnis.com/read/20170124/104/622388/memilih-busana-imlek-simpel-nan-modern",
"Title": "Memilih Busana Imlek Simpel Nan Modern"
}, {
"Link": "http://showbiz.liputan6.com/read/2835735/gelar-pesta-brad-pitt-bawa-pulang-balon-untuk-anak-anaknya",
"Title": "Gelar Pesta, Brad Pitt Bawa Pulang Balon untuk Anak-anaknya"
}]'

mydf <- fromJSON(json_file)

json_file <- fromJSON(json_file)

json_file <- lapply(json_file, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
})

do.call("rbind", json_file)

