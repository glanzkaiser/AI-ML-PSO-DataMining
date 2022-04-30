%% Mixed-Effect Modeling using MATLAB

%% Load Data
clear, clc, close all
loadPublicData

%% Preproses Data
% Convert STATE, YR and REGION to categorical
publicdata.STATE = categorical(publicdata.STATE);

% Komputasikan log(GDP)
publicdata.log_GDP = log(publicdata.GDP);
publicdata.GDP = [];

%% cocokkan model linear dan visualisasikan

publicdata.YRcentered = publicdata.YR - mean(unique(publicdata.YR));
lm = fitlm(publicdata,'log_GDP ~ 1 + YRcentered');

%% Visualisasi data dan cocokkan model
figure, 
gscatter(publicdata.YR,publicdata.log_GDP,publicdata.STATE,[],'.',20);
hold on
plot(publicdata.YR,predict(lm),'k-','LineWidth',2)
title('Simple linear model fit','FontSize',15)
xlabel('Year','FontSize',15), ylabel('log(GDP)','FontSize',15)

figure,
xlabel('OLS Residuals')
boxplot(lm.Residuals.Raw,publicdata.STATE,'orientation','horizontal')
%% Cocokkan model linear tiap group 
figure, 
plotIntervals(publicdata,'log_GDP ~ 1 + YRcentered','STATE')
lm_group = fitlm(publicdata,'log_GDP ~ 1 + YRcentered + STATE + YRcentered:STATE');

% Tampilkan jumlah prediktor dan jumlah koefisien terestimasi 
disp(['Number of Variables:', num2str(lm_group.NumPredictors)])
disp(['Number of Estimated Coefficients:', ...
    num2str(lm_group.NumEstimatedCoefficients)])

clc
lme_intercept = fitlme(publicdata,'log_GDP ~ 1 + YRcentered + (1|STATE)');


clc
lme_intercept_slope = fitlme(publicdata,...
    'log_GDP ~ 1 + YRcentered + (1+YRcentered|STATE)');

[~,~,rEffects] = randomEffects(lme_intercept_slope);

figure, 
scatter(rEffects.Estimate(1:2:end),rEffects.Estimate(2:2:end))
title('Random Effects','FontSize',15)
xlabel('Intercept','FontSize',15)
ylabel('Slope','FontSize',15)

compare(lme_intercept, lme_intercept_slope, 'CheckNesting',true)

% Response (Dependent Variable)
y = publicdata.log_GDP; 

% Fixed Effects Design Matrix
X = [ones(height(publicdata),1), publicdata.YRcentered];
% Random Effects Design Matrix
Z = [ones(height(publicdata),1), publicdata.YRcentered]; 

% Grouplan variabel 
G = publicdata.STATE; 

% Cocokkan model
lme_matrix = fitlmematrix(X,y,Z,G,'CovariancePattern','Diagonal');

states = {'IL','NJ','MA','CT','UT','NV','VT','WY'};
unbalancedStates = {'IL','CT','WY'};
missingYears = 1970:1983;
compareForecasts(publicdata, states, unbalancedStates, missingYears)

