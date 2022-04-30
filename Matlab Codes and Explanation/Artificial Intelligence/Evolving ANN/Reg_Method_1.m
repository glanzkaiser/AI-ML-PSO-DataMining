%This code executes "Reg_Method_1_core.m" using the while headers
%appropriate to the settings specified by the user in "Control_Panel.m."


%Store the desired histories resulting from the first execution of the core
    %code prior to regrouping (also appended to within
    %"Reg_Method_1_regrouping.m" after each execution of the core code).
if ~OnOff_Autosave_Workspace_Per_Grouping
    if OnOff_fghist
        fghist_current_trial = [fghist_current_trial, fghist]; %store first "fghist"
    end
    if OnOff_ghist
        ghist_current_trial = [ghist_current_trial; ghist];
    end
    if OnOff_xhist
        xhist_current_trial = [xhist_current_trial, xhist];
    end
    if OnOff_vhist
        vhist_current_trial = [vhist_current_trial, vhist];
    end
    if OnOff_fphist
        fphist_current_trial = [fphist_current_trial, fphist];
    end
    if OnOff_phist
        phist_current_trial = [phist_current_trial, phist];
    end
    if OnOff_fhist
        fhist_current_trial = [fhist_current_trial, fhist];
    end
    if OnOff_lbest
        if OnOff_lhist
            lhist_current_trial = [lhist_current_trial, lhist];
        end
    end
end

%Continue regrouping until a specified termination criterion is met.
if OnOff_func_evals
    if OnOff_OPSO || OnOff_Cauchy_mutation_of_global_best
        OPSO_ghost_FEs_RegPSO = OPSO_ghost_FEs_RegPSO + OPSO_ghost_FEs_counter;
    end
    if OnOff_MPSO
        while ((1 + RegPSO_k)*np < max_FEs_over_all_groupings) && ... 
                (((1 + RegPSO_k)*np + OPSO_ghost_FEs_RegPSO + MPSO_FE_counter) < MPSO_max_FEs) && ...
                (fg ~= true_global_minimum)
            Reg_Method_1_regrouping
        end
    else %i.e. if ~OnOff_MPSO
        while ((1 + RegPSO_k)*np < max_FEs_over_all_groupings) && ... 
                (fg ~= true_global_minimum)
            Reg_Method_1_regrouping
        end
    end
else %i.e. if iterations are used instead of func eval's for termination criteria
    if OnOff_MPSO
        while (1 + RegPSO_k < max_iter_over_all_groupings) && ...
                (1 + RegPSO_k + MPSO_k < MPSO_max_iters) && ...
                (fg ~= true_global_minimum)
            Reg_Method_1_regrouping
        end
    else %i.e. ~OnOff_MPSO
        while (1 + RegPSO_k < max_iter_over_all_groupings) && ...
                (fg ~= true_global_minimum)
            Reg_Method_1_regrouping
        end
    end
end