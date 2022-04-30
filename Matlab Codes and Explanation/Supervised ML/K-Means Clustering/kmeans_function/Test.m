
%% hapus memory dan command window
clear all
close all
%% Generate Points
Sigma = [0.5 0.05; 0.05 0.5];
f1    = mvnrnd([0.5 0]  ,Sigma,100);
f2    = mvnrnd([0.5 0.5],Sigma,100);
f3    = mvnrnd([0.5 1]  ,Sigma,100);
f4    = mvnrnd([0.5 1.5],Sigma,100);
F     = [f1;f2;f3;f4];
%% K-means options
feature_vector     = F;                                 % Input
number_of_clusters = 8;                                 % jumlah kluster
Kmeans_iteration   = 40;                                % iterasi K-means 
%% Test K-means
[cluster_centers, data]  = km_fun(feature_vector, number_of_clusters, Kmeans_iteration); % K-means clusterig
%% Plot   
CV    = '+r+b+c+m+k+yorobocomokoysrsbscsmsksy';       % Color Vector
hold on
 for i = 1 : number_of_clusters
PT = feature_vector(data(:, number_of_clusters+1) == i, :);                % Find points tiap kluster   
plot(PT(:, 1),PT(:, 2),CV(2*i-1 : 2*i), 'LineWidth', 2);                   % Plot points dengan color dan shape
plot(cluster_centers(:, 1), cluster_centers(:, 2), '*k', 'LineWidth', 7);  % Plot cluster centers
 end
hold off
grid on


