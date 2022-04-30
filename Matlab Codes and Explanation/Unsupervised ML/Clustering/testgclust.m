load iris.dat
X=iris(:,1:4);
[N,~]=size(X);
% hitung r dari max jarak
dmax=0;
for i=2:N
    for j=1:i-1
        dij=sum((X(i,:)-X(j,:)).^2);
        if (dij>dmax)
            dmax=dij;
        end
    end
end
r=sqrt(dmax)/13; % untuk hasil yang berbeda
[cls,pnode]=gclust(X,r);
% plot scatter dengan 2 atribut
scatter(X(:,1),X(:,2),[],cls,'filled')
xlabel('Lebar Sepal')
ylabel('Panjang Sepal')
% jalankan plot graph
G=digraph(1:N,pnode,'OmitSelfLoops'); %Skrip smenampilkan hasil sebagai plot dengan tautan langsung dari setiap objek
figure(2)
% Plot di data space
plot(G,'XData',X(:,1),'YData',X(:,2),'MarkerSize',4)
xlabel('Panjang Sepal')
ylabel('Lebar Sepal')
figure(3)
% Plot cluster
plot(G,'Layout','Layered')
% bandingkan kluster dengan klasifikasi 
%
M=max(cls);
conf=zeros(M,3);
for n=1:N
    i=cls(n);
    j=iris(n,5);
    conf(i,j)=conf(i,j)+1;
end
fprintf('Cluster & Setosa & Versicolor & Virginica\n')
for i=1:M
    fprintf('%d ',i)
    for j=1:3
        fprintf('& %d ',conf(i,j))
    end
    fprintf('\n')
end