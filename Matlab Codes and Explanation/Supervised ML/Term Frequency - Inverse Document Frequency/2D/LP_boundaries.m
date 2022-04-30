function LP_boundaries(f,boundaries)

color='white';
figure;imshow(log(1+fftshift(abs(fft2(f)))),[]);
hold on;
for n=1:length(boundaries)
    a=boundaries(n)*floor(size(f,2)/(2*pi));
    b=boundaries(n)*floor(size(f,1)/(2*pi));
    drawEllipse(floor(size(f,2)/2)+1,floor(size(f,1)/2)+1,a,b,color);
end