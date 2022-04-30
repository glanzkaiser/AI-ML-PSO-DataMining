function [f] = ObjFun_Schwefel(position_matrix, num_particles_2_evaluate)
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
% Output:
    %Column vector "f" contains one function value per particle/row
        %evaluated.
        %Order: "num_particles_2_evaluate" x 1 (usually "np" by 1)

% Global minimizer: 420.968746*ones(1, dim)
% Global minimum: f(420.968746*ones(1, dim)) = 0
% Note: f*(420.968746, ..., 420.968746) = 0 (within the search space anyway)
% Note: f*(420.9687, ..., 420.9687) = -418.9829*dim in the original
    %Schwefel, but the addition of 418.9829*dim below shifts the function
    %vertically in order to create a minimum of 0.
% Initialization space: Assuming symmetric initialization, positions
    %were initialized to lie within [-500, 500] when the
    %position matrix was created.  This can be changed within
    %"Objectives.m."

f = 418.982887272433799807913601398*dim - sum((position_matrix(1:num_particles_2_evaluate,:).*sin(sqrt(abs(position_matrix(1:num_particles_2_evaluate,:))))), 2);
    %"418.9829*dim" is added in order to convert the minimum function value
        %from -418.9829*dim to 0 so that mean performance across objectives
        %can be calculated.
    %sum(...,2) sums the elements of each row returning one function
        %value per particle since each row of "position_matrix" is a particle's
        %location in n-dimensional space
%Note: 418.982887272433799807913601398*30 = 12569.48661817301399423740804194
%Caution: Unlike many objectives, better solutions to Schwefel can
    %be found outside the search space since the amplitude of its crests
    %and waves become more severe farther from the origin.  This is a
    %consideration since it requires that particles be bounded to the
    %search space or a capable algorithm may find solutions better than
    %what, within the search space, is considered the global minimizer.