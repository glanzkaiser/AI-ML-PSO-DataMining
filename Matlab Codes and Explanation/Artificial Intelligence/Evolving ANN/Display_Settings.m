
% Modification for NN training
if OnOff_user_input_validation_required
    disp('-------------------------')
    disp('USER INPUT VALIDATION')
    fprintf('\r')
else
    disp('PSO settings:');
end

if Reg_Method == 1
    disp('Regrouping PSO (RegPSO) utilizing:')
elseif Reg_Method == 2
    disp('Regrouping Method 2 utilizing:') %not as reliable as RegPSO: code
        %not yet perfected
end
if OnOff_OPSO
    disp('Opposition-based PSO (OPSO)')
end
if OnOff_lbest
    disp('Local Best (Lbest) PSO')
else
    if OnOff_GCPSO
        disp('Guaranteed Convergence PSO (GCPSO)')
    else
        disp('Global Best (Gbest) PSO')
    end
    if OnOff_Cauchy_mutation_of_global_best
        disp(['Cauchy mutation of global best enabled.'])
    end
end
if OnOff_MPSO
    disp('Multi-start of core algorithm enabled.')
end

if OnOff_func_evals
    if Reg_Method ~= 0 %i.e. a regrouping PSO will be used
        disp([num2str(max_FEs_per_grouping), ' FE''s maximum '...
            '(per grouping)'])
        if OnOff_MPSO
            disp([num2str(np*ceil(max_FEs_over_all_groupings/np))...
                ' FE''s maximum (over all groupings per MPSO start)'])
            disp([num2str(MPSO_max_FEs)...
                ' FE''s maximum (over all MPSO starts)'])
            disp([num2str(MPSO_max_starts)...
                ' MPSO starts maximum'])
        else %i.e. if ~OnOff_MPSO
            disp([num2str(np*ceil(max_FEs_over_all_groupings/np))...
                ' FE''s maximum (over all groupings)'])
        end
    else %i.e. Reg_Method == 0 selects standard PSO
        disp([num2str(max_FEs_per_grouping), ' FE''s maximum'])
    end
else %i.e. if iterations are to be used instead of function evaluations
    if Reg_Method ~= 0  %i.e. a regrouping PSO will be used
        disp([num2str(max_iter_per_grouping), ' iterations '...
            'maximum (per grouping)'])
        if OnOff_MPSO
            disp([num2str(max_iter_over_all_groupings), ' iterations '...
                'maximum (over all groupings per MPSO start)'])
            disp([num2str(MPSO_max_iters)...
                ' iterations maximum (over all MPSO starts)'])
            disp([num2str(MPSO_max_starts)...
                ' MPSO starts maximum'])
        else %i.e. if ~OnOff_MPSO
            disp([num2str(max_iter_over_all_groupings), ' iterations '...
                'maximum (total over all groupings)'])
        end
    else %(i.e. Reg_Method == 0 for the standard case without
            %regrouping)
        disp([num2str(max_iter_per_grouping), ' iterations maximum'])
    end
end
if OnOff_NormR_stag_det
   if Reg_Method == 0 %i.e. regrouping will not be used
       disp(['Search terminated early when normalized '...
           'swarm radius = ', num2str(stag_thresh)]) %Display...
            %the sensitivity used to determine when
            %stagnation has occurred in order to stop searching.
   elseif Reg_Method == 1 %i.e. RegPSO will be used (Reg_Method == 1)
       disp(['Regrouping triggered when normalized swarm '...
           'radius, "stag_thresh," = ', num2str(stag_thresh)]) %Display...
            %the sensitivity used to determine when
            %stagnation has occurred in order to regroup
            %the swarm.
        disp(['Regrouping factor: '...
            num2str(reg_fact*stag_thresh), '/stag_thresh = '...
            num2str(reg_fact)]) %Use of a smaller stagnation...
            %threshold allows more solution refinement which...
            %consequently allows the swarm to converge to...
            %within very close proximity of the global best....
            %This in turn necessitates a larger regrouping...
            %factor by which to multiply the maximum...
            %deviation from global best per dimension at
            %stagnation in order to determine the new range_IS...
            %within which to regroup the swarm about the...
            %global best.  This suggests that the regrouping...
            %factor and stagnation threshold are inversely...
            %proportional, which is reflected in the output...
            %to the screen.
   end
end
if OnOff_position_clamping
    disp('Position clamping active.')
elseif OnOff_v_reset
    disp('Velocity reset active.')
else
    disp('Position clamping inactive.')
    disp('Velocity reset inactive.')
end
if OnOff_v_clamp
    disp(['Velocities clamped to ', num2str(vmax_perc*100), '% of the range on each dimension.'])
        %Otherwise, the velocity clamping value is constant over
        %all trials and sets of trials, so state the value.
else
    disp('Velocity clamping inactive.')
end
if OnOff_fghist
    disp('History, "fghist," of function values at global best active.')
end
if OnOff_ghist
    disp('History, "ghist," of global bests active.')
end
if OnOff_lbest
    if OnOff_lhist
        disp('History, "lhist," of local bests active.')
    end
end
if OnOff_phist
    disp('History, "phist," of personal bests active.')
end
if OnOff_fhist
    disp('History, "fhist," of all function values active.')
end
if OnOff_xhist
    disp('History, "xhist," of all positions active.')
end
if OnOff_vhist
    disp('History, "vhist," of all velocities active.')
end
if OnOff_v_cog_hist
    disp('History, "v_cog_hist," of cognitive velocity components active.')
end
if OnOff_v_soc_hist
    disp('History, "v_soc_hist," of social velocity components active.')
end

disp([num2str(num_trials), ' trial(s)']) %previously disp([num2str(num_trials), ' trial(s) of ', num2str(max_num_groupings), ' grouping(s) max'])
disp([num2str(np), ' particles'])
if OnOff_w_linear
    disp(['Inertia weight linearly varied from ', num2str(w_i), ' to ', num2str(w_f), ' per grouping.'])
else %i.e. static inertia weight not incremented per column
    fprintf('Static inertia weight,               w: %0g \r', w)
end
fprintf('Cognitive acceleration coefficient, c1: %0g \r', c1)
fprintf('Social acceleration coefficient,    c2: %0g \r', c2)
disp([objective, ': ', num2str(dim), ' dimensions']) %so state objective name along with dimensionality of search space.
if size(center_IS0, 2) == 1 %i.e. The center_IS vector or matrix is the same on each dimension and therefore may be represented conveniently as a scalar.
    if size(range_IS0, 2) == 1 %i.e. The range_IS vector or matrix is the same on each dimension and therefore may be represented conveniently as a scalar.
        if OnOff_asymmetric_initialization %so state exact range_IS used.
            disp(['Asymmetric Initialization: [', num2str(center_IS0(1, 1) - range_IS0(1, 1)/2), ',', num2str(center_IS0(1, 1) + range_IS0(1, 1)/2), ']'])
        else
            disp(['Symmetric Initialization: [', num2str(center_IS0(1, 1) - range_IS0(1, 1)/2), ',', num2str(center_IS0(1, 1) + range_IS0(1, 1)/2), ']'])
        end
    else %i.e. if "range_IS0" is specified as a vector or matrix - implying that it
        %may not be the same on all dimensions
        for Internal_i = 1:dim
            fprintf('Range on Dimension %2g: [%8f, %7f]\r', Internal_i, center_IS0(1, 1) - range_IS0(1, Internal_i)/2, center_IS0(1, 1) + range_IS0(1, Internal_i)/2)
        end
    end
else %i.e. if "center_IS0" is specified as a vector - implying that it
    %may not be the same on all dimensions
    if size(range_IS0, 2) == 1
        %may not be the same on all dimensions
        for Internal_i = 1:dim
            fprintf('Range on Dimension %2g: [%8f, %7f]\r', Internal_i, center_IS0(1, Internal_i) - range_IS0(1, 1)/2, center_IS0(1, Internal_i) + range_IS0(1, 1)/2)
        end
    else %i.e. if "range_IS0" is specified as a vector or matrix - implying that it
        %may not be the same on all dimensions
        for Internal_i = 1:dim
            fprintf('Range on Dimension %2g: [%8f, %7f]\r', Internal_i, center_IS0(1, Internal_i) - range_IS0(1, Internal_i)/2, center_IS0(1, Internal_i) + range_IS0(1, Internal_i)/2)
        end
    end
end
if OnOff_SuccessfulUnsuccessful %so threshold for success can be stated since it doesn't change (since objective is constant).
    disp(['Threshold required for success: ', num2str(thresh_for_succ)])
    if OnOff_Terminate_Upon_Success
        disp('"OnOff_Terminate_Upon_Success" active.')
    else
        disp('"OnOff_Terminate_Upon_Success" inactive.')
    end
end
fprintf('\r')%Insert carriage return.

if OnOff_user_input_validation_required
    Input_IntendedParameters = input('Are the displayed settings as you intended (Y or N)? ', 's');
    if isequal(Input_IntendedParameters, 'Y') || isequal(Input_IntendedParameters, 'y') || isequal(Input_IntendedParameters, 'Yes') || isequal(Input_IntendedParameters, 'yes') || isequal(Input_IntendedParameters, 'YES')
        DateString_dir = datestr(now);
        DateString_dir(12) = '-';
        DateString_dir([15, 18]) = '.';
        DateString_dir([3, 8, 9]) = [];    
        disp(['Start Time: ', DateString_dir])
        if (OnOff_Autosave_Workspace_Per_Grouping || OnOff_Autosave_Workspace_Per_Trial || OnOff_Autosave_Workspace_Per_Column)
            mkdir(['Data/', DateString_dir, '/WS'])
        end
        if OnOff_graphs
            if OnOff_graph_fg_mean || ((dim == 2) && (OnOff_swarm_trajectory || OnOff_graph_ObjFun_f_vs_2D || ((num_trials == 1) && OnOff_phase_plot)) || ((num_trials == 1) && (OnOff_graph_fg || OnOff_graph_g || OnOff_graph_x || OnOff_graph_p || OnOff_graph_v || OnOff_graph_f)))
                mkdir(['Data/', DateString_dir, '/Figures'])
            end
        end
        fprintf('\r')%Insert carriage return.
        disp('-------------------------')
        disp('RESULTS')
        fprintf('\r')
        RegPSO_main
    else
        disp('Okay, please change the settings and try again.');
    end
else %i.e. if ~OnOff_user_input_validation_required
    DateString_dir = datestr(now);
    DateString_dir(12) = '-';
    DateString_dir([15, 18]) = '.';
    DateString_dir([3, 8, 9]) = [];
    if (OnOff_Autosave_Workspace_Per_Grouping || OnOff_Autosave_Workspace_Per_Trial || OnOff_Autosave_Workspace_Per_Column)
        mkdir(['Data/', DateString_dir, '/WS'])
    end
    if OnOff_graphs
        if OnOff_graph_fg_mean || ((dim == 2) && (OnOff_swarm_trajectory || OnOff_graph_ObjFun_f_vs_2D || ((num_trials == 1) && OnOff_phase_plot)) || ((num_trials == 1) && (OnOff_graph_fg || OnOff_graph_g || OnOff_graph_x || OnOff_graph_p || OnOff_graph_v || OnOff_graph_f)))
            mkdir(['Data/', DateString_dir, '/Figures'])
        end
    end
    RegPSO_main
end