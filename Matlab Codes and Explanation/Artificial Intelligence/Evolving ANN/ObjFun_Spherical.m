function [f] = ObjFun_Spherical(position_matrix, num_particles_2_evaluate)
    

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
% Output:
    %Column vector "f" contains one function value per particle/row
        %evaluated.
        %Order: "num_particles_2_evaluate" x 1 (usually "np" by 1)

% Global minimizer: zeros(1, dim)
% Global minimum: f(zeros(1, dim)) = 0
% Initialization space: Assuming symmetric initialization, positions
    %were initialized to lie within [-100, 100] or [-5.12 5.12] when the
    %position matrix was created.  This can be changed within
    %"Objectives.m."

f = sum(position_matrix(1:num_particles_2_evaluate,:).^2, 2);