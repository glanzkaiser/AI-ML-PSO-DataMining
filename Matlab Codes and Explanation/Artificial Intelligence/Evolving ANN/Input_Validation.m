
disp('AUTOMATIC INPUT VALIDATION')
fprintf('\r')
auto_changes_made = false;
    % If this is still false at the end of this file, a message will be
        %displayed confirming that no changes have been made.
TableParams_num_tables = 1;
TableParams_min_num_unique_columns = 1;
TableParams_OnOff_num_columns_fixed = true;
TableParams_OnOff_calculate_min_median_per_table = true;
if min(min(range_IS0)) <= 0
    error(['You have set at least one dimension of "range_IS0" less than '...
        'or equal to zero.  For each dimension of the search space, '...
        'there is a center and a '...
        'range.  Particles are initialized within half the range to the '...
        'left of center and half the range to the right of center.  Some '...
        'portions of the program expect a positive range and will '...
        'malfunction in the presence of a nonsensical input.'])
end
if OnOff_SuccessfulUnsuccessful
    if ~exist('thresh_for_succ', 'var')
        error(['No threshold for success has yet been defined '...
            'for dim = ', num2str(dim), ' and the ', ...
            objective, ' objective.  '...
            'Please check the literature and add a common '...
            'threshold to "Objectives.m" for the particular '...
            'objective and problem dimensionality you are '...
            'testing.  If no common threshold exists for the '...
            'case you are testing, please ensure that the '...
            'threshold you specify makes sense when considering '...
            'threshold values that have been used in other cases.  '...
            'Since higher dimensionality generally '...
            'produces higher function values, it would be '...
            'nonsensical to use the same threshold regardless '...
            'of problem dimensionality or objective.'])
    end
end
if OnOff_lbest
    if OnOff_GCPSO
        error('You have activated switches "OnOff_lbest" and "OnOff_GCPSO" concurrently: since lbest PSO does not have knowledge of the global best, the two seem conceptually incompatible and have not been overlaid in the code.  Please de-activate one switch or the other.')
    end
	if OnOff_Cauchy_mutation_of_global_best
        error('You have activated switches "OnOff_lbest" and "OnOff_Cauchy_mutation_of_global_best" concurrently: since lbest PSO does not have knowledge of the global best, the two seem conceptually incompatible and have not been overlaid in the code.  Please de-activate one switch or the other.')
	end
end
if OnOff_position_clamping && OnOff_v_reset
    disp(['Velocity reset is a special case of position clamping.  They '...
    	'should not both be active at once.'])
    error('OnOff_v_reset == true && OnOff_position_clamping == true') 
end
if (isequal(objective, 'Schaffers_f6') && (dim ~= 2))
    disp(['Please set "dim" = 2 in "Control_Panel.m." '...
    	'(This message has been generated to ensure the user understands that Schaffer''s f6 is only a two-dimensional function.)'])
    error('You have selected Schafer''s f6 function which is two-dimensional, but the dimensionality selected is other than two.')
end
if OnOff_lbest == 1
    if lbest_neighb_size > np
        error('You have selected a neighborhood size larger than the entire swarm.  That is, (i) OnOff_lbest == true, and (ii) lbest_neighb_size > np.')
    end
end
if OnOff_graphs
    if (~OnOff_fghist)
        if (OnOff_graph_fg)
            OnOff_fghist = true;
            disp(['Since switch "OnOff_graph_fg" is active, which indicates the desire to '...
                'plot the function value produced by the global best '...
                'versus time, switch "OnOff_fghist" has '...
                'automatically been activated in order to maintain the '...
                'necessary history, "fghist," from which to generate the desired graph.'])
            fprintf('\r') %Insert a carriage return before future outputs.
            auto_changes_made = true;
        end
        if OnOff_graph_fg_mean
            if (num_trials > 1)
                OnOff_fghist = true;
                disp(['Since switch "OnOff_graph_fg_mean" is active, which indicates '...
                    'the desire to plot the mean function value produced '...
                    'by the global best versus time, switch '...
                    '"OnOff_fghist" has automatically been activated in order to maintain '...
                    'the necessary history, "fghist_over_all_trials", from which to compute "fg_mean".'])
                fprintf('\r') %Insert a carriage return before future outputs.
                auto_changes_made = true;
                if ~OnOff_Autosave_Workspace_Per_Trial
                    OnOff_Autosave_Workspace_Per_Trial = true;
                    disp(['Since switch "OnOff_graph_fg_mean" is active, switch "OnOff_Autosave_Workspace_Per_Trial" '...
                        'has automatically been activated so that the necessary history, "fghist_over_all_trials," can be '...
                        'constructed within "Load_trial_data_for_stats.m" using the "fghist" of each trial''s workspace: '...
                        '"fghist_over_all_trials" is necessary to compute "fg_mean".'])
                    disp(['Note: It is also generally a good idea to concurrently activate switch "OnOff_Autodelete_Trial_Data" '...
                        'to regulate the sizes of saved workspaces.  It is recommended that you do this before execution.'])
                    fprintf('\r') %Insert a carriage return before future outputs.
                    auto_changes_made = true;
                end
            elseif (num_trials == 1)
                disp(['Switch "OnOff_graph_fg_mean" is active, but "num_trials" == 1.  In other words, you have chosen '...
                	'to graph the mean function value per iteration over multiple trials, but no mean will be generated since only one trial is to be conducted.  '...
                	'The graph of mean behavior will not take effect.  If your intention was to graph the function value '...
                    'of the global best over one trial, please activate switch "OnOff_graph_fg" instead.'])
                fprintf('\r') %Insert a carriage return before future outputs.
                auto_changes_made = true;
            end
        end
    end
    if (OnOff_graph_ObjFun_f_vs_2D || OnOff_swarm_trajectory || OnOff_phase_plot) && (isequal(objective, 'NN') || isequal(objective, 'Quartic_Noisy') || isequal(objective, 'Rosenbrock') || isequal(objective, 'Schaffers_f6') || isequal(objective, 'Weighted_Sphere'))
        OnOff_graph_ObjFun_f_vs_2D = false;
        OnOff_swarm_trajectory = false;
        OnOff_phase_plot = false;
        disp(['Any of graphing switches "OnOff_graph_ObjFun_f_vs_2D", "OnOff_swarm_trajectory", '...
            'or "OnOff_phase_plot" which were active have been de-activated since they are not '...
            'yet compatible with the ' objective ' objective.  You may subscribe to updates at '...
            '<a href="http://www.georgeevers.org/pso_research_toolbox.htm">www.georgeevers.org/pso_research_toolbox.htm</a> '...
            'to be notified when this functionality becomes available.'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
    if OnOff_graph_f && (num_trials == 1) && ~OnOff_fhist %If the function value of each 
           %particle is to be graphed (instead of only the function value
           %of the global best),
        OnOff_fhist = true; %matrix "fhist," which maintains in each
             %row the function value of the corresponding particle, must be
             %maintained.
        disp(['Because you have activated "OnOff_graph_f," which graphs'...
            ' the function value versus iteration for every '...
            'single particle, matrix "fhist" must be maintained; '...
            'therefore, "OnOff_fhist" has been activated automatically."'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
    if OnOff_graph_g && (num_trials == 1) && ~OnOff_ghist
        OnOff_ghist = true;
        disp(['Because you have activated "OnOff_graph_g," which graphs the position of the global best versus iteration, '...
        	'matrix "ghist" must be maintained; therefore, "OnOff_ghist" has been activated automatically."'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
    if OnOff_graph_p && (num_trials == 1) && ~OnOff_phist
        OnOff_phist = true;
        disp(['Because you have activated "OnOff_graph_p," which graphs the function values of the global best versus iteration, '...
        	'matrix "phist" must be maintained; therefore, "OnOff_phist" has been activated automatically."'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
    if OnOff_graph_v && (num_trials == 1) && ~OnOff_vhist
        OnOff_vhist = true;
        disp(['Because you have activated "OnOff_graph_v," which graphs the function values of the global best versus iteration, '...
        	'matrix "vhist" must be maintained; therefore, "OnOff_vhist" has been activated automatically."'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
    if OnOff_swarm_trajectory
        if dim == 2
            if Reg_Method == 1
                if (OnOff_plot_box_4_new_search_space) && (~OnOff_g_after_each_grouping)
                    OnOff_g_after_each_grouping = true;
                    disp(['Since you have selected via "OnOff_plot_box_4_new_search_space" to plot a box showing the new search '...
                    	'space of each regrouping, "OnOff_g_after_each_grouping" has been activated automatically to allow access '...
                    	'to the global best prior to the occurrence of each regrouping.'])
                    fprintf('\r') %Insert a carriage return before future outputs.
                    auto_changes_made = true;
                end
            end
            if (OnOff_mark_personal_bests) && (~OnOff_phist)
                OnOff_phist = true;
                disp('"OnOff_phist" has been activated for you in order to mark the personal bests on the contour map since "OnOff_mark_personal_bests" is active.')
                fprintf('\r') %Insert a carriage return before future outputs.
                auto_changes_made = true;
            end
            if (OnOff_mark_global_best_always || OnOff_mark_global_best_on_zoomed_graph) && (~OnOff_ghist)
                OnOff_ghist = true;
                disp('"OnOff_ghist" has been activated for you in order to mark the global best on the contour map since "OnOff_mark_global_best_always" is active.')
                fprintf('\r') %Insert a carriage return before future outputs.
                auto_changes_made = true;
            end
        else %i.e. dim ~= 2
            disp(['You have activated graphs of the swarm trajectory, but this cannot be done since the number '...
                'of dimensions selected is other than 2.'])
            fprintf('\r') %Insert a carriage return before future outputs.
            auto_changes_made = true;
        end
    end
    if OnOff_phase_plot
        if dim ~= 2
            disp(['You have activated the phase plot, but this cannot be done since the number '...
                'of dimensions selected is other than 2.'])
            fprintf('\r') %Insert a carriage return before future outputs.
            auto_changes_made = true;
        end
    end
    if ~OnOff_xhist && (((dim == 2) && (OnOff_swarm_trajectory || (OnOff_phase_plot && num_trials == 1))) || (OnOff_graph_x && num_trials == 1))
        OnOff_xhist = true;
        disp(['Since "OnOff_swarm_trajectory," "OnOff_phase_plot," or "OnOff_graph_x" is active, '...
        '"OnOff_xhist" has been activated automatically so that "xhist" will be maintained from '...
        'which to generate the desired graph(s).'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
end
if Reg_Method ~= 0 %i.e. regrouping is active.
    if Reg_Method == 1
        if OnOff_NormR_stag_det == 0
            disp('You have selected Reg_Method 1 but have not activated "OnOff_NormR_stag_det."')
            error('Please activate "OnOff_NormR_stag_det" and ensure that "stag_thresh" is to your liking.')
        end        
        if max_num_groupings < 2
            disp(['If you wish to use Regrouping Method 1, set "max_num_groupings" to either: (i) a very large number '...
            	'so that either "max_iter_over_all_groupings" (if ~OnOff_func_evals) or "max_FEs_over_all_groupings" '...
            	'(if OnOff_func_evals) will terminate each trial, or (ii) the exact # of groupings desired, in which '...
            	'case "max_iter_over_all_groupings" should be set larger than "max_iter_per_grouping"*"max_num_groupings" to ensure that '...
            	'the desired number of groupings are carried out.  The # of groupings is the initial grouping plus all regroupings.'])
            error('"Reg_Method" = 1, but "max_num_groupings" < 2.')
        end
        if OnOff_num_gs_identical_b4_refinement
            if (~OnOff_g_after_each_grouping) && (num_gs_identical_b4_refinement ~= 0) %latter variable only defined when previous line is active
                OnOff_g_after_each_grouping = true;
                disp(['"OnOff_num_gs_identical_b4_refinement" is active expressing the desire to reduce the regrouping '...
                	'factor after "num_gs_identical_b4_refinement" global bests at groupings'' end return the same '...
                	'rounded values.  Since "num_gs_identical_b4_refinement" is not zero, this requires that '...
                	'"OnOff_g_after_each_grouping" also be active, so it has been activated for you.'])
                fprintf('\r') %Insert a carriage return before future outputs.
                auto_changes_made = true;
            end
        end  
    elseif Reg_Method == 2 %Reduce workspace clutter by generating the variables below only when they will be used.
        if max_num_groupings < 2
            disp(['If you wish to use Regrouping Method 2, set "max_num_groupings" to the total # of groupings desired. '...
            	'The total # of groupings is the initial grouping plus all regroupings.  Each grouping consists of '...
            	'"num_runs_b4_reduction" runs, after which the search space becomes the region between each run''s "g."'])
            error('"Reg_Method" = 2, but "max_num_groupings" < 2.')
        elseif max_num_groupings > 50
            disp(['Regrouping method 2 runs "max_num_groupings" groupings, records the global best of each, and regroups '...
                'within the max and min per dimension of those bests.  It may not be necessary to use such a large '...
            	'value for "max_num_groupings."'])
            disp(['Currently, max_num_groupings = ', num2str(max_num_groupings), '.'])
            fprintf('\r') %Insert a carriage return before future outputs.
            auto_changes_made = true;
        end
    end
else %(i.e. if Reg_Method == 0)
    max_num_groupings = 1; %Automatically set "max_num_groupings" to 1 for case "Reg_Method" == 0.
                           %It is used only internally for filenames saved to in "reg_main.m"
                           %and was not set by the user for the standard case.
    if OnOff_NormR_stag_det
        disp(['Warning: You are running standard PSO with NormR stagnation detection and search termination. '...
        	'This is not a problem unless you intend to generate standard data for comparison, in which '...
        	'case it should not be used at all since it is not a standard feature.'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
end
if OnOff_MPSO
    if ~OnOff_GCPSO
        disp(['MPSO was designed to be used with GCPSO at its core.  '...
            'Mr. Evers''s PSO Research Toolbox allows for the '...
            'multi-start of other algorithms as well.  This message is '...
            'generated to be sure you are aware that you are utilizing '...
            'the multi-start concept with another algorithm at the core.'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
end
if OnOff_func_evals && (Reg_Method ~= 0) %if only FE's selected
    if max_FEs_over_all_groupings < max_FEs_per_grouping
        disp(['"max_FEs_over_all_groupings" is set lower than "max_FEs_per_grouping." '...
        	'If you are running standard PSO without regrouping, please set "max_FEs_per_grouping" to determine '...
        	'the # of function eval''s since "max_FEs_over_all_groupings" is considered irrelevant to the standard '...
        	'case.  If you are using PSO with regrouping, please set "max_FEs_per_grouping" '...
        	'to be the maximum # of function eval''s per grouping and "max_FEs_over_all_groupings" to be the '...
        	'maximum # of function evaluations over all groupings.'])
        fprintf('\r') %Insert a carriage return before future outputs.
        auto_changes_made = true;
    end
end
if OnOff_Tricias_NN_training
    if OnOff_func_evals
		OnOff_func_evals = false;
        	disp(['Since Tricia''s ANN training is designed to work with '...
                'iterations rather than function evaluations, switch "OnOff_func_evals" '...
                'has been de-activated automatically.  If you add compatibility with '...
                'function evaluations, please email george@georgeevers.org the updated '...
                'code for the benefit of the research community.'])
	        fprintf('\r') %Insert a carriage return before future outputs.
    end
    if OnOff_graphs && OnOff_graph_ObjFun_f_vs_2D
		OnOff_graph_ObjFun_f_vs_2D = false;
        	disp(['Since ANN training is being conducted instead of a benchmark, '...
                'switch "OnOff_graph_ObjFun_f_vs_2D" has been de-activated automatically.'])
	        fprintf('\r') %Insert a carriage return before future outputs.
    end
else %i.e. if ~OnOff_Tricias_NN_training
    if auto_changes_made == false
        disp('No automatic changes have been made.')
        fprintf('\r')
    end
end
clear auto_changes_made
    %Keep workspace organized by clearing this variable, which will not
        %be used again beyond this point.
Display_Settings