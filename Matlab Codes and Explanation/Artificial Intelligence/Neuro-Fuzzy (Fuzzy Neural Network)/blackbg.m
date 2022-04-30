function blackbg
% Change figure background to black
%	Issue this to change the background to black (V4 default)

tmp = version;
if str2num(tmp(1))==5, clf; colordef(gcf, 'black'); end
