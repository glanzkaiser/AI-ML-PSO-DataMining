function compareForecasts(publicdata, allStates, missingDataStates, missingYears)
% 
% Pilih subset ke model yang dibangun
idxST = ismember(publicdata.STATE,allStates);
% idxST = ismember(publicdata.STATE,publicdata.STATE);
idx_remove = ismember(publicdata.YR,missingYears) & ismember(publicdata.STATE, missingDataStates);
idxData = idxST & ~idx_remove;
publicdata_model = publicdata(idxData,:);
publicdata_removed = publicdata(idx_remove,:);

publicdata_model.STATE = removecats(publicdata_model.STATE);
publicdata_removed.STATE = removecats(publicdata_removed.STATE);

lme_missing = fitlme(publicdata_model,...
    'log_GDP ~ 1 + YRcentered + (1+YRcentered|STATE)',...
    'FitMethod','REML');
% [lme_pred,lmeCI] = predict(lme_missing,panel,'Prediction','observation');

lm_missing = fitlm(publicdata_model,...
    'log_GDP ~ 1 + YRcentered + STATE + STATE:YRcentered');
% [lm_pred,lmCI] = predict(lm_missing,panel,'Prediction','observation');

forecastData = table;
forecastYears = (1987:1998)';
forecastStates = categorical({'IL','CT','WY'});

for ii = 1:numel(forecastStates)
    tbl= table;
    tbl.YR = forecastYears;
    tbl.STATE(:,1) = forecastStates(ii);
    forecastData = [forecastData;tbl];
end
forecastData.YRcentered = forecastData.YR - mean(unique(publicdata.YR));

figure
subplot(1,2,1)
plotForecast(lm_missing,forecastData,'YR','STATE',publicdata_removed)
title('Fixed-Effects Model','FontSize',15)
xlabel('Year','FontSize',15)
ylabel('log(GDP)','FontSize',15)
% legend('off')

subplot(1,2,2)
plotForecast(lme_missing,forecastData,'YR','STATE',publicdata_removed)
title('Mixed-Effects Model','FontSize',15)
xlabel('Year','FontSize',15)
ylabel('log(GDP)','FontSize',15)
