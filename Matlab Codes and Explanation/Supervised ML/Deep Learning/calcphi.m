 function [phi]=calcphi(x,y,kwidth)

phi=exp(-(1/kwidth)*sum((x-y).^2));