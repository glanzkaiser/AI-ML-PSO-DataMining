clear all
clc
close all
food={ 'Rice','Quinoa','Tortilla','Lentils','Broccoli' }';
Nutrients={ 'Carbohydrates','Protiens','Fat'}';

Amount_of_nutrients_per_food=[ 53 40 12 53 6; 4.4 8 3 12 1.9; 0.4 3.6 2 0.9 0.3];
cost=[ 0.5 ;0.9 ;0.1 ;0.6 ;0.4];
A_new=[-0.2 0.54 0.06 0.36 0.24; 0.3 -0.36 0.06 0.36 0.24; 0.3 0.54 -0.04 0.36 0.24;...
        0.3 0.54 0.06 -0.24 0.24; 0.3 0.54 0.06 0.36 -0.16];

minimum=[ 100 ;10 ;0];
maximum= [ 1000; 10 ;100];

A_Big=[Amount_of_nutrients_per_food;-Amount_of_nutrients_per_food ; -eye(length(cost)); -A_new];
B_Big=[maximum;-minimum;-zeros(length(cost),1);-zeros(5,1)];



Sol=linprog(cost,A_Big,B_Big)

I=find(Sol>1e-6);

for ii=1:length(I)
    disp(food{I(ii)})
end