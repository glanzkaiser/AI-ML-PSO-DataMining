
if OnOff_Tricias_NN_training
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This paragraph copyright 2010, 2011, 2012 Tricia Rambharose.
%   Created on: 2010/09/18
%   info@tricia-rambharose.com
%	Seed the random generator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Seed the random generator to fix the non-randomness of initial particle
    %positions.
    RandStream.setDefaultStream ...
         (RandStream('mt19937ar','seed',sum(100*clock)));
end

%$%%%%%%%%%%%%
%Standard PSO%
%%%%%%%%%%%%%%
if OnOff_asymmetric_initialization
    vmax_perc = 4*vmax_perc; %When asymmetric initialization is used,
        %velocities should be clamped based on the range of the search
        %space rather than on the range of the initialization space.
end
vmax(1:np, 1:dim) = vmax_perc.*range_IS; %Define the maximum
    %velocity for velocity initialization and, optionally,
    %velocity clamping.
x(1:np, 1:dim) = center_IS + range_IS.*rand(np, dim) - range_IS./2; %Randomly initialize the
    %particles about "center_IS".
RegPSO_grouping_counter = 1; %stores the current grouping #
if Reg_Method == 1;
    if OnOff_MPSO
        MPSO_grouping_counter = MPSO_grouping_counter + 1; %counts the
            %total # of groupings over the entire MPSO trial (i.e. across
            %all MPSO starts): the first increment done here is from 1
            %to 2
    end
    if OnOff_func_evals
        OPSO_ghost_FEs_RegPSO = 0;
    end
end
if OnOff_lbest %Call "gbest_core" or "lbest_core."
    lbest_core
else
    gbest_core
end
if OnOff_graphs
    if OnOff_swarm_trajectory
        RegPSO_k = 0; %Add this variable, which would otherwise
            %not apply to the standard case, for use below
            %(updated later in case Reg_Method == 1).
        if dim == 2
            if GraphParams_swarm_traj_snapshot_mode == 2 %For this case, determine the meshgrid now rather than
                %recursively within "Swarm_Trajectory."
                %Set min & max on each dimension then generate a meshgrid.
                Internal_GraphParams_dim1min = min(xhist(:, 1:2:size(xhist, 2))); %2*0+1 = 1st column (iter 0, 1st dim), 
                Internal_GraphParams_dim1max = max(xhist(:, 1:2:size(xhist, 2))); %2*1+1 = 3rd column (1st iter, 1st dim)
                Internal_GraphParams_dim2min = min(xhist(:, 2:2:size(xhist, 2))); %2*0+1 = 1st column (iter 0, 2nd dim),
                Internal_GraphParams_dim2max = max(xhist(:, 2:2:size(xhist, 2))); %2*1+1 = 3rd column (1st iter, 2nd dim)
                f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.
            end
            Swarm_Trajectory; %Calculate swarm state at various iterations using "xhist."
        end
    end
end
if Reg_Method == 1;
	RegPSO_k = k; %"RegPSO_k" accrues with each grouping the # of PSO iterations within each RegPSO trial.
    if OnOff_func_evals
        OPSO_ghost_FEs_RegPSO = OPSO_ghost_FEs_counter;
    end
    if OnOff_graphs
        if OnOff_swarm_trajectory
            RegPSO_g_after_each_grouping = g(1, :);
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
                MPSO_g_after_each_grouping = [MPSO_g_after_each_grouping; g(1, :)];
            end
        end
    elseif (OnOff_g_after_each_grouping && (OnOff_MPSO || ~OnOff_Autosave_Workspace_Per_Grouping)) || OnOff_num_gs_identical_b4_refinement
        RegPSO_g_after_each_grouping = g(1, :);
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
            MPSO_g_after_each_grouping = [MPSO_g_after_each_grouping; g(1, :)];
        end
    end
    if OnOff_range_IS_per_grouping && (OnOff_MPSO || OnOff_see_data_per_grouping || ~OnOff_Autosave_Workspace_Per_Grouping)
            %If the user does not wish to see the data per grouping and ~OnOff_MPSO,
                %this can be generated more efficiently from the saved
                %WS of the groupings.  In the case of MPSO, it may
                %be beneficial to still generate this.
        RegPSO_range_IS_per_grouping = range_IS0.*ones(1, dim); %Store the initial range_IS
            %and, if specified as a scalar for convenience, convert to the expected vector
        if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping) %otherwise, this history...
            %will more efficiently be constructed within...
            %"RegPSO_load_grouping_data.m" rather than needing to be...
            %initialized here.
            MPSO_range_IS_per_grouping = [MPSO_range_IS_per_grouping; range_IS(1, :)];
        end
    end
    if OnOff_MPSO || (~OnOff_Autosave_Workspace_Per_Grouping)
            %If the workspace is saved per grouping, this data
            %will more efficiently be constructed within
            %"RegPSO_load_grouping_data.m" rather than needing to be maintained
            %here.  However, if MPSO is active, it may be beneficial to
            %maintain the "RegPSO_k_after_each_grouping" over each RegPSO execution within an
            %MPSO trial as well as reconstructing "MPSO_k_after_each_grouping" over all
            %MPSO groupings spanning multiple trials.
        if OnOff_fg_after_each_grouping
            %If the worskpace is saved per grouping, "MPSO_fg_after_each_grouping" can more efficiently be
            %constructed at the end of the trial.
            if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping)
                MPSO_fg_after_each_grouping = [MPSO_fg_after_each_grouping, fg];
            end
            RegPSO_fg_after_each_grouping = fg;
        end
        if OnOff_k_after_each_grouping
            if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping)
                MPSO_k_after_each_grouping = [MPSO_k_after_each_grouping, MPSO_k + RegPSO_k];
                    %If the workspace is saved per grouping, this history...
                    %will more efficiently be constructed within...
                    %"RegPSO_load_grouping_data.m" rather than needing to be maintained
                    %here.
            end
            RegPSO_k_after_each_grouping(RegPSO_grouping_counter) = RegPSO_k; %"RegPSO_k_after_each_grouping" is a matrix of order "num_trials" by #
        end %of groupings implemented.  It holds the iteration numbers AT which RegPSO regrouped and exists purely
            %for user analysis.
    end
end
iter_tot_all_trials = iter_tot_all_trials + k + 1;
    %The "+ 1" has the effect of counting all random initializations in
    %addition to the number of updates counted by "k".
if Reg_Method ~= 0
    if OnOff_Autosave_Workspace_Per_Grouping
        RegPSO_save_grouping_data
    end
end
%(removed for now) tcpu_tot = tcpu_tot + tcpu_elapsed; %%(option to track "cpu time" too)