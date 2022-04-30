% This code is called within "RegPSO_main" each time a new trial begins in
% order to initialize the corresponding program variables.


%Clear all trial variables that could potentially be problematic.
clear g fg x v vmax k Internal_i Internal_j
clear RegPSO_range_IS_per_grouping RegPSO_k k_Reg2_hist OPSO_ghost_FEs_RegPSO
clear RegPSO_grouping_counter RegPSO_k_after_each_grouping RegPSO_g_after_each_grouping RegPSO_fg_after_each_grouping
clear MPSO_range_IS_per_grouping MPSO_fg_after_each_grouping MPSO_g_after_each_grouping
clear MPSO_k_after_each_grouping MPSO_z MPSO_fz MPSO_zhist
clear MPSO_grouping_counter MPSO_restart_counter MPSO_FE_counter
clear MPSO_k_after_each_start MPSO_grouping_count_after_each_start
if Reg_Method ~= 0 || OnOff_MPSO %(History of current trial over all groupings)
    if OnOff_fghist
       fghist_current_trial = []; % Stores each iteration's "fg" over all regroupings by continually appending fghist. Is equivalent to "fghist" when no regrouping takes place.
    end
    if OnOff_ghist
        ghist_current_trial = [];
    end
    if OnOff_xhist
        xhist_current_trial = [];
    end
    if OnOff_vhist
        vhist_current_trial = [];
    end
    if OnOff_fphist
        fphist_current_trial = [];
    end
    if OnOff_phist
        phist_current_trial = [];
    end
    if OnOff_fhist
        fhist_current_trial = [];
    end
    if OnOff_lbest
        if OnOff_lhist
            lhist_current_trial = [];
        end
    end
end
if OnOff_Autosave_Workspace_Per_Grouping
   Internal_date_string_array = [];  %These are used to regenerate the data stored within
   fg_array = [];          %the descriptive filenames of each trial's worskpace.
end
if Reg_Method ~= 0 || OnOff_SuccessfulUnsuccessful
    RegPSO_k = 0; %Initialize "RegPSO_k," which counts the # of iterations
        %per RegPSO trial and constitutes one termination criterion within
        %"gbest_core" or "lbest_core."
end
if Reg_Method ~= 0
    if (OnOff_g_after_each_grouping && (OnOff_MPSO || ~OnOff_Autosave_Workspace_Per_Grouping)) || OnOff_num_gs_identical_b4_refinement
        RegPSO_g_after_each_grouping = [];
            % "RegPSO_g_after_each_grouping" is used to determine when to begin decreasing the regrouping factor
            % and requires the past 50 global bests to be maintained within each trial rather than simply
            % being reconstructed as is the other grouping data after all groupings have occurred.
            % "OnOff_num_gs_identical_b4_refinement == 1" can therefore be expected to slow program
            % execution a bit. 
        if OnOff_g_after_each_grouping && OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping)
            %If "OnOff_Autosave_Workspace_Per_Grouping,"
            %"MPSO_g_after_each_grouping" will more efficiently be
            %reconstructed within "RegPSO_load_grouping_data.m," which loads
            %the desired data from the workspace saved at the end of each
            %grouping.
            MPSO_g_after_each_grouping = [];
        end
    end
    if OnOff_num_gs_identical_b4_refinement || (OnOff_g_after_each_grouping && (OnOff_MPSO || ~OnOff_Autosave_Workspace_Per_Grouping))
        if OnOff_Autosave_Workspace_Per_Grouping
            reg_fact_array = []; %used to load files since "reg_fact" can change over groupings.
        end
        if (Internal_i_columns > 0) && (OnOff_num_gs_identical_b4_refinement)
            reg_fact = Internal_reg_fact0_curr_column; %Ensure that each
                %trial uses that same initial value over the
                %set of trials (i.e. "column").
        end
    end
    if OnOff_range_IS_per_grouping && (OnOff_MPSO || OnOff_see_data_per_grouping || ~OnOff_Autosave_Workspace_Per_Grouping)
            %If the user does not wish to see the data per grouping and ~OnOff_MPSO,
                %this can be generated more efficiently from the saved
                %WS of the groupings.  In the case of MPSO, it may
                %be beneficial to still generate this.
        RegPSO_range_IS_per_grouping = []; %Store the initial range_IS...
        if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping) %otherwise, this history...
            %will more efficiently be constructed within...
            %"RegPSO_load_grouping_data.m" rather than needing to be...
            %initialized here.
            MPSO_range_IS_per_grouping = [];
        end
    end
    if OnOff_MPSO || ~OnOff_Autosave_Workspace_Per_Grouping
        if OnOff_fg_after_each_grouping
            if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping)
                MPSO_fg_after_each_grouping = [];
            end
            RegPSO_fg_after_each_grouping = [];
        end
        if OnOff_k_after_each_grouping
            RegPSO_k_after_each_grouping = []; %This is done only to prevent termination should
                %"Load_trial_data_for_stats" try
                %to access "RegPSO_k_after_each_grouping" where it does not exist
                %due to regrouping not having occurred on at least
                %one trial in the set (or some other reason that
                %might have caused "??? Reference to non-existent field 'RegPSO_k_after_each_grouping'.
                %Error in ==> Load_trial_data_for_stats
                %at 2287"
            if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping) %otherwise, this history...
                    %will more efficiently be constructed within...
                    %"RegPSO_load_grouping_data.m" rather than needing to be...
                    %initialized here.
                MPSO_k_after_each_grouping = []; %"RegPSO_k_after_each_grouping" is horizontally
                    %appended to this after each restart of MPSO, which is
                    %allowed in this toolbox to use a core algorithm other
                    %than GCPSO.
            end
        end
    end
end
Rand_seq_start_point = (Internal_k_trials)*104729; %Increment the default
    %state of the randomizer by prime number 104729 with each new trial.
rand('twister', Rand_seq_start_point); %I now know the location in the
    %random # sequence where each trial begins.

Internal_k_trials = Internal_k_trials + 1;
if OnOff_SuccessfulUnsuccessful %"OnOff_iter_success" is only defined in this case.
    if OnOff_iter_success
        iter_success_switch = false; %success has not yet occurred (a condition for...
    end %entering "if" statement to record the iteration # at which success occurred)
end %entering "if" statement to record iteration # at which success occurred)
center_IS = repmat(center_IS0.*ones(1, dim), np, 1); % The center of the
    %search space is converted from the original "center_IS0" input as
    %either a scalar or vector for convenience to the matrix, "center_IS"
    %expected by the program.
    %"center_IS" is expected to change with each regrouping of RegPSO since
    %the new search space within which the swarm regroups is centered about
    %the global best at stagnation.
range_IS = repmat(range_IS0.*ones(1, dim), np, 1);% The range of the
    %search space is converted from the original "range_IS0" input as
    %either a scalar or vector for convenience to the matrix, "rage_IS"
    %expected by the program.
    %"range_IS" is expected to change with each regrouping of RegPSO since
    %the maximum deviation from global best on each dimension is multiplied
    %by the regrouping factor and clamped to a maximum of the original
    %range in order to determine an efficient range within which to
    %regroup.
MPSO_k = 0; %counts the number of iterations over all MPSO starts
    %used for histories even when MPSO is inactive: will remain zero if
    %~OnOff_MPSO so that it does not affect sums to which it would
    %otherwise contribute (i.e. without having to write a separate sum for
    %each case).
if OnOff_MPSO %Initialize MPSO program variables.
    MPSO_k_after_each_start = []; %will use MPSO_k to store the iteration #'s at
        %which restarts take place
    MPSO_start_counter = 0; %counts the # of MPSO restarts
    if OnOff_func_evals %if function evaluations are monitored instead of iterations
        MPSO_FE_counter = 0; %counts the # of function
            %evaluations across all MPSO starts
    end
    if Reg_Method == 1
        MPSO_grouping_counter = 0; %Counts the number of RegPSO groupings
            %over all MPSO starts: the counter is initialized to 0 and incremented
            %with each grouping (i.e. once within MPSO.m for the
            %initial grouping done by "Reg_Methods_0And1.m" and repeatedly
            %within "Reg_Method_1.m" with each additional grouping
        MPSO_grouping_count_after_each_start = []; %Stores the grouping #'s at which
            %MPSO restarts occur.
    end
end