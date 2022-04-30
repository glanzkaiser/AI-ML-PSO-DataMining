clear all
close all 

%kernel
kernel_name=cell(1,4);
kernel_name{1,1}=['linear'];
kernel_name{1,2}=['quadratic'];
kernel_name{1,3}=['polynomial'];
kernel_name{1,4}=['rbf'];

%array cell pake SVM objek 
SVMObjects=cell(1,4);


CorectClassify=zeros(4,1);
stdClassify=zeros(4,1);

[ theclass,data3 ] = GenToyData( );
%jumlah sample
NumberSamples=length(theclass);
%jumlah sampel latih
NumberTraining=floor(NumberSamples*0.65);
%jumlah sampel yang mau dicek
NumberValidation =floor(NumberSamples*0.20);
%jumlah sampel yang mau di test
NumberTesting=floor(NumberSamples*0.15);  

[ Train,Validation,Test] = GetTrainValidateTest(NumberSamples,NumberTraining,NumberValidation,NumberTesting);
%
%[ Train,Validation,Test] = GetTrainValidateTestPercent(NumberSamples,0.65,0.20,0.15)

figure

for n=1:4
%latih dngan kernel yg beda
SVMObjects(1,n)= {svmtrain(data3(Train,:),theclass(Train),'kernel_function',kernel_name{1,n},'ShowPlot',true)};

hold on
CorectClassify(n)=mean(theclass(Validation) == svmclassify(SVMObjects{1,n},data3(Validation,:)));

CorectClassify(n)=std(theclass(Validation) == svmclassify(SVMObjects{1,n},data3(Validation,:)));
title('data latih dan batasan keputusan dari SVM dengan Different Kernel ')

end

figure 
hold on 
plot(data3(Train,1),data3(Train,2),'r.','MarkerSize',15)
plot(data3(Validation,1),data3(Validation,2),'b.','MarkerSize',15)
plot(data3(Test,1),data3(Test,2),'g.','MarkerSize',15)
axis equal
hold off
legend('Training Samples','Validation Samples','Test Samples')
%akurasi plot dengan metode
hold off
figure;
names={'linear','quadratic','polynomial','rbf'}
bar(CorectClassify)
hold on
bar(CorectClassify-CorectClassify,'r')
hold off
set(gca, 'XTickLabel', names)
title('jumlah klasifikasi dengan kennels pakai validasi ')

%temukan kernel dengan klasifikasi yang benar
[Value,Index]=max(CorectClassify);
%nama kernelnya
kernel_name{1,Index}
% Test akurasi
TestAccuracy=sum(theclass(Test) == svmclassify(SVMObjects{1,Index},data3(Test,:)))






