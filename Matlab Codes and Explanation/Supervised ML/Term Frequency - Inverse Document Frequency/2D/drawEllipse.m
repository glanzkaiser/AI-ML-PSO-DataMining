function drawEllipse(x,y,a,b,color)
%(x,y):= coordinates of the center
angle = 0:0.01:2*pi;
xp = x+ a*cos(angle);
yp = y+ b*sin(angle);
plot(xp,yp,color);