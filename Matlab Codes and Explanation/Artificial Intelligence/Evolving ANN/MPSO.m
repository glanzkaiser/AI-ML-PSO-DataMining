
%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize with Each Start (Separate from Trial Initializations%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Histories are not re-initialized, but maintained over
    %the full MPSO trial.  However, some other parameters
    %initialized within "Trial_Initializations" need to be
    %re-initialized to accomodate the restart's re-initialization.
RegPSO_k = 0; %To allow RegPSO to be used instead of GCPSO
    %with each restart in order to allow more flexibility for the purpose
    %of research, RegPSO_k must be re-initialized (it is also
    %used for other cases - all of which require a re-initialization).
MPSO_start_counter = MPSO_start_counter + 1; %Counts the number of MPSO
    %starts implemented.  This is initialized to 0 in
    %Trial_Initializations.m and incremented here to reflect the index
    %of the start underway.
if Reg_Method ~= 0
    if OnOff_g_after_each_grouping
        RegPSO_g_after_each_grouping = [];
    end
    if OnOff_fg_after_each_grouping
        RegPSO_fg_after_each_grouping = [];
    end
    if OnOff_k_after_each_grouping
            %Reset to ensure that no values carry over...
        RegPSO_k_after_each_grouping = []; %... from one MPSO start to the next should...
    end %...the latter consist of less groupings.
    if OnOff_range_IS_per_grouping
        RegPSO_range_IS_per_grouping = [];
    end
    if (Internal_i_columns > 0) && (OnOff_num_gs_identical_b4_refinement)
        reg_fact = Internal_reg_fact0_curr_column; %Ensure that each
            %restart within an MPSO trial begins with the same regrouing
            %factor.  The initial regrouping factor will only change when
            %the regouping factor is incremented between columns.
    end
end
range_IS = repmat(range_IS0.*ones(1, dim), np, 1); %Set the initial range_IS to be that specified by the user.
    %"range_IS" is expected to change with each regrouping.
center_IS = center_IS0; %In case RegPSO had executed, restore the original
    %center_IS of the search space rather than center_ISing about global best.
Rand_seq_start_point = (Internal_k_trials)*104729 + MPSO_start_counter*7919; %Increment the default
    %state of the randomizer with each start of MPSO within a trial in order
    %to be able to replicate the results of each individual start.
rand('twister', Rand_seq_start_point); %This sets the randomizer to begin
    %the trial at "Rand_seq_start_point," which is incremented by prime
    %number 104729 with each new trial.
    %Note: For early versions of MATLAB, use
    %"rand('twister', Rand_seq_start_point);"

if MPSO_start_counter > 1    
    MPSO_k = MPSO_k + 1; %counts the initialization of each restart: compensates for iteration 0
end

%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Execute Regrouping Method 0, 1, or 2%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Reg_Method ~= 2
    Reg_Methods_0And1
else %(i.e. if Reg_Method == 2)
    Reg_Method_2
end
%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RegPSO: Regroup When standard PSO Converges Prematurely (if activated by setting Reg_Method == 1).%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Reg_Method == 1
    Reg_Method_1
end

%$%%%%%%%%%%%%%%%%%%
%Increment Counters%
%%%%%%%%%%%%%%%%%%%%
if Reg_Method == 0
    MPSO_k = MPSO_k + k; %Initialization is repeated iteratively as well as the usual iterations
else %i.e. Regrouping case
    MPSO_k = MPSO_k + RegPSO_k; %Record the total number of iterations
        %performed by each restart.
    MPSO_grouping_count_after_each_start = [MPSO_grouping_count_after_each_start, MPSO_grouping_counter];
        %Store the grouping number at the end of each start.
end
MPSO_k_after_each_start = [MPSO_k_after_each_start, MPSO_k];

%$%%%%%%%%%%%%
%MPSO Updates%
%%%%%%%%%%%%%%
if MPSO_start_counter == 1
    MPSO_z = g(1, :); %Store the global best and its function value to...
    MPSO_fz = fg;     %... "MPSO_z" and "MPSO_fz" respectively.
    if OnOff_MPSO_zhist
        MPSO_zhist = MPSO_z;
    end
else %restart rinstead of original start (previous values exist and can be used for comparison)
    if fg < MPSO_fz %Update "MPSO_z" and its function value only if the
            %restart improved the quality of the solution.
        MPSO_z = g(1, :);
        MPSO_fz = fg;
        if OnOff_MPSO_zhist
            MPSO_zhist = [MPSO_zhist; MPSO_z];
        end
    end
end
if OnOff_func_evals %if function evaluations are monitored instead of iterations
    if Reg_Method == 0
        MPSO_FE_counter = MPSO_FE_counter + (k + 1)*np + OPSO_ghost_FEs_counter; %use "k" to determine # of FE's
    else
        MPSO_FE_counter = MPSO_FE_counter + (RegPSO_k + 1)*np + OPSO_ghost_FEs_RegPSO; %use "RegPSO_k" to determine # of FE's
    end
end

if ~OnOff_Autosave_Workspace_Per_Grouping || ~OnOff_RegPSO
    %If RegPSO is active, these histories are updated after each grouping.
    %They are updated here in case MPSO is active but RegPSO is not.
    %In either case, the history over the entire trial should be
    %maintained; but when both are active, values should not be stored
    %to the history twice, which is why check if ~OnOff_RegPSO is done
    %here.
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