function [ Train,Validation,Test] = GetTrainValidateTest(NumberSamples,NumberTraining,NumberValidation,NumberTesting)

%INnisialisasi variabel output
Train=zeros(NumberSamples,1);
Validation=zeros(NumberSamples,1);
Test=zeros(NumberSamples,1);

%proporsi data latih
TrainProportion= (1-NumberTraining/NumberSamples);

[Train, Othere] = crossvalind('HoldOut', NumberSamples,TrainProportion);

%Index data point lainnya
IndexOthere=find(Othere==1);
%jumlah data point dengan latih dan uji
SizeOthere=length(IndexOthere);
%proporsi data dalam validasi
ValidationProportion=NumberTesting/NumberValidation;
%partisi sampai validasi data dan uji
[ValidationDummy ,TestDummy]=crossvalind('HoldOut', SizeOthere,ValidationProportion);

%vektor logikal indeks untuk validasi 
Validation(IndexOthere(ValidationDummy))=1;

% vektor logikal indeks untuk data uji
Test(IndexOthere(TestDummy))=1;
Validation=logical(Validation);
Test=logical(Test);
end

