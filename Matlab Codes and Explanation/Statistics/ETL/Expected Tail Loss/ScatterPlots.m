
N = 1000;
corr = 0;

mu = [0 0];
Sigma = [1 corr; corr 1]; R = chol(Sigma);

z = repmat(mu,N,1) + randn(N,2)*R;

figure('Color',[1 1 1]);scatter(z(:,1),z(:,2)); ylim([-5,5]); xlim([-5,5]);
title('Independence');
xlabel('x'); ylabel('y');

corr = 0.99;
Sigma = [1 corr; corr 1]; R = chol(Sigma);

z = repmat(mu,N,1) + randn(N,2)*R;

figure('Color',[1 1 1]);scatter(z(:,1),z(:,2)); ylim([-5,5]); xlim([-5,5]);
title('Positive Dependence');
xlabel('x'); ylabel('y');


corr = -0.99;
Sigma = [1 corr; corr 1]; R = chol(Sigma);

z = repmat(mu,N,1) + randn(N,2)*R;

figure('Color',[1 1 1]);scatter(z(:,1),z(:,2)); ylim([-5,5]); xlim([-5,5]);
title('Negative Dependence');
xlabel('x'); ylabel('y');