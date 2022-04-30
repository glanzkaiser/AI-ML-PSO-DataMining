
% (0) Right-click "Open_Files.m" and select "Run."
% (1) Set parameters within "Params."
% (2) Press "F5" within that file to begin execution.
% At the end of "Params," this file is called which then calls 
    %"gbest_core" or "lbest_core" and graphing codes "Graphs" &
    %"Swarm_Trajectory" as needed.  "RegPSO_main" also calls
    %"Save_data_per_trial.m" in order to save the data of each trial
    %then clear it from memory before calling
    %"Load_trial_data_for_stats.m" to reconstruct the data necessary
    %for the specified analyses.

%%%%%%%%%%%%%%%%%
%Initializations%
%%%%%%%%%%%%%%%%%
%For the parameter to be incremented per column, store initial value so it
%can be restored with each new table generated.
if Reg_Method == 1
    reg_fact0 = reg_fact; %Used to restore to original value when starting a new
end %table (each table has a set of trials over unique parameters in each column).
if OnOff_progress_meter
    Internal_now_init = now; %Record the time before any data is generated.
    Internal_now_last = 0; %Time of previous store is set to zero to satisfy the requirement of at least 60 seconds since the
        %previous estimation in order to generate a new estimation.
end
if OnOff_w_linear %If inertia weight is linearly varying
    w_diff = w_i - w_f; %Calculate the difference once rather than iteratively.
end
Internal_unique_table_counter = 0; %counts # of tables until a maximum of user-defined "TableParams_num_tables" is reached.
if OnOff_v_cog_hist
    v_cog_hist = [];
end
if OnOff_v_soc_hist
    v_soc_hist = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Graph Objective Before Data Generation%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if OnOff_graphs
    if OnOff_graph_ObjFun_f_vs_2D
        Graph_Objective
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Begin Table Loop: One Column is a Set of Trials on Unique Parameters%
%(Tables Allow Performance Evaluation of Many Parameter Combinations)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while Internal_unique_table_counter < TableParams_num_tables
    if OnOff_v_reset || OnOff_position_clamping
        if ((sum(size(center_IS0)) > 2) || sum((size(range_IS0) > 2)))
            %i.e. if different search space per dimension defined in
            %Objectives.m rather than the same search space per dimension
            %as usual.  This will only apply to some real-world application
            %problems - e.g. if one dimension of an ANN to be optimized is
            %the number of nodes in the hidden layer while the other
            %dimensions are the weights, the first dimension could have a
            %different  range and center than the other dimensions, which
            %would require the range and center of the search space to be
            %input as vectors rather than scalars.  See the product
            %documentation for more info on this.
            xmax = repmat((center_IS0 + range_IS0./2), np, 1);
            if OnOff_asymmetric_initialization
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Neural Network training check
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if OnOff_Tricias_NN_training %if NN being trained then the search space range is [-1, 1]***********
                    xmax = 1;
                end
                
                xmin = -xmax; %For asymmetric initialization,
                    %set "xmin" to be the left of the search space rather
                    %than the left of the initialiazation space since in
                    %this case they are different.  In this case, "xmin"
                    %should always be the negative of xmax, which for
                    %real-world application problems might not always be
                    %the case: e.g. optimizing length, width, or height
                    %would not make use of negative numbers, and xmin would
                    %be zero rather than the negative of xmax.
            else %i.e. if ~OnOff_asymmetric_initialization
                xmin = repmat((center_IS0 - range_IS0./2), np, 1);
                    %Otherwise, calculate "xmin."
            end
        else %i.e. search space has same range & center per dimension as usual
            xmax = center_IS0 + range_IS0./2; %Calculate once and for all
            if OnOff_asymmetric_initialization
                xmin = -xmax; %For asymmetric initialization,
                    %set "xmin" to be the left of the search space rather
                    %than the left of the initialiazation space since in
                    %this case they are different.  In this case, "xmin"
                    %should always be the negative of xmax, which for
                    %real-world application problems might not always be
                    %the case: e.g. optimizing length, width, or height
                    %would not make use of negative numbers, and xmin would
                    %be zero rather than the negative of xmax.
            else %i.e. if ~OnOff_asymmetric_initialization
                xmin = center_IS0 - range_IS0./2;
                    %Otherwise, calculate "xmin."
            end
        end
    end
    if OnOff_Cauchy_mutation_of_global_best
        xmax_row = center_IS0(1, :) + range_IS0(1, :)./2; %Calculate once and for all
        xmin_row = center_IS0(1, :) - range_IS0(1, :)./2; %rather than iteratively.
    end
    if Internal_unique_table_counter > 0
        if TableParams_OnOff_c1_increment
            c1 = c1 + TableParams_c1_increment; %Increment "c1" and "c2" with each new table.
        elseif TableParams_OnOff_c2_increment
            c2 = c2 + TableParams_c2_increment;
        end
    end
    Internal_unique_table_counter = Internal_unique_table_counter + 1;
    %Clear all table variables that could be problematic.
    clear curr_table table_string fg_final_per_trial x g p v
    clear fg_max fg_mean fg_median fg_min fg_std fghist fghist_mean
    clear f fhist fg fghist fghist_mean fhist fp fphist
    clear xhist vhist ghist lhist phist v_cog_hist v_soc_hist
    clear k iter_mean_per_trial iter_success iter_success_sum iter_success_mean iter_success_switch
    clear num_trials_successful num_trials_unsuccessful
    clear t_per_trial_mean time_elapsed
    
    Internal_i_columns = 0; %This is reduced by 1 when further column generation looks promising.
    Internal_unique_column_counter = 0; %This is not reduced by 1 like "Internal_i_columns" and is an accurate column counter.
    while Internal_i_columns < TableParams_min_num_unique_columns %column loop condition
        
        %Option to increment one variable per column
        if Internal_i_columns > 0 %Only if the first column has already been generated
            if (OnOff_w_linear == 0) && (TableParams_OnOff_Col_Incr_w)
                    %(i.e. inertia weight is static and w is in fact the parameter to be incremented.
                w = w + TableParams_Col_Incr_w; %Increase or decrease w by 0.01 with each new trial.
            elseif TableParams_OnOff_Col_Incr_reg_fact
                if TableParams_OnOff_reg_fact_leftward_only == 0 %(i.e. generation rightward only or to both sides should be possible)
                    if OnOff_num_gs_identical_b4_refinement %if "reg_fact" may itself be reduced during a trial
                        reg_fact = Internal_reg_fact0_curr_column + TableParams_Col_Incr_reg_fact; %Increment "reg_fact" per column.
                    else reg_fact = reg_fact + TableParams_Col_Incr_reg_fact;
                    end
                else %(i.e. TableParams_OnOff_reg_fact_leftward_only)
                    if OnOff_num_gs_identical_b4_refinement %if "reg_fact" may itself be reduced during a trial
                        reg_fact = Internal_reg_fact0_curr_column - TableParams_Col_Incr_reg_fact; %Increment "reg_fact" per column.
                    else reg_fact = reg_fact - TableParams_Col_Incr_reg_fact;
                    end
                end
            elseif TableParams_OnOff_Col_Mult_reg_fact
                if OnOff_num_gs_identical_b4_refinement %if "reg_fact" may itself be reduced during a trial
                    reg_fact = TableParams_Col_Mult_reg_fact*Internal_reg_fact0_curr_column; %Scale "reg_fact" per column.
                else reg_fact = TableParams_Col_Mult_reg_fact*reg_fact;
                end
            elseif TableParams_OnOff_Col_Incr_np
                if np == 2
                    np = TableParams_Col_Incr_np;
                else 
                    np = np + TableParams_Col_Incr_np;
                end         %initially np = 2.
            elseif TableParams_OnOff_Col_Incr_vmax_perc
                vmax_perc = vmax_perc + TableParams_Col_Incr_vmax_perc;
            end
        end
        
        %Store "reg_fact" used in each trial of current column, regardless of
        %whether it is incremented or not.  If it was reduced during the
        %previoustrial, the initial value should be restored later in the code.
        if Reg_Method ~= 0
            if OnOff_num_gs_identical_b4_refinement
                Internal_reg_fact0_curr_column = reg_fact; %Stored here after possible column
                    %update (at beginning of column loop), restored after each trial
                    %but before table code.
            end
        end
        
        Internal_i_columns = Internal_i_columns + 1;
        Internal_unique_column_counter = Internal_unique_column_counter + 1;
        
        clear fg_median fg_mean fg_min fg_max fg_std
        clear fghist_mean iter_mean_per_trial t_per_trial_mean time_elapsed %Clear all column variables that could potentially be problematic.

        %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Initialize "RegPSO_main" Variables%  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tic; %Initialize stopwatch to record the passage of real time -- a useful measure in the real world.
        %(removed for now) tcpu_RegPSO = cputime; %Record current CPU time in order to find elapsed time later.
        %(removed for now) tcpu_tot = 0; %cpu time counter
        if num_trials > 1
            fg_final_per_trial = []; %"fg_final_per_trial" holds each RegPSO trial's final "fg."
                %It has become a necessary parameter, except when there is only one trial,
                %since it is used to recall the trials' filenames needed to reconstruct
                %fghist_over_all_trials when it is generated and is the substitute
                %when it is not generated.
        end
        if OnOff_SuccessfulUnsuccessful %Prevents workspace clutter by adding the following parameters only if they are to be used.
            num_trials_successful = 0; %Initializes the number of successful trials to 0.
            num_trials_unsuccessful = 0; %Initializes the number of unsuccessful trials to 0.
        end
        Internal_k_trials = 0; %RegPSO trial counter
        iter_tot_all_trials = 0; %used to calculate "iter_mean_per_trial"
        if OnOff_SuccessfulUnsuccessful %"OnOff_iter_success" is only defined in this case.
            if OnOff_iter_success
                iter_success = NaN*ones(1, num_trials); %Each trial is initialized as
                	%a failure until proving successful.
            end
        end   
        if OnOff_Autosave_Workspace_Per_Trial
            Internal_date_string_array_tr = [];
            Rand_seq_start_point_array_tr = [];
            reg_fact_array_tr = [];
        end
    
        while Internal_k_trials < num_trials
            %$%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Initialize Trial Variables%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Trial_Initializations
            
            if OnOff_MPSO %If multi-start is active, which is usually the case.
                if OnOff_func_evals
                    while (MPSO_start_counter < MPSO_max_starts)...
                            && (MPSO_FE_counter < MPSO_max_FEs)
                        MPSO
                    end
                else %i.e. if using iterations instead of func. eval's
                    while (MPSO_start_counter < MPSO_max_starts)...
                            && (1 + MPSO_k < MPSO_max_iters)
                        MPSO
                    end
                end
            else %i.e. if multi-start of the core algorithm is inactive
                %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Select Regrouping Method 0, 1, or 2%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if Reg_Method ~= 2
                    Reg_Methods_0And1
                else %(i.e. if Reg_Method == 2)
                    Reg_Method_2
                end

                %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %RegPSO: Method 1 (optional after standard PSO, whereas method 2 is instead of standard PSO) %
                %Regroup When Standard PSO Converges Prematurely (if activated).                             %
                %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if Reg_Method == 1
                    Reg_Method_1
                end
            end
            
            %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Record Regrouping Factor if Varied Within Trial%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if Reg_Method ~= 0
                if OnOff_num_gs_identical_b4_refinement
                    reg_fact_trial_finals(1, Internal_k_trials) = reg_fact; %Store trial's final
                        %"reg_fact" to be saved in workspace.
                    reg_fact = Internal_reg_fact0_curr_column; %Restore to value that was in use before
                        %the "reg_fact = reg_fact/reg_reduction_factor" was possibly implemented.
                end
            end
            %(still inside single trial loop)

            %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Final Function Values Per Trial%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if Reg_Method ~= 2
                if num_trials ~= 1
                    fg_final_per_trial = [fg_final_per_trial, fg]; %Keep a running total of all trials' "fg"
                        %behavior in order to graph "fg_mean" vs the maximum # of iterations in one trial (maximum because
                        %vectors must be the same length in order to average them).
                        %Each row represents one trial.  Columns represent iteration numbers.  Each initial iteration
                        %(0 at first) corresponds to random initialization.
                end
            end

            %$%%%%%%%%%%%%%%%%%%%%%%
            %Save Each Trial's Data%
            %%%%%%%%%%%%%%%%%%%%%%%%
            if (Reg_Method ~= 0) && OnOff_Autosave_Workspace_Per_Grouping
                RegPSO_load_grouping_data % Reconstruct trial's data from...
            end % that of each grouping.
            if OnOff_Autosave_Workspace_Per_Trial
                Save_data_per_trial
            end
            
            %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Output per Trial (still within trial loop)%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if Reg_Method ~= 2
                % Display the results of each trial except when (i)
                    % table(s) are displayed instead or (ii) there is only one
                    % trial, in which case display of this data would be
                    % redundant with the final output.
                if num_trials > 1
                    disp(['fg = ', num2str(fg)])
                    if Reg_Method == 0
                        disp(['k = ', num2str(k)])
                        if (~OnOff_lbest) || (OnOff_RegPSO) || (OnOff_ghist)
                            disp(['Rounded Global Best: [', num2str(round(g(1, :))), ']'])
                        end
                        if OnOff_MPSO
                            disp(['MPSO_k = ', num2str(MPSO_k)])
                            if OnOff_func_evals
                                disp(['# of Func. Eval''s = ', num2str(MPSO_FE_counter)])
                            else %i.e. if iterations are to be used instead of function evaluations
                                disp(['# of Iterations = ', num2str(MPSO_k)])
                            end
                        else %i.e. if ~OnOff_MPSO
                            if OnOff_func_evals
                                disp(['# of Func. Eval''s = ', num2str((1 + k)*np + OPSO_ghost_FEs_counter)])
                            else %i.e. if iterations are to be used instead of function evaluations
                                disp(['# of Iterations = ', num2str(1 + k)])
                            end
                        end
                    else %(i.e. Reg_Method == 1)
                        disp(['RegPSO_k = ', num2str(RegPSO_k)])
                        if OnOff_MPSO
                            disp(['MPSO_k = ', num2str(MPSO_k)])
                            if OnOff_func_evals
                                disp(['# of Func. Eval''s = ', num2str(MPSO_FE_counter)])
                            else %i.e. if iterations are to be used instead of function evaluations
                                disp(['# of Iterations = ', num2str(1 + MPSO_k)])
                            end
                        else %i.e. if ~OnOff_MPSO
                            if OnOff_func_evals
                                disp(['# of Func. Eval''s = ', num2str((1 + RegPSO_k)*np + OPSO_ghost_FEs_RegPSO)])
                                    %In this case, "RegPSO_k" includes
                                    %initializations.
                            else %i.e. if iterations are to be used instead of function evaluations
                                disp(['# of Iterations = ', num2str(1 + RegPSO_k)])
                                    %In this case, "RegPSO_k" does not include
                                    %initializations.
                            end
                        end
                        disp(['g = ', num2str(g(1, :))])
                        disp(['range_IS = ', num2str(range_IS(1, :))])
                        if OnOff_k_after_each_grouping
                            if OnOff_MPSO
                                    disp(['MPSO_k_after_each_grouping	 = ', num2str(MPSO_k_after_each_grouping)])
                            else
                                    disp(['RegPSO_k_after_each_grouping = ', num2str(RegPSO_k_after_each_grouping)])
                            end
                        end
                        if OnOff_fg_after_each_grouping
                            if OnOff_MPSO
                                disp(['MPSO_fg_after_each_grouping = ', num2str(MPSO_fg_after_each_grouping)])
                            else
                                disp(['RegPSO_fg_after_each_grouping = ', num2str(RegPSO_fg_after_each_grouping)])
                            end
                        end
                        disp(['Trial #: ', num2str(Internal_k_trials)])
                        %if OnOff_g_after_each_grouping
                        %    disp('RegPSO_g_after_each_grouping = ')
                        %num2str(RegPSO_g_after_each_grouping);
                        %end
                    end
                    fprintf('\r')%Insert carriage return.
                end
                if OnOff_SuccessfulUnsuccessful %Success/Unsuccess for Reg_Method 2 is checked within that loop.
                    if fg <= thresh_for_succ
                        %Determine whether or not the trial was successful,
                        %and increment the appropriate tracker.
                        num_trials_successful = num_trials_successful + 1;
                    else
                        num_trials_unsuccessful = num_trials_unsuccessful + 1;
                    end
                end
            end
    
            %$%%%%%%%%%%%%%%%%%%%%%%%
            %Optional Progress Meter%
            %%%%%%%%%%%%%%%%%%%%%%%%%
            if OnOff_progress_meter %Display: (1) progress as a percent,
                    %and (2) estimated time of completion based on the
                    %percent of trials completed and the amount of time used.
                if Internal_k_trials < num_trials && 10^5*(now - Internal_now_last) > 60
                        %i.e. if another trial remains & 1 minute has passed
                            %since the previous estimation.
                    fprintf('\r')
                    Internal_now_last = now;
                    disp([' Estimated Time of Completion: ', datestr(Internal_now_init + num_trials*(Internal_now_last - Internal_now_init)/Internal_k_trials),...
                        ' (', num2str(Internal_k_trials/num_trials*100), '% Complete)'])
                %else (removed for now w line below)
                    %(removed: used for testing) disp(['Time of Completion: ', datestr(now)]) %Displays exact time of completion.
                    fprintf('\r') %Insert a carriage return before future outputs.
                end
            end
            if OnOff_graphs
                if OnOff_swarm_trajectory && (Internal_k_trials ~= num_trials)
                    % When swarm trajectory maps are being generated, this
                        % closes all open figures before proceeding to the next
                        % trial in order to use RAM more efficiently and
                        % prevent figure numbers from conflicting, which
                        % previously caused 
                    close all
                end
            end
        end
        
        %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Option to Automatically Load Each Trial's Workspace for Graphing, Analysis%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %All "if" checks retained from case above to ensure that each filename can be read and to allow
            %for future extraction of other data such that it is known exactly what data is held in each
            %potential workspace.
        if (num_trials > 1) && OnOff_Autosave_Workspace_Per_Trial
            %Reconstruct data from individual trials if OnOff_fghist, OnOff_k_after_each_grouping, 
                %OnOff_fg_after_each_grouping, or OnOff_g_after_each_grouping are activated.  The
                %latter three parameters only exist in the regrouping case.
            if OnOff_Autosave_Workspace_Per_Column %If the column data is to be saved,
                %in which case reconstruct since any parameter might
                %possibly be of interest.
                Load_trial_data_for_stats
            elseif OnOff_fghist %Otherwise, reconstruct if "fghist" is needed...
                Load_trial_data_for_stats
            elseif Reg_Method ~= 0 %or if any of the regrouping parameters below are needed.
                if OnOff_k_after_each_grouping || OnOff_fg_after_each_grouping || OnOff_g_after_each_grouping
                    Load_trial_data_for_stats
                end
            end
        end
    
        %$%%%%%%%%%%%%%%%%%%%%
        %Evaluate Performance%
        %%%%%%%%%%%%%%%%%%%%%%
        time_elapsed = toc;
        if num_trials > 1
            if (OnOff_SuccessfulUnsuccessful)
                if ~OnOff_iter_success
                    fprintf('\r')
                end
            end
            %(removed for now) tcpu_reg_elapsed = cputime - tcpu_RegPSO; %Find the elapsed cputime.
            %(removed for now) tcpu_per_trial_mean = tcpu_reg_elapsed/num_trials;
            %(removed for now) tcpu_mean = tcpu_tot/num_trials
            %TIME
            t_per_trial_mean = time_elapsed/num_trials;
            iter_mean_per_trial = iter_tot_all_trials/num_trials;
            %SUCCESSES
            if OnOff_SuccessfulUnsuccessful
                iter_success_sum = 0; %Initialize sum of iteration #'s required for success.
                for Internal_i = 1:num_trials
                    if isfinite(iter_success(Internal_i))
                        iter_success_sum = iter_success_sum + iter_success(Internal_i);
                    end
                end
                iter_success_mean = iter_success_sum/num_trials_successful; %Divide total # of iterations that actually
                    %produced success by the number of successes.
            end
            %STATS
            fg_median = median(fg_final_per_trial);
            if OnOff_fghist && OnOff_Autosave_Workspace_Per_Trial && (Reg_Method ~= 2)
                fghist_mean = mean(fghist_over_all_trials, 1); %", 1" is necessary for case num_trials = 1.
            end
            fg_min = min(fg_final_per_trial);
            fg_max = max(fg_final_per_trial);
            %Sum row and divide in order to quickly average.
            fg_mean = sum(fg_final_per_trial, 2)/num_trials;
            fg_std = std(fg_final_per_trial);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Neural Network training check
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if objective_id ~= 11 %display this if not training a NN

            %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Succinctly Display Outputs of Interest: Case No Tables%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Standard_Output

            %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Option to Automatically Save Workspace With a Uniquely Descriptive Name After Each Column Generated%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if OnOff_Autosave_Workspace_Per_Column
                Autosave_Workspace_Per_Column
            end

            %$%%%%%%%%%%%%%%%%%%%%
            %Intermediate Outputs%
            %%%%%%%%%%%%%%%%%%%%%%
            if OnOff_SuccessfulUnsuccessful
                if OnOff_iter_success
                    disp(['Column #', num2str(Internal_unique_column_counter), ': num_trials_successful = ', num2str(num_trials_successful), ', iter_success = ', num2str(iter_success)])
                else %(i.e. OnOff_iter_success == 0)
                    disp(['Column #', num2str(Internal_unique_column_counter), ': num_trials_successful = ', num2str(num_trials_successful)])
                end
                if (Internal_unique_column_counter == TableParams_min_num_unique_columns) && (TableParams_OnOff_num_columns_fixed)
                    fprintf('\r')
                end
            end
            if Reg_Method ~= 0
                if OnOff_num_gs_identical_b4_refinement
                    disp(['reg_fact_trial_finals: ', num2str(reg_fact_trial_finals)])
                end
            end
            if num_trials > 1
                if OnOff_fghist
                    disp(['fg_final_per_trial = ', num2str(fg_final_per_trial)])
                    disp(['Time of Column Completion: ', datestr(now)])
                    fprintf('\r') %Insert a carriage return before future outputs.
                end
            end
        end
            
        %$%%%%%%%%%%%%%%%%%%%
        %Graph mean behavior%
        %%%%%%%%%%%%%%%%%%%%%
        if Reg_Method ~= 2
            if OnOff_graphs
                Graphs
            end
        end
    end %end "unique_columns" loop
    clear reg_fact_array_tr
end %End "unique_tables" loop.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Neural Network training check
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~OnOff_Tricias_NN_training 
    load train %Play a sound to notify user of completion.
    sound(y)
    clear y Fs %Clear the workspace of unnecessary clutter.
    
    %Option to close all graphs at completion if many were generated (e.g.
    %in the case of Swarm_Trajectory == 1)
    if OnOff_graphs
        if OnOff_Close_All_Graphs
            close all
        end
    else
        close all
    end
else
    first_pso = false; %indicate for NN training that pso was run before
end

if Reg_Method ~= 0
    if OnOff_see_data_per_grouping
       disp(['max(abs(g)) = ', num2str(max(abs(g)))])
       disp(['max(abs(x)) = ', num2str(max(abs(x)))])
       disp(['max(abs(v)) = ', num2str(max(abs(v)))])
    end
end
