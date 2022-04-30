
%% Load Data 
clear, clc, close all
loadPanelData

%% Preproses Data
publicdata.STATE = categorical(publicdata.STATE);
publicdata.REGION = categorical(publicdata.REGION);
publicdata.YR = categorical(publicdata.YR);



logvars = {'PUB_CAP','HWY','WATER','UTIL','PVT_CAP','EMP','GDP'};
publicdata = [publicdata varfun(@log,publicdata(:,logvars))];
publicdata(:,logvars) = [];
clear logvars

unstacked = unstack(publicdata,'log_GDP','STATE',...
    'GroupingVariable','YR');


publicdata_missing_years = publicdata;
publicdata_missing_years(randperm(100,20),:) = [];


unstacked_missing = unstack(publicdata_missing_years,...
    'log_GDP','STATE','GroupingVariable','YR');
unstacked_missing = sortrows(unstacked_missing,'YR','ascend');



lm_ols = fitlm(publicdata,...
    'log_GDP ~ 1 + UNEMP + log_PUB_CAP + log_PVT_CAP + log_EMP')


boxplot(lm_ols.Residuals.Raw,publicdata.STATE)
ylabel('OLS Residuals')


lm_fe = fitlm(publicdata,...
    'log_GDP ~ 1 + UNEMP + log_PUB_CAP + log_PVT_CAP + log_EMP + STATE')

disp(' '),
disp(['log_PUB_CAP OLS Estimate:  ', num2str(lm_ols.Coefficients{'log_PUB_CAP',1})])
disp(['log_PUB_CAP FE  Estimate: ', num2str(lm_fe.Coefficients{'log_PUB_CAP',1})])



lme_oneway = fitlme(publicdata,...
   'log_GDP ~ 1 + log_PUB_CAP + log_PVT_CAP + log_EMP + UNEMP + (1 | STATE)',...
   'FitMethod','REML')

disp(' ')
disp(['log_PUB_CAP OLS Estimate:  ', num2str(lm_ols.Coefficients{'log_PUB_CAP',1})])
disp(['log_PUB_CAP  FE Estimate: ', num2str(lm_fe.Coefficients{'log_PUB_CAP',1})])
disp(['log_PUB_CAP  RE Estimate:  ', num2str(lme_oneway.Coefficients{3,2})])


clc
lme_oneway_new = fitlme(publicdata,...
    ['log_GDP ~ 1 + log_HWY + log_WATER + log_UTIL + log_PVT_CAP +'...
    'log_EMP + UNEMP + (1 | STATE)'],'FitMethod','REML')


%% bandingkan model effect acak untuk peningkatan
clc
compare(lme_oneway, lme_oneway_new)



clc
lme_twoway = fitlme(publicdata,...
    ['log_GDP ~ 1 + log_HWY + log_WATER + log_UTIL + log_PVT_CAP +'...
    'log_EMP + UNEMP + (1 | STATE) + (1|YR)'],'FitMethod','REML')

compare(lme_oneway, lme_twoway)

clc
lme_hierarchical = fitlme(publicdata,...
    ['log_GDP ~ 1 + log_HWY + log_WATER + log_UTIL + log_PVT_CAP +'...
    'log_EMP + UNEMP + (1|REGION) + (1|STATE:REGION) + (1|YR)'],'FitMethod','REML')


lme_advanced = fitlme(publicdata,...
    ['log_GDP ~ 1 + log_HWY + log_WATER + log_UTIL + log_PVT_CAP + log_EMP + UNEMP +'...
    '(1 + log_HWY + UNEMP|REGION) + (1 + log_HWY + UNEMP|STATE:REGION) + (1|YR)'],...
    'FitMethod','REML','CovariancePattern',{'Full','Diagonal','Diagonal'})
compare(lme_hierarchical, lme_advanced,'CheckNesting',true)

