function OutputCellFigure(cells, sigma)

global XMAX YMAX X_CELL_NUMB Y_CELL_NUMB;

cell_numb = X_CELL_NUMB * Y_CELL_NUMB;

cell_type=zeros(YMAX,XMAX);
for i=1:cell_numb
    cell_type(sigma==i) = cells.type(i);
end

%        figure(step),
h1=pcolor(cell_type);
set(h1, 'EdgeColor', 'none');
colormap(flipud(gray))
caxis([0 max(cells.type)+0.5])
hold on

[y1, x1] = find(sigma ~= circshift(sigma,[1 0]));
[y2, x2] = find(sigma ~= circshift(sigma,[0 1]));
line_x=horzcat([x1 x1+1]',[x2 x2]');
line_y=horzcat([y1 y1]',[y2 y2+1]');

h2=plot(line_x,line_y,'-');
set(h2, 'Color', [1 0 0]);

axis square

hold off

pause(0.1)

end