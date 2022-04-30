%	Animation of two generalized bell membership functions.

clc; echo on
% This program shows how two generalized bell functions change their widths,
% centers and midpoing slopes as their three parameters (a, b, c) changes.
echo off

x = linspace(-10, 10)';
mfH = line(x, nan*[x x], 'erasemode', 'xor', 'linewidth', 2);
axis([-10 10 0 1]);
textH1 = text(0, 0.9, '', 'erasemode', 'xor', 'horizon', 'center');
textH2 = text(0, 0.1, '', 'erasemode', 'xor', 'horizon', 'center');
set(gca, 'box', 'on');

stop = 0;
stopH = uicontrol('string', 'Stop', 'callback', 'stop=1;', 'inter', 'yes');

i = 0;
while ~stop,
	i = i+0.04;
	a1 = 3; b1 = 4*sin(i); c1 = 5*cos(i);
	y = gbell_mf(x, [a1, b1, c1]);
	set(mfH(1), 'YData', y)
	a2 = 6; b2 = 4*sin(i+pi/2); c2 = 5*cos(i+pi/2);
	y = gbell_mf(x, [a2, b2, c2]);
	set(mfH(2), 'YData', y)
	text1 = sprintf('Yellow MF: (a, b, c) = (%.2f, %.2f, %.2f)', a1,b1,c1);
	text2 = sprintf(   'Red MF: (a, b, c) = (%.2f, %.2f, %.2f)', a2,b2,c2);
	set(textH1, 'string', text1);
	set(textH2, 'string', text2);
	drawnow
end
