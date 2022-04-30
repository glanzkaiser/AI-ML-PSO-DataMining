
clear all;
load parametres;
clc;
nbregeneration = ng;	
taillepopulation = ni;	
probdecroisement = pc;
probdemutation = pm;	
nbredebits = nb;		
disp('*************************************************************');
disp('           Algoritma Genetika            ');
disp('*************************************************************');

disp([' jumlah generasi     =',num2str(ng)]);
disp([' jumlah individu       =',num2str(ni)]);
disp([' probabilitas sama =',num2str(pc)]);
disp([' Probalitas mutasi   =',num2str(pm)]);
disp([' jumlah bit   =',num2str(nb)]);
disp('*************************************************************');




figure;
blackbg;
obj_fcn = 'mafonc';	
nbredevariable = 2;		
intervalle = [-5, 5; -5, 5];	

fonction;

	
popu = rand(taillepopulation, nbredebits*nbredevariable) > 0.5; 

haut = zeros(nbregeneration, 1);
moyen = zeros(nbregeneration, 1);
bas = zeros(nbregeneration, 1);
%************************************

disp('*************************************************************');
disp(['         Evaluasi ',num2str(nbregeneration),' Générasi']);
disp('*************************************************************');
for i = 1:nbregeneration;
  

	fcn_evaluation = evalpopu(popu, nbredebits, intervalle, obj_fcn);


	
	haut(i) = max(fcn_evaluation );
	moyen(i) = mean(fcn_evaluation );
	bas(i) = min(fcn_evaluation );
	[meilleur, index] = max(fcn_evaluation );
	fprintf('Générasi %i: ', i);
	fprintf('f(%f, %f)=%f\n', ...
			bit2num(popu(index, 1:nbredebits), intervalle(1,:)), ...
			bit2num(popu(index, nbredebits+1:2*nbredebits), intervalle(2,:)), ...
			meilleur);
     
	popu = nextpopu(popu, fcn_evaluation , probdecroisement, probdemutation);

   xopt=bit2num(popu(index, 1:nbredebits), intervalle(1,:));%x optimal
   yopt=bit2num(popu(index, nbredebits+1:2*nbredebits), intervalle(2,:));%y optimal
  
  xopts(i)=xopt ;
  yopts(i)=yopt ;
   savefile = 'resultats.mat';

save(savefile,'xopt','yopt','meilleur')
   
end
disp('*************************************************************');
disp(['      temukan evaluasi f(x,y) pour les ',num2str(nbregeneration),' Générasi']);
disp('*************************************************************');
disp( '       Résultats :  ');
disp(['                       x =',num2str(xopt)]);
disp(['                       y =',num2str(yopt)]);
disp(['                       f(',num2str(xopt),',',num2str(yopt),') =',num2str(meilleur)]);
disp('*************************************************************');

xevolution =xopts ;
yevolution = yopts;
grid on
subplot(2,1,1); plot(xevolution);xlabel('Générasi'); ylabel('x');
subplot(2,1,2); plot(yevolution);xlabel('Générasi'); ylabel('y');
%**************************************************************************


figure;
blackbg;
x = (1:nbregeneration)';
plot(x, haut, 'o', x, moyen, 'x', x, bas, '*');
hold on;
plot(x, [haut moyen bas]);
hold off;
legend('Meilleur', 'Moyenne', 'Faible');
xlabel('Générations'); 
ylabel('F(x,y)');
%**************************************************************************
