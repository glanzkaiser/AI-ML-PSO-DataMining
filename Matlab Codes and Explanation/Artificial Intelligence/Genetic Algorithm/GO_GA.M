***************************************************
clear all;
close all;

%**************************************************************************
%Inisialisasi parameter :
%**************************************************************************
nbregeneration = ng;	
taillepopulation = ni;		
probdecroisement = pc;	
probdemutation = pm;	
nbredebits = ni;		   
%**************************************************************************

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
for i = 1:nbregeneration;
  

	fcn_evaluation = evalpopu(popu, nbredebits, intervalle, obj_fcn);


	
	haut(i) = max(fcn_evaluation );
	moyen(i) = mean(fcn_evaluation );
	bas(i) = min(fcn_evaluation );
	[meilleur, index] = max(fcn_evaluation );
	fprintf('Generation %i: ', i);
	fprintf('f(%f, %f)=%f\n', ...
			bit2num(popu(index, 1:nbredebits), intervalle(1,:)), ...
			bit2num(popu(index, nbredebits+1:2*nbredebits), intervalle(2,:)), ...
			meilleur);
	popu = nextpopu(popu, fcn_evaluation , probdecroisement, probdemutation);

   xopt=bit2num(popu(index, 1:nbredebits), intervalle(1,:))%x optimal
   yopt=bit2num(popu(index, nbredebits+1:2*nbredebits), intervalle(2,:))%y optimal
   hold on
   plot(xopt,yopt,'r.')
   
   
end
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