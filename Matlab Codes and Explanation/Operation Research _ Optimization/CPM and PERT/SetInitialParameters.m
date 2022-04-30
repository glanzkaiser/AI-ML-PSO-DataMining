function cells=SetInitialParameters(sigma)

global X_CELL_NUMB Y_CELL_NUMB TARGET_CELL_SIZE

cell_numb=X_CELL_NUMB*Y_CELL_NUMB;

for i=1:cell_numb
    cells.area(i,1)=sum(sum(sigma==i));
end

cells.target_area(1:cell_numb,1)=TARGET_CELL_SIZE;

cells.type=randi(2,cell_numb,1); % 1: light cell, 2: dark cell

end
