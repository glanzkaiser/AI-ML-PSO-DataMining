function [ theclass,data3 ] = GenToyData( )

%contoh dengan 100 point distribusi
%jalankan sebuah r sebagai squre root
%jalankan t dalam (0,  $2\pi$ )
%dan taruh dalam (r cos( t ), r sin( t )).


rng(1); 
r = sqrt(rand(100,1)); % Radius
t = 2*pi*rand(100,1);  %sudut
data1 = [r.*cos(t), r.*sin(t)]; % Points
r2 = sqrt(3*rand(100,1)+1); % Radius
t2 = 2*pi*rand(100,1);      %sudut
data2 = [r2.*cos(t2), r2.*sin(t2)]; % points

%taruh data dalam 1 matriks dan buat klasifikasi vektornya 
data3 = [data1;data2];
theclass = ones(200,1);
theclass(1:100) = -1;


end

