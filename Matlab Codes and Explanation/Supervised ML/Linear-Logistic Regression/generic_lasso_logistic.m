function B = generic_lasso_logistic(X,y,str_distribution,num_fold_cross_validation)

%               Input -
%                   X -  vector of values (response)
%                   y -  vector of values (data matrix)
%                   str_distribution  -  class of distribution
%			    num_fold_cross_validation - number of fold cross validation to use	
%
%               Output -
%                   B - matrix of estimated regularized coefficients
%                   Plots of cross-validation
%
%
% Example -
% load fisheriris
% X = meas(51:end,:);
% y = strcmp('versicolor',species(51:end));
% custom_lasso_glm(X,y,'binomial',10)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%str_distribution must be 'binomial' for logistic regression

%% call GLM LASSO
disp('Performing LASSO on logistic regression ..')
[B FitInfo] = lassoglm(X,y,str_distribution,'CV',num_fold_cross_validation)

%% plot cross validation results
lassoPlot(B,FitInfo,'PlotType','CV'); saveas(gcf,'lassoplot_1.eps', 'psc2')
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log'); saveas(gcf,'lassoplot_2.eps', 'psc2') 

%% perform prediction

% koefisien Lambda value with minimum
% standar deviasi tambah 1
%indx = FitInfo.Index1SE;
indx = FitInfo.IndexMinDeviance
B0 = B(:,indx);
nonzero_predictors = sum(B0 ~= 0)

% intercept konstan
cnst = FitInfo.Intercept(indx);
B1 = [cnst;B0];

% model dengan prediksi
disp('Performing prediction ..')
preds = glmval(B1,X,'logit');
%keyboard

% save workspace
save(sprintf('lasso_logistic_output_%s.mat',date))