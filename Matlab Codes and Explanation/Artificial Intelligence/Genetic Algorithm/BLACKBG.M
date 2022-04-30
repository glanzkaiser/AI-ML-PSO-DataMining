function blackbg
% ubah background ke hitam

tmp = version;
if str2num(tmp(1))==5, 
    clf;
    colordef(gcf, 'black'); 
end
