function plotCurveBar( x, y, sigma )
color = [255,228,225]/255; %pink
[x,idx] = sort(x);
y = y(idx);
sigma = sigma(idx);

fill([x,fliplr(x)],[y+sigma,fliplr(y-sigma)],color);
hold on;
plot(x,y,'r-');
hold off
axis([x(1),x(end),-inf,inf])

