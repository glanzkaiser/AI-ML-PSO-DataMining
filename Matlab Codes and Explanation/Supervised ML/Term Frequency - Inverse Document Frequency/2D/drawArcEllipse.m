function drawArcEllipse(x,y,a,b,theta0,theta1,color)
% r: = radius of the circle
angle = theta0+0.01:0.01:theta1;
xp = x+ a*cos(angle);
yp = y+ b*sin(angle);
plot(xp,yp,color);

% plot 
angle = theta0+pi+0.01:0.01:theta1+pi;
xp = x+ a*cos(angle);
yp = y+ b*sin(angle);
plot(xp,yp,color);