function r=rmse(data,estimate)
% htung root-mean-square error

% delete records dengan NaNs diantara dataset
I = ~isnan(data) & ~isnan(estimate); 
data = data(I); estimate = estimate(I);

r=sqrt(sum((data(:)-estimate(:)).^2)/numel(data));