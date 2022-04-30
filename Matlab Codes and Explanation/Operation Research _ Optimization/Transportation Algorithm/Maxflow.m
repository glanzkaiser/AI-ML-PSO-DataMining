% perbaikan max flow menggunakan minimum cut theory
Flow=sparse([1 1 1 2 3 3 4 5 6 6 6 7 7],[2 3 4 7 2 6 5 8 2 5 8 6 8],[4 2 3 2 3 1 2 1 4 3 4 2 3],8,8);
[M,F,K]=graphmaxflow(Flow,1,8);
% M =  maximum flow of products
% F= flow on each link
% K = minimum cut (result displayed in matrix)
view(biograph(F,[],'ShowWeights','on')) % shows a graph
set(h,Nodes(K(1,:)),'Color',[1 0 0]);