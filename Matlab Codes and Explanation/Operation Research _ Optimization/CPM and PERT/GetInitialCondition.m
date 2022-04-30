function out=GetInitialCondition()

global XMAX YMAX X_CELL_NUMB Y_CELL_NUMB TARGET_CELL_SIZE

mat=1:X_CELL_NUMB*Y_CELL_NUMB;
mat=reshape(mat,Y_CELL_NUMB,X_CELL_NUMB);
mat=repelem(mat, floor(sqrt(TARGET_CELL_SIZE)),floor(sqrt(TARGET_CELL_SIZE)));
[len_row, len_col]=size(mat);

out=zeros(YMAX,XMAX);
out(1:len_row,1:len_col)=mat;
out=circshift(out,[round((YMAX-len_row)/2) round((XMAX-len_col)/2)]);

end