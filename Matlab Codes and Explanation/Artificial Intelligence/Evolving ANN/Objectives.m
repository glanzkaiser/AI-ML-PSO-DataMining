
%Set the initial range_IS of each dimension of the search space (i.e. max -
    %min).  The scalar value below will be converted to an "np" by "dim" matrix.
%(Though it is not necessary, I have seperately specified "range_IS0" as the initial range_IS
    %for clarity since RegPSO changes the range_IS with each regrouping.)
%(There appears to be a flaw in MATLAB that occasionally requires the use of "isequal"
    %for "if" statements using string comparisons.)
 
if objective_id == 0  %Input validation in case user leaves objective_id
    objective_id = 1; % set to zero in the parameters file when using one
end                   %table (i.e. since it is set to 0 when using multiple tables).
if objective_id == 1
    objective = 'Ackley';
    if OnOff_asymmetric_initialization
        range_IS0 = 15; %asymmetric [15, 30]
        center_IS0 = 22.5; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*30; %Three range_ISs seen in literature: [-32.768, 32.768], [-32, 32] & [-30, 30].
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
%     Or uncomment the code below to use [-32, 32] as the search space per dimension
%     if OnOff_asymmetric_initialization
%         range_IS0 = 16; %asymmetric [16, 32]
%         center_IS0 = 24; %i.e. (lower bound + upper bound)/2
%     else
%         range_IS0 = 2*32; %Three range_ISs seen in literature: [-32.768, 32.768], [-32, 32] & [-30, 30].
%         center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
%             %default for each particle).
%     end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to a value appropriate for the selected dimensionality.
    if OnOff_SuccessfulUnsuccessful
        if dim == 30
            thresh_for_succ = 5; %Thresholds of 0.1 & 5 have been used on Ackley.
        elseif dim == 2
            thresh_for_succ = 5*10^(-5);
        end
    end
elseif objective_id == 2
    objective = 'Griewangk';
    if OnOff_asymmetric_initialization
        range_IS0 = 300; %asymmetric [300, 600]
        center_IS0 = 450; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*600;
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to a value appropriate for the selected dimensionality.
    if OnOff_SuccessfulUnsuccessful
        if dim == 30
            thresh_for_succ = 1; %objective threshhold used to determine
                %whether a trial was successful or unsuccessful
        elseif dim == 2
            thresh_for_succ = 10^(-5);
        end
    end
elseif objective_id == 3
    objective = 'Quadric';
    if OnOff_asymmetric_initialization
        range_IS0 = 50; %asymmetric [50, 100]
        center_IS0 = 75; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*100; %[-100, 100] in many papers, but 
            %[-65.536, 65.536] at http://www.geatbx.com/docu/fcnindex-01.html
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to a value appropriate for the selected dimensionality.
    if OnOff_SuccessfulUnsuccessful
        if dim == 30
            thresh_for_succ = 0.01;
        elseif dim ==2
            thresh_for_succ = 10^(-7);
        end
    end
elseif objective_id == 4
    objective = 'Quartic_Noisy';
    if OnOff_asymmetric_initialization
        range_IS0 = 0.64; %asymmetric [0.64, 1.28]
        center_IS0 = 0.96; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*1.28; %[-1.28, 1.28] in many papers, but 
            %[-65.536, 65.536] at http://www.geatbx.com/docu/fcnindex-01.html
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to a value appropriate for the selected dimensionality.
    if OnOff_SuccessfulUnsuccessful %Prevents workspace clutter by adding "thresh_for_succ" only when it is to be used.
        if dim == 30
            thresh_for_succ = 10^(-7);
        elseif dim ==2
            thresh_for_succ = 10^(-7);
        end
    end
elseif objective_id == 5
    objective = 'Rastrigin';
    if OnOff_asymmetric_initialization
        range_IS0 = 2.56; %asymmetric [2.56, 5.12]
        center_IS0 = 3.84; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*5.12; %[-5.12, 5.12]
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to a value appropriate for the selected dimensionality.
    if OnOff_SuccessfulUnsuccessful
        if dim == 30
            thresh_for_succ = 100;
        elseif dim == 2
            thresh_for_succ = 0.001;
        end
    end
elseif objective_id == 6
    objective = 'Rosenbrock';
    if OnOff_asymmetric_initialization
        range_IS0 = 15; %asymmetric: [15, 30] or [1.024, 2.048]
        center_IS0 = 22.5; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*30; %Note: [-30, 30] common, but [-2.048, 2.048] in 
            %Van den Bergh's PhD thesis (with a simpler Rosenbrock)
            %& at http://www.geatbx.com/docu/fcnindex-01.html
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to a value appropriate for the selected dimensionality.
    if OnOff_SuccessfulUnsuccessful
        if dim == 30
            thresh_for_succ = 100;
        elseif dim == 2
            thresh_for_succ = 0.001;
        end
    end
elseif objective_id == 7 %Set this objective id higher than the others
        %to be used so that the dimensionality of the problem will not be
        %changed for other objectives from what you specify in "Control_Panel.m"
        %(due to this necessarily being a 2D function): Schaffer's f6
        %is purely a 2-D objective.
    objective = 'Schaffers_f6';
    dim = 2;
    if OnOff_asymmetric_initialization
        range_IS0 = 50; %asymmetric [50, 100]
        center_IS0 = 75; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*100; %[-100, 100]
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to its value.
    if OnOff_SuccessfulUnsuccessful
        if dim == 30
            thresh_for_succ = 100;
        elseif dim == 2
            thresh_for_succ = 0.001;
        end
    end
elseif objective_id == 8
    objective = 'Schwefel'; %Due to the quality of maxima and
        %minima both increasing with distance from the origin due to
        %degree of curvature increasing with that distance, the
        %unbounded Schwefel does not have a true global minimum.
        %To use this function, enable velocity reset or create a 
        %position clamping feature in order to restrict particles
        %to the original search space.
    if OnOff_asymmetric_initialization
        range_IS0 = 250; %asymmetric [250, 500]
        center_IS0 = 375; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*500; %[-500, 500]
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    if OnOff_SuccessfulUnsuccessful
        if dim == 30
            thresh_for_succ = 100;
        elseif dim == 2
            thresh_for_succ = 0.001;
        end
    end
elseif objective_id == 9
    objective = 'Spherical';
    if OnOff_asymmetric_initialization
        range_IS0 = 50; %asymmetric [50, 100] or [2.56, 5.12]
        %range_IS0 = 2.56;
        center_IS0 = 75;
        %center_IS0 = 3.84;
    else
        range_IS0 = 2*100; %[-100, 100] in Fundamentals of Computation Swarm Intelligence and
            %in general, but [-5.12, 5.12] in (i) "Opposition-based Particle Swarm Algorithm
            %with Cauchy Mutation," (ii) "A Particle Swarm Optimization with Stagnation
            %Detection and Dispersion," and (iii) http://www.geatbx.com/docu/fcnindex-01.html
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to a value appropriate for the selected dimensionality.
    if OnOff_SuccessfulUnsuccessful
        if dim == 30
            thresh_for_succ = 0.01;
        elseif dim ==2
            thresh_for_succ = 10^(-7);
        end
    end
elseif objective_id == 10
    objective = 'Weighted_Sphere';
    if OnOff_asymmetric_initialization
        range_IS0 = 2.56; %asymmetric [2.56, 5.12]
        center_IS0 = 3.84; %i.e. (lower bound + upper bound)/2
    else
        range_IS0 = 2*5.12; %[-5.12, 5.12]
        center_IS0 = 0; %Specify the initial center_IS of the search space (null vector
            %default for each particle).
    end
    % If switch "OnOff_SuccessfulUnsuccessful" is active, "thresh_for_succ"
        % is the threshold used to determine whether a trial is counted as
        % successful or not.  When switch "OnOff_Terminate_Upon_Success" is
        % also active, optimization will cease once the objective function is
        % minimized to a value appropriate for the selected dimensionality.
    if OnOff_SuccessfulUnsuccessful 
        if dim == 30
            thresh_for_succ = 0.01;
        elseif dim ==2
            thresh_for_succ = 10^(-7);
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This paragraph copyright  2010, 2011, 2012 Tricia Rambharose.
%   Created on: 2010/09/18
%   info@tricia-rambharose.com
%Neural Network training checks.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif objective_id == 11 %Only benchmark function used in NN training
    objective = 'NN';    
    if OnOff_asymmetric_initialization %search space and initialization space is different
        range_IS0 = 0.6; 
        center_IS0 = NN_wb';
    else %search space and initialization space is the same
        range_IS0 = 2*1; %[-1, 1]
        center_IS0 = 0; %Specify the initial center_ss of the search space (null vector
            %default for each particle).
    end
    if OnOff_SuccessfulUnsuccessful
        thresh_for_succ = 0; % If switches "OnOff_SuccessfulUnsuccessful" ...
    end %... and "OnOff_Terminate_Upon_Success" are both active, optimization...
end %...will cease once the objective function is minimized to this value.

ObjFun = str2func(['ObjFun_', objective]);
if OnOff_Tricias_NN_training %Check this first since "first_pso" only exists when NN_training is active.
    if ~first_pso %If it is not the first call to the PSO Research Toolbox
            %from Tricia's ANN training add-in."
        RegPSO_main
    else 
        Input_Validation
    end
else %user accepted terms and it is the first run of PSO for this NN    
    Input_Validation %After loading parameters into the
        %common workspace, validating inputs, and verifying that the
        %user agrees to the terms of the Toolbox Use Agreement,
        %begin execution of the program.
        %first_pso=1; %indicate that PSO was run
end