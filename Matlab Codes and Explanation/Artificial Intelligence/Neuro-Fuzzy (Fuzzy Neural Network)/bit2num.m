function num = bit2num(bit, range)
% BIT2NUM konversi dari string bit ke jumlah desimal.
%	BIT2NUM(BIT, RANGE) konversi string bit dimana RANGE adalah vecktor 2 elemen
%	spesifikan range dari jumlah desimal yg dikonversi
%
%	For example:
%
%	bit2num([1 1 0 1], [0, 15])
%	bit2num([0 1 1 0 0 0 1], [0, 127])

integer = polyval(bit, 2);
num = integer*((range(2)-range(1))/(2^length(bit)-1)) + range(1);
