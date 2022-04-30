
%Inisialisasi
clear all;clc;
load('maze8x8.mat');
figure
matrixPlot(maze)
% Plott Mazenya, dimensinya adalah  : 8x8
% * mulai posisi (1,1)
% * Goalnya (8,8)
%
n=length(maze);

figure
imagesc(maze)
colormap(winter)

for i=1:n
    for j=1:n
        if maze(i,j)==min(maze)
            text(j,i,'X','HorizontalAlignment','center')
        end
    end
end
text(1,1,'START','HorizontalAlignment','center')
text(n,n,'GOAL','HorizontalAlignment','center')

axis off

Goal=n*n;
fprintf('Goal State is: %d',Goal)
% Buat Matriks Reward untuk Maze
% Gerakan
% 
% * Up     (i-n)
% * Down   (i+n)
% * Left   (i-1)
% * Right  (i+1)
% * Diagonally SE (i+n+1)
% * Diagonally SW (i+n-1)
% * Diagonally NE (i-n+1)
% * Diagonally NW (i-n-1)
% 
%
reward=[];

for i=1:Goal
    reward=[reward;reshape(maze',1,Goal);];
end

for i=1:Goal
for j=1:Goal
    if j~=i-n && j~=i+n && j~=i-1 && j~=i+1 && j~=i+n+1 && j~=i+n-1 && j~=i-n+1 && j~=i-n-1
        reward(i,j)=-Inf;
    end
end
end
% 
% * Inisialisasi matriks Q
% * Setting wilayah tujuane 'n*n'. 
% * Gamma=0.5 dan alpha=0.5 (Selected after several runs)
% * Max dari jumlah iterasi 
%
q=zeros(size(reward));
gamma=0.5; alpha=0.5; maxItr=100;

% 
% * Ulangi sampai Convergence OR Maximum Iterations
% * cs => current state
% * ns => next state
%
for i=1:maxItr
    
    % Mulai dari random state    
    cs=randi([1 length(reward)],1,1);
    
    % ulangi sampe goal state
    while(1)

        % aksi yang memungkinkan ke wilayah sekarang 
        actions=find(reward(cs,:)>0);
    
        % wilayah selanjutnya 
        ns=actions(randi([1 length(actions)]));
        
        % aksi selanjutnya utk bagian selanjutnya
        actions=find(reward(ns,:)>0);
            
        % q value, aksi untuk milih secara acak dari seluruh aksi
        randq=q(ns,actions(randi([1,length(actions)])));

        % updating dari Action-Value Function    
        q(cs,ns)=q(cs,ns)+alpha*(reward(cs,ns)+gamma*randq -q(cs,ns));

        % Break, if wilayah goal sudah didapat
        if(cs == Goal)
            break;
        end
    
        % Else Current-state adalah Next-State
        cs=ns;
    end  
end
% perbaikan akan maze, menemukan path dari start ke goal
% * mulai dari posisi awal
%
start=1;move=0;
path=[start];
% 
% * Iterasi sampai  Goal-State didapat
%
while(move~=Goal)
    [~,move]=max(q(start,:));
    
    % hapus loops
    if ismember(move,path)
        [~,x]=sort(q(start,:),'descend');
        move=x(2); 
        if ismember(move,path)
            [~,x]=sort(q(start,:),'descend');
            move=x(3);  
        end
    end
    
    % tambahkan aksi selanjutny / pindahkan ke path
    path=[path,move]
    start=move;
end
% solusi ke maze, dari awal ke akhir
%
fprintf('Final Path: %s',num2str(path))

pmat=zeros(n,n);

[q, r]=quorem(sym(path),sym(n));
q=double(q+1);r=double(r);
q(r==0)=n;r(r==0)=n;

for i=1:length(q)
    pmat(q(i),r(i))=50;
end  
% final plot dari maze
%
figure
imagesc(pmat)
colormap(white)

for i=1:n
    for j=1:n
        if maze(i,j)==min(maze)
            text(j,i,'X','HorizontalAlignment','center')
        end
        if pmat(i,j)==50
            text(j,i,'\bullet','Color','red','FontSize',28)
        end
    end
end
text(1,1,'START','HorizontalAlignment','right')
text(n,n,'GOAL','HorizontalAlignment','right')

hold on
imagesc(maze,'AlphaData',0.2)
colormap(winter)
hold off
axis off