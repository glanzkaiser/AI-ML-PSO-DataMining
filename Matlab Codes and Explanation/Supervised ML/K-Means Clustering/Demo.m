
%% hapus memory dan command window
clc
clear all
close all
%% generate point
Sigma = [0.5 0.05; 0.05 0.5];
f1    = mvnrnd([0.5 0]  ,Sigma,100);
f2    = mvnrnd([0.5 0.5],Sigma,100);
f3    = mvnrnd([0.5 1]  ,Sigma,100);
f4    = mvnrnd([0.5 1.5],Sigma,100);
F     = [f1;f2;f3;f4];
%% K-means
K     = 8;                                            % Cluster Numbers
KMI   = 40;                                           %Iterasi K-means
CENTS = F( ceil(rand(K,1)*size(F,1)) ,:);             % Cluster Centers
DAL   = zeros(size(F,1),K+2);                         % Jarak dan Label
CV    = '+r+b+c+m+k+yorobocomokoysrsbscsmsksy';       % Color Vector

for n = 1:KMI
        
   for i = 1:size(F,1)
      for j = 1:K  
        DAL(i,j) = norm(F(i,:) - CENTS(j,:));      
      end
      [Distance CN] = min(DAL(i,1:K));                % 1:K adalah distance dari cluster Centers 1:K 
      DAL(i,K+1) = CN;                                % K+1 adalah Cluster Label
      DAL(i,K+2) = Distance;                          % K+2 adalah Minimum Distance
   end
   for i = 1:K
      A = (DAL(:,K+1) == i);                          % Cluster K Points
      CENTS(i,:) = mean(F(A,:));                      %  Cluster Center Baru
      if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
         NC = find(isnan(CENTS(:,1)) == 1);           % Temukan Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
   
%% Plot   
clf
figure(1)
hold on

 for i = 1:K
PT = F(DAL(:,K+1) == i,:);                            % Temukan points dari tiap kluster    
plot(PT(:,1),PT(:,2),CV(2*i-1:2*i),'LineWidth',2);    % Plot point dengan color determined dan bentuk
plot(CENTS(:,1),CENTS(:,2),'*k','LineWidth',7);       % Plot cluster centers
 end

hold off
grid on
pause(0.1)

end
