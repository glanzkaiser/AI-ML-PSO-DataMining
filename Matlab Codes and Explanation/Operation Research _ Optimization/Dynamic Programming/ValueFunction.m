%DYNAMIC PROGRAMMING IN GRID SEARCH%
%**************************************************************
%************************************************************

clc; clear all; clear classes;

%Sample grid
grid = [0, 0, 1, 0, 0, 0;
        0, 0, 1, 0, 0, 0;
        0, 0, 1, 0, 0, 0;
        0, 0, 0, 0, 1, 0;
        0, 0, 1, 1, 1, 0;
        0, 0, 0, 0, 1, 0];

goal = [size(grid,1), size(grid,2)]; % Make sure that the goal definition stays in the function.

cost=1;

delta = [-1,  0; % go up
          0, -1; % go left
          1,  0; %go down
          0,  1]; % go right
 
 Goal=Search();
 Goal=Goal.Set(goal(1),goal(2),grid(goal(1),goal(2)));
 
 ValueGRID=zeros(size(grid));
 
 %creates  GRID of cells with 'Search' class object
 for i=1:size(grid,1)
     for j=1:size(grid,2)
         gridCell=Search();
         if(grid(i,j)>0)
            gridCell=gridCell.Set(i,j,1);
         else
             gridCell=gridCell.Set(i,j,0);
         end
         GRID(i,j)=gridCell;
         clear gridCell;
     end
 end
 
 OpenList=[Goal];

%Generate the value function
     
while(~isempty(OpenList))
    GRID(OpenList(1).currX,OpenList(1).currY).isChecked=1;

    for j=1:size(delta,1)
        direction=delta(j,:);
        if(OpenList(1).currX+ direction(1)<1 || OpenList(1).currX+direction(1)>size(grid,1)|| OpenList(1).currY+ direction(2)<1 || OpenList(1).currY+direction(2)>size(grid,2))
            continue;
        else
            NewCell=GRID(OpenList(1).currX+direction(1),OpenList(1).currY+direction(2));
             
            if(NewCell.isEmpty==1)
                ValueGRID(NewCell.currX,NewCell.currY)=99;
            end
             if(NewCell.isChecked~=1 && NewCell.isEmpty~=1)
                NewCell.gValue=OpenList(1).gValue+cost;
                OpenList=[OpenList,NewCell];
                ValueGRID(NewCell.currX,NewCell.currY)=NewCell.gValue;
                GRID(NewCell.currX,NewCell.currY).isChecked=1;
             end
        end
    end
    OpenList(1)=[];
    

end
   
   
 disp(ValueGRID);

 PolicyDirection={'MoveUp','MoveLeft','MoveDown','MoveRight'};
 
 %Generate the most suitable policy required for each cell
 
for i=1:size(ValueGRID,1)
    for j=1:size(ValueGRID,2)
        for k=1:size(delta,1)
            direction=delta(k,:);
            if(i+ direction(1)<1 || i+direction(1)>size(grid,1)|| j+ direction(2)<1 || j+direction(2)>size(grid,2))
                continue;
            else
                if((ValueGRID(i+ direction(1),j+ direction(2))<ValueGRID(i,j))&&ValueGRID(i,j)~=99&&ValueGRID(i+ direction(1),j+ direction(2))~=99)
                    Policy(i,j)=PolicyDirection(k);
                end
            end
            if(i==goal(1)&&j==goal(2))
               Policy(i,j)={'GOAL'};
            end
        end
    end
end

disp(Policy);

            
        

 
