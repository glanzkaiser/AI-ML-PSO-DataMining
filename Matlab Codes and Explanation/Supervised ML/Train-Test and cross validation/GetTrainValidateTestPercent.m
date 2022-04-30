function [ Train,Validation,Test] = GetTrainValidateTestPercent(NumberSamples,PercentTraining,PercentValidation,PercentTesting)


NumberTraining=floor(NumberSamples*PercentTraining);
NumberValidation=floor(NumberSamples*PercentValidation);
NumberTesting=floor(NumberSamples*PercentTesting);
% Insialisasi variabel output 

Train=zeros(NumberSamples,1);
Validation=zeros(NumberSamples,1);
Test=zeros(NumberSamples,1);

%proporsi data latih
TrainProportion= (1-NumberTraining/NumberSamples);

[Train, Othere] = crossvalind('HoldOut', NumberSamples,TrainProportion);

%indeks data point lainnya
IndexOthere=find(Othere==1);
%jumlah data point digunakan utk latih dan uji
SizeOthere=length(IndexOthere);
%proporsi data utk validasi
ValidationProportion=NumberTesting/NumberValidation;
%partisi dalam data utk validasi dan uji
[ValidationDummy ,TestDummy]=crossvalind('HoldOut', SizeOthere,ValidationProportion);

%vektor indeks untuk validasi data
Validation(IndexOthere(ValidationDummy))=1;

%vektor indeks untuk data uji
Test(IndexOthere(TestDummy))=1;
Validation=logical(Validation);
Test=logical(Test);
end

