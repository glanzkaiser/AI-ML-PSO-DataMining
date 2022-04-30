function call_generic_random_forests()


%Deskripsi - fungsi untuk load data dan memanggil fungsi random forests 


load fisheriris %pertimbangkan model yang diinginkan dipakai 
X = meas;%query dalam data
Y = species;
BaggedEnsemble = generic_random_forests(X,Y,60,'classification')%Ensemble dengan contoh 60 bagged decision trees:
predict(BaggedEnsemble,[5 3 5 1.8])
