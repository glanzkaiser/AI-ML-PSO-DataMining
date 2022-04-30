
load Contoh.mat
reg=MultiPolyRegress(X,Y,2) % Berikan nilai fit

%% Normalization - Range
% Perbedaan error HANYA dalam erhitungan MAE, MAESTD, CVMAE
% dan CVMAESTD. Tidak mempengaruhi nilai fit
reg=MultiPolyRegress(X,Y,2,'range')

%% Figure
% Dapat dilihat scatter plot dari nilai fit.
reg=MultiPolyRegress(X,Y,2,'figure');

%% PV 
% Jika ingin membatasi kekuatan pengamatan polynomial
% polynomial. Jika tidak mau pada data ke 1 dan ke4
% Variabel x1 dan x4 punya syarat urutan (x1^2 or x4^2)
% Jadi harus dibuat seberapa besar kekuatan tiap data
reg=MultiPolyRegress(X,Y,2,[1 2 2 1 2]); 
PolynomialFormula=reg.PolynomialExpression

%% Cara menghasilkan output
reg=MultiPolyRegress(X,Y,2);

%% PowerMatrix
% Harus punya new data point jika mau mengevaluasi yg akan dikompute-kan
%Asumsikan pada barus ke 250 dari X sebagai new data point.
%Selanjutnya dibuat matrix NewScores

% Tinggal mengulang prosedur disetiap new data point
% Memungkinkan pemakaian proses fungsi secara otomatis

NewDataPoint=X(250,:);
NewScores=repmat(NewDataPoint,[length(reg.PowerMatrix) 1]).^reg.PowerMatrix;
EvalScores=ones(length(reg.PowerMatrix),1);
for ii=1:size(reg.PowerMatrix,2)
    EvalScores=EvalScores.*NewScores(:,ii);
end
yhatNew=reg.Coefficients'*EvalScores % Estimasi untuk data point baru

%% Scores
% Unless you have a stake in deeply understanding this code, don't try to
% make sense of the Scores matrix, chances are you won't ever need to use
% it.

%% Polynomial Expression
% Formula nya dari nilai fit
PolynomialFormula=reg.PolynomialExpression

%% Cofficients
% Menampilkan contoh input

%% yhat
% Ini menjelaskan estimasi vector dari fit terbaru
% Scatter plot yang dilihat saat memakai opsi figure scatter(yhat,y).

%% Residuals
% Ini yang dimaksudkan sebagai y-yhat. Dapat digunakan untuk residual plot 
% asumsi least squares biasanya benar.

%% Goodness of Fit Measures
% Ini menjelaskan tidak hanya untuk akurasi nilai fit
% Tapi juga menggabungkan kandidat yang berbeda
% Digunakan CVMAE sebagai ukuran error yang bisa menggabungkan fit yang sama dari data set. 
%
% Polynomial tingkat kedua adalah pilihan yang terbaik.

for ii=1:5
    reg=MultiPolyRegress(X,Y,ii);
    CVMAE(ii)=reg.CVMAE;
end
CVMAE
 


