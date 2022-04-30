% Interactive demo of steepest descent paths on "peaks" surface.

% Roger Jang, Oct-16-96

figure('name', 'Steepest Descent', 'NumberTitle', 'off');
blackbg;
x=-3:.2:3;
y=-3:.2:3;
[xx,yy]=meshgrid(x,y);
zz=peaks(xx,yy);
surf(xx, yy, zz);
axis([-inf inf -inf inf -inf inf]);
colormap((jet+white)/2);
ballH = line(nan, nan, nan, 'linestyle', '.', 'markersize', 20, ...
	'erase', 'xor', 'color', 'g');
segment3dH = line(nan, nan, nan, 'erase', 'none', 'color', 'r');
set(gca, 'box', 'on');

figure('name', 'Steepest Descent', 'NumberTitle', 'off');
blackbg;
hold on;
h=pcolor(x,y,zz);
set(h, 'erase', 'none');
colormap((jet+white)/2);
shading interp;
%[px,py]=gradient(zz,.2,.2);
%quiver(x,y,-px,-py,2,'k');
if matlabv == 4,
	[junk, contourH] = contour(xx, yy, zz, 20);
elseif matlabv == 5,
	[junk, contourH] = contour(xx, yy, zz, 20, 'k-');
else
	error('Unknown MATLAB version!');
end
hold off;
axis([-3 3 -3 3]); axis square; axis off;
circleH = line(nan, nan, 'linestyle', '.', 'erase', 'xor', 'color', 'g', ...
	'markersize', 20);
segment2dH = line([nan nan], [nan nan], 'erase', 'none', 'color', 'r');
set(contourH, 'erase', 'none', 'color', 'w');
title('Click, hold and drag to see steepest-descent paths');

AxisH = gca; FigH = gcf;
obj_fcn = 'peaksf';
eta = 0.1;

% The following is for animation
% action when button is first pushed down
% This action draws GD path on 2D plot only
action1a = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'x=curr_info(1,1);y=curr_info(1,2);z=feval(obj_fcn,x,y);', ...
	'set(circleH,''xdata'',x,''ydata'',y);', ...
	'set(ballH,''xdata'',x,''ydata'',y,''zdata'',z);', ...
	'for i=1:20,', ...
	'grad=feval(obj_fcn,x,y,1);', ...
	'tmp=-grad/norm(grad);', ...
	'new_x=x+eta*tmp(1);', ...
	'new_y=y+eta*tmp(2);', ...
	'set(segment2dH,''xdata'',[x,new_x],''ydata'',[y,new_y]);', ...
	'x = new_x;', ...
	'y = new_y;', ...
	'end'];
% This action draws GD path on 3D surface too
action1b = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'x=curr_info(1,1);y=curr_info(1,2);z=feval(obj_fcn,x,y);', ...
	'set(circleH,''xdata'',x,''ydata'',y);', ...
	'set(ballH,''xdata'',x,''ydata'',y,''zdata'',z);', ...
	'for i=1:20,', ...
	'grad=feval(obj_fcn,x,y,1);', ...
	'tmp=-grad/norm(grad);', ...
	'new_x=x+eta*tmp(1);', ...
	'new_y=y+eta*tmp(2);', ...
	'new_z=feval(obj_fcn,new_x,new_y);', ...
	'set(segment2dH,''xdata'',[x,new_x],''ydata'',[y,new_y]);', ...
	'set(segment3dH,''xdata'',[x,new_x],''ydata'',[y,new_y],''zdata'',[z,new_z]);', ...
	'x = new_x;', ...
	'y = new_y;', ...
	'z = new_z;', ...
	'end'];
action1 = action1b;

% actions after the mouse is pushed down
action2 = action1;
% action when button is released
action3 = action1;

% temporary storage for the recall in the down_action
set(AxisH,'UserData',action2);

% set action when the mouse is pushed down
down_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'',get(AxisH,''UserData''));' ...
    action1];
set(FigH,'WindowButtonDownFcn',down_action);

% set action when the mouse is released
up_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'','' '');', action3];
set(FigH,'WindowButtonUpFcn',up_action);