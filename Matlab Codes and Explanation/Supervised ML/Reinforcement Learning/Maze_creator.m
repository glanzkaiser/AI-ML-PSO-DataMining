clear all;clc;

% n => Size of the maze
n=8;

maze=-50*ones(n,n);

% secara acak generating Path/Links
for i=1:(n-3)*length(maze)
    maze(randi([1,n]),randi([1,n]))=1;
end

%mulai Node
maze(1,1)=1;

% Goal
maze(n,n)=10;

%Plot MAZE
figure
matrixPlot(maze)
