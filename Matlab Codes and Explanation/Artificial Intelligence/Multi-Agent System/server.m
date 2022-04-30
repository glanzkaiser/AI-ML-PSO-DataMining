
clc;
clear all;
close all;
AgentNum=10; % jumlah Agents
AgentSize=100; %ukuran agents dalam plot
Dimension=3; % Pilih Dim
SizeOfEnvironmet=[15 15 15 ;-4 -4 -4]; %ukuran Environmet (MAX(X Y Z);MIN(X Y Z))
if Dimension==2
    Dim='2';
else
    Dim='3';
end

sMat=ServerMat(AgentNum,Dimension,SizeOfEnvironmet); % buat 1 posisi agents
whitebg('black')
%% buat 1 plot agent pake scatter plot

switch Dim
   case '2'
     scatter(sMat(:,1),sMat(:,2),AgentSize,sMat(:,3),'filled')
   case '3'
     scatter3(sMat(:,1),sMat(:,2),sMat(:,3),AgentSize,sMat(:,4),'filled') 
   otherwise
        error('myApp:argChk', 'Wrong number of input Dim')
end

%% Update agents position
Step=.5; % buat klangkah tiap iterasi
Max_It=100; % max iterasi dari agents


pause(0.5);
for it=1:Max_It
    switch Dim
        case '2'
            sMat=UpdatePos(sMat,Step,AgentSize,Dimension,AgentNum);
            scatter(sMat(:,1),sMat(:,2),AgentSize,sMat(:,3),'filled')
        case '3'
            sMat=UpdatePos(sMat,Step,AgentSize,Dimension,AgentNum);
            scatter3(sMat(:,1),sMat(:,2),sMat(:,3),AgentSize,sMat(:,4),'filled')
    end
    disp(['Iteration :' num2str(it) ]);
    pause(0.05);
end
