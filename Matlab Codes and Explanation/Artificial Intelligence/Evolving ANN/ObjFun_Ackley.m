function [f] = ObjFun_Ackley(position_matrix, num_particles_2_evaluate)
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

% Global minimizer: zeros(1, dim)
% Global minimum: f(zeros(1, dim)) = 0
% Initialization space: Assuming symmetric initialization, positions
    %were initialized to lie within [-30, 30] or [-32, 32] when "x"
    %was created.  This can be changed within "Objectives.m."

f = -20*exp(-sqrt(sum(position_matrix(1:num_particles_2_evaluate,:).^2, 2)/dim)/5) - exp(sum(cos(2*pi*position_matrix(1:num_particles_2_evaluate,:)), 2)/dim) + exp(1) + 20;

%verified on each row of "position_matrix = 2*rand(4, 6)" by comparing to results produced by
  %http://www-optima.amp.i.kyoto-u.ac.jp/member/student/hedar/Hedar_files/TestGO_files/TestGO_files/TestCodes/ackley.m
  %after modifying its x(i) notation to position_matrix(i, Internal_j).