function call_generic_lasso_logistic()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
load fisheriris
X = meas(51:end,:);
Y = strcmp('versicolor',species(51:end));
generic_lasso_logistic(X,Y,'binomial',10)
%baik mse dan nilai R-square untuk model telah ditingkatkan. lasso memprediksi lebih baik daripada linear dan ridge.