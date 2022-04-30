%This code is used to regroup the swarm about the global best each time
%premature convergence is detected.  The range, "range_IS", within which
%particles regroup per dimension is proportional to the degree of uncertainty
%inferred on that dimension.  The maximum velocity, "vmax," is recalculated
%with each new grouping using the same "vmax_perc" of each new "range_IS."
%Positions, and velocities are then randomly initialized within the resulting
%search space centered at the global best of the previous regrouping the same
%way they were initialized in Gbest PSO.  Personal bests are cleared and the
%global best is remembered, so that particles continue the same search via
%their pull toward the global best of the stagnated trial while experiencing
%cognitive inhibition in order to comb the search space in their return toward
%global best.

if OnOff_see_data_per_grouping
    disp(['fg = ', num2str(fg)])
    disp(['reg_fact = ', num2str(reg_fact)])
    disp(['stag_thresh = ', num2str(stag_thresh)])
    disp(['g = ', num2str(round(g(1, :)))])
    disp(['range_IS = ', num2str(round(range_IS(1, :)))])
    disp(['range_IS_check: ', num2str(0.5*range_IS(1, :) > abs(g(1, :)))])
    if RegPSO_grouping_counter > 1
        if OnOff_range_IS_per_grouping
            disp(['range_IS % of prev: ', num2str(round(RegPSO_range_IS_per_grouping(RegPSO_grouping_counter, :)./RegPSO_range_IS_per_grouping(RegPSO_grouping_counter - 1, :)*100))])
        end
    end
    disp(['RegPSO_grouping_counter = ', num2str(RegPSO_grouping_counter)])
end

%(removed for now) && RegPSO_grouping_counter < max_num_groupings
%The initial grouping was the standard PSO
%executed above.  If, for example, 2 groupings total have been specified,
%this loop will generate 1 more grouping, etc.
%until "max_iter_over_all_groupings" is reached
%(assuming that a sufficient "max_num_groupings" have been specified to achieve this).
%if OnOff_ghist == 0            %If the global best equals its previous value, regrouping
%    g_prev = round(g(1, :))  %will stop to allow solution refinement.
%end

RegPSO_grouping_counter = RegPSO_grouping_counter + 1;
if OnOff_MPSO
    MPSO_grouping_counter = MPSO_grouping_counter + 1; %counts the
        %total # of groupings over the entire MPSO trial (i.e. across
        %all MPSO starts): the first increment done here is from 1
        %to 2
end
%Reinitialize positions, velocities, and velocity clamping value.
%"range_IS = 2*max(max(abs(x - g)))" uses the max along any
    %dimension to establish the new range_IS
range_IS = repmat(min(reg_fact*max(abs(x - g)), range_IS0), np, 1); %The maximum distance
    %from "g" on each dimension is used to determine the new search space.
%disp(['unclipped range_IS = ' num2str(round(reg_fact*max(abs(x - g))))])
%range_IS = repmat(min(reg_fact*max(abs(x - g)), 2*range_IS0), np, 1);
if max(max(range_IS)) == Inf
    if max_iter_per_grouping < 500
        errordlg('''max(max(range_IS)) == Inf.'' Try increasing the parameter ''max_iter_per_grouping.''')
    else
        errordlg('''max(max(range_IS)) == Inf.''')
    end
end
vmax = vmax_perc.*range_IS; %Define the maximum velocity for velocity initialization
    %and, optionally, for velocity clamping.
center_IS = g; %center_IS the new search space around the global best.
x(1:np, 1:dim) = center_IS + range_IS.*rand(np, dim) - range_IS./2;
    %Randomly reinitialize the positions of all other particles.
    %"1:np" and "1:dim" are used to ensure that an error message will be
        %generated if dimensions do not agree at this point.
if OnOff_lbest %Call "gbest_core" or "lbest_core."
    lbest_core
else
    gbest_core
end
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
if OnOff_num_gs_identical_b4_refinement
    if (RegPSO_grouping_counter - 1) > num_gs_identical_b4_refinement %avoid negative index
        if OnOff_g_after_each_grouping  %Reduce "reg_fact" if "num_gs_identical_b4_refinement" is satisfied.
            if isequal(round(RegPSO_g_after_each_grouping(size(RegPSO_g_after_each_grouping, 1), :)), ...
                    round(RegPSO_g_after_each_grouping(size(RegPSO_g_after_each_grouping, 1) - num_gs_identical_b4_refinement, :)))
                reg_fact = reg_fact/reg_reduction_factor;%OnOff_NormR_stag_det = 0 %"if" within "if" because "gprev"/"ghist" don't exist
            end                           %for comparison in the other case
        elseif num_gs_identical_b4_refinement == 0
            reg_fact = reg_fact/reg_reduction_factor;
        end
    end
end
if OnOff_graphs
    if (OnOff_swarm_trajectory) && (dim == 2)
        Swarm_Trajectory; %Calculate swarm state at various iterations using "xhist."
    end
end
if OnOff_num_gs_identical_b4_refinement || ((OnOff_g_after_each_grouping || OnOff_fg_after_each_grouping) && (OnOff_MPSO || ~OnOff_Autosave_Workspace_Per_Grouping))
    %grouping data.
    RegPSO_g_after_each_grouping(RegPSO_grouping_counter, 1:dim) = g(1, :);
    if OnOff_num_gs_identical_b4_refinement
        if ((size(RegPSO_g_after_each_grouping, 1) > (num_gs_identical_b4_refinement + 1))) && OnOff_Autosave_Workspace_Per_Grouping
            %If the workspace is being saved per
            %grouping, we can reconstruct this later
            %from the g(1, :) of each grouping and
            %save for now only the amount of data
            %needed for comparison.
            RegPSO_g_after_each_grouping(1, :) = []; %Retain only past "num_gs_identical_b4_refinement + 1" values for comparison.
        end
    end
    if OnOff_fg_after_each_grouping && (OnOff_MPSO || ~OnOff_Autosave_Workspace_Per_Grouping)
        %If the worskpace is saved per grouping, this can be
        %constructed at the end of the trial from each
        %grouping's "fg."
        RegPSO_fg_after_each_grouping(RegPSO_grouping_counter) = fg;
    end
end %Store global best to row # = grouping # with each new trial: column # is
    %incremented by # of dimensions per new trial.

iter_tot_all_trials = iter_tot_all_trials + k + 1; %The "+ 1" accounts for randomizations

%(removed for now) tcpu_tot = tcpu_tot +
%tcpu_elapsed;
if OnOff_Autosave_Workspace_Per_Grouping
    RegPSO_save_grouping_data
end

RegPSO_k = RegPSO_k + k + 1; %"RegPSO_k" stores # of PSO iterations over the entire trial
if OnOff_graphs
    if OnOff_swarm_trajectory
        RegPSO_g_after_each_grouping = [RegPSO_g_after_each_grouping; g(1, :)];
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
    RegPSO_g_after_each_grouping = [RegPSO_g_after_each_grouping; g(1, :)];
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
    %If the user does not wish to see the data per grouping,
        %this can be generated more efficiently from the saved
        %WS of the groupings, though it may be beneifical
        %to examine in the case of MPSO.
    RegPSO_range_IS_per_grouping(RegPSO_grouping_counter, :) = range_IS(1, 1:dim); %Maintain a history of all range_ISs used.
        %Aside from being directly informative, this allows computation of the borders of each hypercube
        %within which regrouping occurs.
    if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping) %otherwise, this history...
        %will more efficiently be constructed within...
        %"RegPSO_load_grouping_data.m" rather than needing to be...
        %initialized here.
        MPSO_range_IS_per_grouping = [MPSO_range_IS_per_grouping; range_IS(1, :)];
    end
end
if OnOff_MPSO || (~OnOff_Autosave_Workspace_Per_Grouping)
       %* If MPSO is active and WS are saved per grouping, data per
        % RegPSO grouping are amassed into MPSO histories over all
        % groupings.  It may be beneficial for debugging as well as
        % convenient for analysis to maintain such histories over each
        % execution of RegPSO as well
        % => if OnOff_MPSO && OnOff_Autosave_Workspace_Per_Grouping,
        % maintain RegPSO hist's.
       %* If MPSO is active but WS from which to construct
        % histories of final values per grouping by which to assess the
        % effectiveness of each regrouping are not saved per grouping,
        % histories of final values per grouping should be maintained - whether MPSO is active or not
        % => if OnOff_MPSO && ~OnOff_Autosave_Workspace_Per_Grouping, maintain RegPSO & MPSO hist's here
       %* If MPSO is inactive and WS from which to construct
        % histories of final values per grouping by which to assess the
        % effectiveness of each regrouping are not saved per grouping,
        % histories of final values per grouping should be maintained
        % across the RegPSO trial.
        % => if ~OnOff_MPSO && ~OnOff_Autosave_Workspace_Per_Grouping,
        % maintain RegPSO hist's here)
       %* "if (OnOff_MPSO && OnOff_Autosave_Workspace_Per_Grouping) ||(OnOff_MPSO && ~OnOff_Autosave_Workspace_Per_Grouping) || (~OnOff_MPSO && ~OnOff_Autosave_Workspace_Per_Grouping)"
        %logically simplifies to "if OnOff_MPSO || (~OnOff_Autosave_Workspace_Per_Grouping)"
        % => (i)  if OnOff_MPSO || ~OnOff_Autosave_Workspace_Per_Grouping, maintain RegPSO hist's here;
        %    (ii) if OnOff_MPSO && ~OnOff_Autosave_Workspace_Per_Grouping is also true, maintain MPSO hist's here
       %* Some additional specifics apply to certain histories.
    if OnOff_fg_after_each_grouping
        if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping)
            MPSO_fg_after_each_grouping = [MPSO_fg_after_each_grouping, fg];
        end
        %If the worskpace is saved per grouping, this can be
        %constructed at the end of the trial from each
        %grouping's "fg."
        RegPSO_fg_after_each_grouping = [RegPSO_fg_after_each_grouping, fg];
    end
    if OnOff_k_after_each_grouping
        %If the workspace is saved per grouping,
        %"MPSO_k_after_each_grouping"
        %will be constructed more efficiently within
        %"RegPSO_load_grouping_data.m" rather than needing to be maintained
        %here.  However, if MPSO is active, it may be beneficial to
        %maintain the "RegPSO_k_after_each_grouping" over each RegPSO execution within an
        %MPSO trial as well as reconstructing "MPSO_k_after_each_grouping" over all
        %MPSO groupings spanning multiple trials.
        if OnOff_MPSO && (~OnOff_Autosave_Workspace_Per_Grouping)
            MPSO_k_after_each_grouping = [MPSO_k_after_each_grouping, MPSO_k + RegPSO_k];
        end
        RegPSO_k_after_each_grouping(RegPSO_grouping_counter) = RegPSO_k; %"RegPSO_k_after_each_grouping" is a matrix of order "num_trials" by #
    end %of groupings implemented.  It holds the iteration numbers AT which RegPSO regrouped and exists purely
        %for user analysis.
end