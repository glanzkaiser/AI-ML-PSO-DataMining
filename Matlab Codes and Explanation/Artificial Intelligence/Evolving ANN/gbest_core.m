
% This file executes one instance of global best particle swarm optimization (Gbest PSO).
% Regrouping PSO (RegPSO) calls this code with each new grouping (i.e. it runs
    % standard Gbest PSO with the addition of an efficient regrouping mechanism).
% When a set of trials is to be conducted, RegPSO_main calls this code
    %repeatedly, after incrementing the default state of the randomizer by a large prime
    %number, then displays the resulting statistics in a table for the user.
%In the "TABLE PARAMETERS & SWITCHES" section of "Control_Panel.m," parameters can
    %be set to increment automatically after each set of trials so that the
    %table displayed will contain statistics for various parameter combinations.
%Other variables, such as the objective, can be set to increment per table so
    %that there is less repetition necessary on the part of the user.

%These are cleared to ensure that there is no unintentional continuance
    %of a previous value where none is expected, which is preferable to
    %using functions due in part to improved efficiency.
clear f fp fpbest GCPSO_index_of_best_particle
if Reg_Method ~= 1
    clear fg g
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Determine Function Values & Best Locations Initially%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gbest_initialization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This paragraph copyright 2010, 2011, 2012 Tricia Rambharose.
%   Created on: 2010/09/25
%   info@tricia-rambharose.com
%   Enter stopping conditions for NN training, given:
%   max_iter_per_grouping = max NN epochs
%   true_global_minimum = NN error goal
%   New max time stopping condition = NN time
%   PSO stagnation = NN max fail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if OnOff_Tricias_NN_training
    PSO_stag = 0; curr_fg = fg; %initializations for PSO stagnation check
    current_time = etime(clock,startTime);
    update_tr;
    while ((1 + k < max_iter_per_grouping) && ... % NN epochs 
           (fg > true_global_minimum) && ... % NN goal
           (current_time < net.trainParam.time) && ... % NN time
           (PSO_stag < max_fail)) % PSO stagnation
                gbest_core_loop
                PSO_stag_count
                current_time = etime(clock,startTime);
                update_tr;
    end

elseif OnOff_MPSO
    if Reg_Method == 1 %Regrouping Case: Use 3 Termination Criteria
        if OnOff_NormR_stag_det
            if OnOff_func_evals
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        ((1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter))*np + OPSO_ghost_FEs_counter + OPSO_ghost_FEs_RegPSO) < max_FEs_over_all_groupings && ...
                        ((1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter))*np + OPSO_ghost_FEs_counter + OPSO_ghost_FEs_RegPSO + MPSO_FE_counter) < MPSO_max_FEs && ...
                        max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) > stag_thresh && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            else %i.e. if iterations are to be used instead of function evaluations
                while 1 + k < max_iter_per_grouping && ...
                        1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter) < max_iter_over_all_groupings && ...
                        1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter) + MPSO_k < MPSO_max_iters && ...
                        max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) > stag_thresh && ...
                        fg ~= true_global_minimum 
                    gbest_core_loop
                end
            end
        else %(i.e. if ~OnOff_NormR_stag_det)
            if OnOff_func_evals
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        ((1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter))*np + OPSO_ghost_FEs_counter + OPSO_ghost_FEs_RegPSO) < max_FEs_over_all_groupings && ...
                        ((1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter))*np + OPSO_ghost_FEs_counter + OPSO_ghost_FEs_RegPSO + MPSO_FE_counter) < MPSO_max_FEs && ...
                        fg ~= true_global_minimum
                        %Note: "MPSO_FE_counter" has
                        %already accounted for "MPSO_k."
                    gbest_core_loop
                end
            else %i.e. if iterations are to be used instead of function evaluations
                while 1 + k < max_iter_per_grouping && ...
                        1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter) < max_iter_over_all_groupings && ...
                        1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter) + MPSO_k < MPSO_max_iters && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        end
    elseif Reg_Method == 2
        if OnOff_func_evals
            if OnOff_NormR_stag_det
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        ((1 + k)*np + OPSO_ghost_FEs_counter + OPSO_ghost_FEs_RegPSO + MPSO_FE_counter) < MPSO_max_FEs && ...
                        max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) > stag_thresh && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            else %(i.e. if OnOff_NormR_stag_det ~= 1)
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        ((1 + k)*np + OPSO_ghost_FEs_counter + OPSO_ghost_FEs_RegPSO + MPSO_FE_counter) < MPSO_max_FEs && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        else %i.e. if iterations are to be used instead of function evaluations
            if OnOff_NormR_stag_det
                while 1 + k < max_iter_per_grouping && ...
                        1 + k + MPSO_k < MPSO_max_iters && ...
                        max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) > stag_thresh && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            else %(i.e. if OnOff_NormR_stag_det ~= 1)
                while 1 + k < max_iter_per_grouping && ...
                        1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter) + MPSO_k < MPSO_max_iters && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        end
    elseif Reg_Method == 0 %Case: No Regrouping
        if OnOff_func_evals
            if OnOff_SuccessfulUnsuccessful
                if OnOff_Terminate_Upon_Success %variable only created in the control panel if OnOff_SuccessfulUnsuccessful to avoid workspace clutter
                    while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ... %until either max func eval is reached
                            ((1 + k)*np + OPSO_ghost_FEs_counter + MPSO_FE_counter) < MPSO_max_FEs && ...
                            fg > thresh_for_succ && ...
                            fg ~= true_global_minimum %or "thresh_for_succ" is reached
                        gbest_core_loop
                    end
                else %(i.e. if the search should continue rather than terminating once "thresh_for_succ"
                    %has been satisfied)
                    while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                            ((1 + k)*np + OPSO_ghost_FEs_counter + MPSO_FE_counter) < MPSO_max_FEs && ...
                            fg ~= true_global_minimum
                        gbest_core_loop
                    end
                end
            else %i.e. if ~OnOff_SuccessfulUnsuccessful
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        ((1 + k)*np + OPSO_ghost_FEs_counter + MPSO_FE_counter) < MPSO_max_FEs && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        else %i.e. if iterations are to be used instead of function evaluations
            if OnOff_SuccessfulUnsuccessful
                if OnOff_Terminate_Upon_Success
                    while 1 + k < max_iter_per_grouping && ...
                            1 + k + MPSO_k < MPSO_max_iters && ...
                            fg > thresh_for_succ && ...
                            fg ~= true_global_minimum
                        gbest_core_loop
                    end
                else %(i.e. if the search should continue rather than terminating once "thresh_for_succ"
                    %has been satisfied)
                    while 1 + k < max_iter_per_grouping && ...
                            1 + k + MPSO_k < MPSO_max_iters && ...
                            fg ~= true_global_minimum
                        gbest_core_loop
                    end
                end
            else
                while 1 + k < max_iter_per_grouping && ...
                        1 + k + MPSO_k < MPSO_max_iters && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        end
    end
else %i.e. if ~OnOff_MPSO
    if Reg_Method == 1 %Regrouping Case: Use 3 Termination Criteria
        if OnOff_NormR_stag_det
            if OnOff_func_evals
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        ((1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter))*np + OPSO_ghost_FEs_counter + OPSO_ghost_FEs_RegPSO) < max_FEs_over_all_groupings && ...
                        max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) > stag_thresh && ...
                        fg ~= true_global_minimum 
                    gbest_core_loop
                end
            else %i.e. if iterations are to be used instead of function evaluations
                while 1 + k < max_iter_per_grouping && ...
                        1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter) < max_iter_over_all_groupings && ...
                        max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) > stag_thresh && ...
                        fg ~= true_global_minimum 
                    gbest_core_loop
                end
            end
        else %(i.e. if ~OnOff_NormR_stag_det)
            if OnOff_func_evals
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        ((1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter))*np + OPSO_ghost_FEs_counter + OPSO_ghost_FEs_RegPSO) < max_FEs_over_all_groupings && ...
                        fg ~= true_global_minimum 
                    gbest_core_loop
                end
            else %i.e. if iterations are to be used instead of function evaluations
                while 1 + k < max_iter_per_grouping && ...
                        1 + k + RegPSO_k + mod(1, RegPSO_grouping_counter) < max_iter_over_all_groupings && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        end
    elseif Reg_Method == 2
        if OnOff_func_evals
            if OnOff_NormR_stag_det
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) > stag_thresh && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            else %(i.e. if OnOff_NormR_stag_det ~= 1)
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        else %i.e. if iterations are to be used instead of function evaluations
            if OnOff_NormR_stag_det
                while 1 + k < max_iter_per_grouping && ...
                        max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) > stag_thresh && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            else %(i.e. if OnOff_NormR_stag_det ~= 1)
                while 1 + k < max_iter_per_grouping && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        end
    elseif Reg_Method == 0 %Case: No Regrouping
        if OnOff_func_evals
            if OnOff_SuccessfulUnsuccessful
                if OnOff_Terminate_Upon_Success
                    while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ... %until either max func eval is reached
                            fg > thresh_for_succ && ...
                            fg ~= true_global_minimum %or "thresh_for_succ" is reached
                        gbest_core_loop
                    end
                else %(i.e. if the search should continue rather than terminating once "thresh_for_succ"
                    %has been satisfied)
                    while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                            fg ~= true_global_minimum
                        gbest_core_loop
                    end
                end
            else
                while ((1 + k)*np + OPSO_ghost_FEs_counter) < max_FEs_per_grouping && ...
                        fg ~= true_global_minimum
                    gbest_core_loop
                end
            end
        else %i.e. if iterations are to be used instead of function evaluations
            if OnOff_SuccessfulUnsuccessful
                if OnOff_Terminate_Upon_Success
                    while (1 + k < max_iter_per_grouping) && ...
                            (fg > thresh_for_succ) && ...
                            (fg ~= true_global_minimum)
                        gbest_core_loop
                    end
                else %(i.e. if the search should continue rather than terminating once "thresh_for_succ"
                    %has been satisfied)
                    while (1 + k < max_iter_per_grouping) && ...
                            (fg ~= true_global_minimum)
                        gbest_core_loop
                    end
                end
            else
                while (1 + k < max_iter_per_grouping) && ...
                        (fg ~= true_global_minimum)
                    gbest_core_loop
                end
            end
        end
    end
end