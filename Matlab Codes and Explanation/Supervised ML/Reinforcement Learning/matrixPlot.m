function matrixPlot( Matrix ) 
imagesc(Matrix)
colormap(winter);

% buat string dari values R
Tstring = num2str(Matrix(:),'%d'); 

% hapus padding
Tstring= strtrim(cellstr(Tstring));

% buat x dan y koordinat dari string
[x,y] = meshgrid(1:length(Matrix));

% Plot string
text(x(:),y(:),Tstring(:));

end

