function drawCircle(x,y,r,color)
%(x,y):= coordinates of the center
angle = 0:0.01:2*pi;
xp = x+ r*cos(angle);
yp = y+ r*sin(angle);
plot(xp,yp,color);