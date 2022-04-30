function Show_EWT2D_Tensor(ewt2d)


minI=255.0;
maxI=0.0;

[nr,nc]=size(ewt2d);

% temukan min dan max melebihi semua gambar
for r=1:nr;
    for c=1:nc;
        minI=min(minI,min(ewt2d{r,c}(:)));
        maxI=max(maxI,max(ewt2d{r,c}(:)));
    end
end

% Plot 
figure;
for c=1:nc;
    for r=1:nr;
       n=(c-1)*nr+r;
       subplot(nc,nr,n);imshow(ewt2d{r,c},[minI maxI]); 
    end
end
