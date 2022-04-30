function [f] = ObjFun_Rosenbrock_Engelbrecht_VandenBergh(position_matrix, num_particles_2_evaluate)
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
    %were initialized to lie within [-2.048, 2.048] when the
    %position matrix was created.  This can be changed within
    %"Objectives.m."

% This is the Rosenbrock formula used by Van den Bergh in his PhD thesis,
% which is simpler than the more popular Rosenbrock formula.

f = 0;
for Internal_j = 1:dim/2
    f = (1 - position_matrix(1:num_particles_2_evaluate,2*Internal_j-1)).^2 + 100*(position_matrix(1:num_particles_2_evaluate,2*Internal_j) - (position_matrix(1:num_particles_2_evaluate,2*Internal_j-1)).^2).^2 + f;
end