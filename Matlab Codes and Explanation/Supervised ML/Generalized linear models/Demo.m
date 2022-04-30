% ========== GENERALIZED LINEAR MODEL  ==============
%               SPECIFY WHICH DEMO's TO RUN (1 to 5)
                        DEMO = [1,2,5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tambahkan package GLM ke workspace.
addpath(genpath('GLM'));

% Buat variabel data sample:
clear X Y Xnew Ybin W O;
Y.meter = [38,26,22,32,36,27,27,44,32,28,31]';
X.daya = [85,92,112,96,84,90,86,52,84,79,82]';
X.akselerasi = [17,14.5,14.7,13.9,13,17.3,15.6,24.6,11.6,18.6,19.4]';
X.silinder = [6,4,6,4,4,4,4,4,4,4,4]';

% Buat bobot.
W.Importance = [1,2,2,2,3,2,2,2,1,1,1]';

% Buat offset
O.MeasurementError = 5.*ones(11,1);

% Buat data baru ke fit setelah estimasi.
Xnew.daya = [70,67,67,67,110]';
Xnew.akselerasi = [16.9,15,15.7,16.2,16.4]';
Xnew.silinder = [4,4,4,4,6]';

% Buat variabel untuk model binomial.
% Column 1 adalah response, column 2 adalah contoh size response.
Ybin.SecondHand(:,1) = [0,1,1,1,0,0,1,0,0,1,1]';
Ybin.SecondHand(:,2) = [1,1,1,1,1,1,1,1,1,1,1]'; % (sample sizes =1)

% ------------------------------------------------------------------------
% Demo 1: Tentukan GLM dengan distribusi GLM dan link identitas.
if ismember(1,DEMO)
fprintf('\n\n');
fprintf(' ================================================\n');
fprintf('  DEMO 1: distribusi normal dengan link identitas\n');
fprintf(' ================================================');

mdl = GLM;
mdl.Distribution = 'normal';
mdl.Link = 'id';
mdl.Estimate(Y,X);

% Cocokkan data baru
fit = mdl.Fit(Xnew);
fprintf('Cocokkan nilai out-of-sample :\n');
disp(fit);
end
% ------------------------------------------------------------------------
% Demo 2: Cocokkan GLM dengan distribusi gamma.
if ismember(2,DEMO)
fprintf('\n\n');
fprintf(' ================================================\n');
fprintf('  DEMO 2: GLM dengan distribusi gamma.\n');
fprintf(' ================================================');

mdl = GLM;
mdl.Distribution = 'gamma';
mdl.Link = 'log';
mdl.Estimate(Y,X);
end
% ------------------------------------------------------------------------
% Demo 3: Cocokkan GLM dengan distribusi gamma.
% Dimana pengamatan yang diamati adalah bobot setiap variabel lainnya.
if ismember(3,DEMO)
fprintf('\n\n');
fprintf(' ======================================================\n');
fprintf('  DEMO 3: Cocokkan GLM dengan distribusi gamma.\n');
fprintf(' ======================================================');

mdl = GLM;
mdl.Distribution = 'gamma';
mdl.Link = 'log';
mdl.Estimate(Y,X,W);        % Note: sekarang termasuk bobot 'W'.
end
% ------------------------------------------------------------------------
% Demo 4: Cocokkan GLM dengan distribusi gamma dan profit link.
if ismember(4,DEMO)
fprintf('\n\n');
fprintf(' ================================================\n');
fprintf('  DEMO 4: Cocokkan GLM dengan distribusi gamma dan profit link.\n');
fprintf(' ================================================');

mdl = GLM;
mdl.Distribution = 'binomial';
mdl.Link = 'probit';
mdl.Estimate(Ybin,X);
end
% ------------------------------------------------------------------------
% Demo 5: GLM dengan distribusi binomial, probit link, bobot dan offset.
if ismember(5,DEMO)
fprintf('\n\n');
fprintf(' ============================================================\n');
fprintf('  DEMO 5: binomial dist. dengan probit link, bobot dan offset\n');
fprintf(' ============================================================');

mdl = GLM;
mdl.Distribution = 'binomial';
mdl.Link = 'probit';
mdl.Estimate(Ybin,X,W,O);   % Note: sekarang termasuk bobot 'W' dan offset 'O'
end
