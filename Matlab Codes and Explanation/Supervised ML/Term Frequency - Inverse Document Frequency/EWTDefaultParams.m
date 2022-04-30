function params = EWTDefaultParams()

% Perform deteksi log spectrum termasuk spectrum
params.log=1;

params.SamplingRate = -1; %taruh -1 jika tidak tau sampling rate

% pilih preprosessing untuk scales
params.globtrend = 'none';
params.degree=5; %derajat interpolasi polynomial 

% pilih regularisasi (none,gaussian,average,closing)
params.reg = 'none';
params.lengthFilter = 10;
params.sigmaFilter = 1.5;

% pilih detection yang dicari (locmax,locmaxmin,ftc,scalespace)
params.detect = 'scalespace';
params.typeDetect='otsu'; %otsu,halfnormal,empiricallaw,mean,kmeans

params.N = 4; % max jumlah band dari locmaxmin
params.completion=0; % 


%% CURVELET PARAMETERS
% Tipe curvelet transform (1=scale dan radius independent, 2=angles per
% scales)
params.option=1;

% (none,gaussian,average,closing)
params.curvreg = 'none';
params.curvlengthFilter = 10;
params.curvsigmaFilter = 1.5;

% Pilih global trend utk angles (none,plaw,poly,morpho,tophat)
params.curvpreproc='none';
params.curvdegree=4;

% Pilih detection yang dicari utk sudut (locmax,locmaxmin)
params.curvmethod='scalespace';
params.curvN=2;

