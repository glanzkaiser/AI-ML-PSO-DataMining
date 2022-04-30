
function [best,fmin,cg_curve]=BBA(n, A, r, d, Max_iter, CostFunction)

% Display help
 %help bat_algorithm.m

%n is the population size, typically 10 to 25
%A is the loudness  (constant or decreasing)
%r is the pulse rate (constant or decreasing)
%d is the dimension of the search variables
%Max_iter is the maximum number of iteration

% This frequency range determines the scalings
Qmin=0;         % Frequency minimum
Qmax=2;         % Frequency maximum
% Iteration parameters
N_iter=0;       % Total jumlah function evaluations


% Initial arrays
Q=zeros(n,1);   % Frekuensi
v=zeros(n,d);   % kecepatan
Sol=zeros(n,d);
cg_curve=zeros(1,Max_iter);
% Initialize the population/solutions
for i=1:n,
    for j=1:d % Utk dimensi
        if rand<=0.5
            Sol(i,j)=0;
        else
            Sol(i,j)=1;
        end
    end
end

for i=1:n,
    Fitness(i)=CostFunction(Sol(i,:));
end
% Find the current best
[fmin,I]=min(Fitness);
best=Sol(I,:);

% Start the iterations -- Binary Bat Algorithm
while (N_iter<Max_iter)
        % Loop over all bats/solutions
        N_iter=N_iter+1;
        cg_curve(N_iter)=fmin;
        for i=1:n,
            for j=1:d
                Q(i)=Qmin+(Qmin-Qmax)*rand;
                v(i,j)=v(i,j)+(Sol(i,j)-best(j))*Q(i); 

                V_shaped_transfer_function=abs((2/pi)*atan((pi/2)*v(i,j))); 
                
                if rand<V_shaped_transfer_function 
                    Sol(i,j)=~Sol(i,j);
                else
                    Sol(i,j)=Sol(i,j);
                end
                
                if rand>r  % Pulse rate
                      Sol(i,j)=best(j);
                end   
               
            end       
            
           Fnew=CostFunction(Sol(i,:)); % Evaluate new solutions
     
           if (Fnew<=Fitness(i)) && (rand<A)  % If the solution improves or not too loudness
                Sol(i,:)=Sol(i,:);
                Fitness(i)=Fnew;
           end

          % Update the current best
          if Fnew<=fmin,
                best=Sol(i,:);
                fmin=Fnew;
          end
        end
        
        % Output/display
disp(['Jumlah evaluasi: ',num2str(N_iter)]);
disp([' fmin=',num2str(fmin)]);
     
end


