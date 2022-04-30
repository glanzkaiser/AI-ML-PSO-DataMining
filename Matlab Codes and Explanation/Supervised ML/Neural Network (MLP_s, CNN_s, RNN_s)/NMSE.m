function NMSE_calc = NMSE( wb, net, input, target)
% wb adalah bobot dan bias row vector yang berisi dari algoritma genetika
% harus di transpos pas masukkan bobot dan bias ke network net.
 net = setwb(net, wb');

% hasil matriks net output ditampilkan net(input). error matriksnya dibawah
 error = target - net(input);

% Mean squared error normalisasi dari mean variance
 NMSE_calc = mean(error.^2)/mean(var(target',1));
%jadi independen scale dari komponen target
% Rsquare = 1 - NMSEcalc 
