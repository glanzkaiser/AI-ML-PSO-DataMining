function [f] = ObjFun_Rosenbrock(position_matrix, num_particles_2_evaluate)
global dim
    

% Inputs:
    %The "position_matrix" of positions to be evaluated is passed in.
        %This is generally equal to the full position matrix, "x," though it
        %may be a subset - such as one particular row of "x."
        %Order: "num_particles_2_evaluate" x "dim" (usually "np" by "dim")
    %The number of particles/rows to be evaluated, "num_particles_2_evaluate,"
        %is passed in: this is generally equal to the number of particles
        %in the swarm, "np."  Passing this value into the function
        %eliminates the iterative need to calculate size(position_matrix, 1).
        %Order: scalar
% Global Variable:
    %The problem dimensionality, "dim," is declared global since it does
        %not change when the objective function is called.  This eliminates
        %the iterative need to calculate size(position_matrix, 2).
        %Order: scalar
% Output:
    %Column vector "f" contains one function value per particle/row
        %evaluated.
        %Order: "num_particles_2_evaluate" x 1 (usually "np" by 1)

% Global minimizer: ones(1, dim)
% Global minimum: f(ones(1, dim)) = 0
% Initialization space: Assuming symmetric initialization, positions
    %were initialized to lie within [-30, 30] when the
    %position matrix was created.  This can be changed within
    %"Objectives.m."

f = zeros(num_particles_2_evaluate, 1);
for Internal_j = 1:(dim-1)
    f = (1 - position_matrix(1:num_particles_2_evaluate,Internal_j)).^2 + 100*(position_matrix(1:num_particles_2_evaluate,Internal_j+1) - (position_matrix(1:num_particles_2_evaluate,Internal_j)).^2).^2 + f;
end
%verified by comparing values with those generated by:
    %(1) http://www.kyb.tuebingen.mpg.de/bs/people/carl/code/minimize/rosenbrock.m,
    %(2) updating the code available at
    %http://www.koders.com/matlab/fid702CA1061AD02BC5B4D3F1ABBE55319FEC5897B9.aspx