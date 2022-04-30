
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OnOff_Tricias_NN_training = logical(0); %If set to 1 then this PSO Research toolbox is not executed directly by user, but linked to a NN training function.
    % (Activate the switch above to use Tricia's NN training add-in
    %- downloaded separately from mathworks.com).
if ~OnOff_Tricias_NN_training%Only clear and close objects if PSO not used for NN training
    clc %Clear the command window.
    close all %Close all open figures.
    clear all %"removes all variables, globals, functions and MEX links"
        %from the workspace to prevent data created by an earlier execution
        %of the program from potentially affecting new executions.
    OnOff_Tricias_NN_training = logical(0); %Set to 0 again after clearing all variables.
end

%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(1) BASIC SWITCHES & PSO ALGORITHM SELECTION%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %PSO DATA TO BE RETAINED & SAVED%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MATLAB suggests using TRUE and FALSE rather than logical(1/0); however,
    %it is more efficient for the user to change between 1's and 0's to 
    %activate and de-activate switches than between TRUE's and FALSE's.
OnOff_Autosave_Workspace_Per_Grouping = logical(1); %If activated, trial
    %data will be constructed from grouping data, which generally reduces
    %execution time.
OnOff_Autodelete_Grouping_Data = logical(1); %Delete grouping data after
    %reconstrucing trial data to use space on the hard disk more
    %cautiously.
OnOff_Autosave_Workspace_Per_Trial = logical(1); %Used to reconstruct data
    %over all trials, which generally reduces execution time.
OnOff_Autodelete_Trial_Data = logical(1); %Delete trial data after
    %computing stat's to use space on the hard disk more cautiously.
OnOff_Autosave_Workspace_Per_Column = logical(1); %The workspace can be
    %auto-saved after each column, table, or both for later analysis.
OnOff_Autosave_Workspace_Per_Table = logical(1); %(see comment above)
    %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %TERMINATION CRITERIA FOR REGPSO & PSO ALGORITHMS%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OnOff_NormR_stag_det = logical(0); %Option to use Van den Bergh's
    % normalized swarm radius detection and search termination.
    % "The normalized swarm radius convergence detection technique was
    % found in Van den Bergh's PhD thesis to outperform the cluster
    % analysis and objective function slope techniques, which stands to
    % reason since close proximity of the particles to each other is the
    % cause of stagnation in the sense that no better function values can
    % be achieved by which to improve the global best when no other region
    % of the search space is being explored."
OnOff_func_evals = logical(0); %Function evaluations rather than iterations
    %are used when this switch is active and vice versa when it is
    %inactive.  Function evaluations allow for more straightforward
    %comparisons across a wide range_IS of algorithms.
    %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %REGPSO & PSO SUCCESS MEASURES%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OnOff_SuccessfulUnsuccessful = logical(1); %When switch 
    %"OnOff_SuccessfulUnsuccessful" is activated,
    %each trial will be classified as successful or unsuccessful.  In some
    %cases, users may only be interested in the statistics resulting from
    %the trials conducted and may not be interested in classifying trials
    %as successful or unsuccessful; but the feature can be a useful way of
    %tracking outliers since any function value larger than the threshold
    %for success as set in "Objectives.m" will be classified as
    %unsuccessful, thereby essentially counting the number of outliers.
if OnOff_SuccessfulUnsuccessful
    OnOff_iter_success = logical(1); %Do you wish to keep a history of the
        %iteration # at which each trial reached success?
    OnOff_Terminate_Upon_Success = logical(0); %Do you wish to terminate
        %the search upon reaching the threshold called success?  Leave the
        %switch de-activated if you want all trials to run for the
        %specified number of iterations or function evaluations instead of
        %terminating when the function value reaches the threshold for
        %success, "thresh_for_succ."
end
    %$%%%%%%%%%%%%%%%%%%%%%%%
    %PSO ALGORITHM SELECTION%
    %%%%%%%%%%%%%%%%%%%%%%%%%
OnOff_lbest = logical(1); %Activates Lbest PSO instead of Gbest PSO as the
    %core algorithm.
if OnOff_lbest
    lbest_neighb_size = 2;
end
OnOff_w_linear = logical(1); %Turn time-varying inertia weight on or off.
OnOff_v_clamp = logical(1); %Turn velocity clamping on or off.
OnOff_v_reset = logical(0); %With this feature activated, if any dimension
    %of a particle leaves the search space, its corresponding velocity
    %component will be set to zero and its position recalculated.
OnOff_position_clamping = logical(0); %This feature is intended to clamp
    %positions to the search space the same way velocity clamping clamps
    %velocities to the search space.  It may not be as effective as
    %velocity reset above, but I have not verified as much.
OnOff_RegPSO = logical(0); %This switch activates Regrouping PSO (RegPSO),
    %which regroups the swarm efficiently about the global best according
    %to the uncertainty seen on each dimension when stagnation is detected.
    %For more information, please see http://www.georgeevers.org.
%I was experimenting with a second regrouping method that
%I never perfected during thesis and abandoned due to time constraints.
%The user does not need to be concerned with it.  The switch above is
%converted below to the "Reg_Method" expected by the program, which is
%preserved to allow me the flexibility to try the second method using the
%same toolbox rather than applying all changes to two versions of the
%toolbox.
if OnOff_RegPSO
    Reg_Method = 1;
else
    Reg_Method = 0;
end
OnOff_GCPSO = logical(0);
if OnOff_GCPSO %When GCPSO is active, create the thresholds that when
   %surpassed by the number of consecutive successes or failures cause
   %"GCPSO_r" to be doubled or halved respectively.
   GCPSO_threshold_num_successes = 15; %15 recommended in "A New Locally
    %Convergent Particle Swarm Optimiser"
   GCPSO_threshold_num_failures = 5; %5 recommended in the same
end
OnOff_MPSO = logical(0); %Activate multi-start PSO (MPSO).
if OnOff_MPSO
    OnOff_MPSO_zhist = logical(1);
    MPSO_max_starts = 2; %This allows the user to specify a maximum
        %number of starts.  To terminate after a pre-specified number
        %of function evaluations or iterations instead, set this
        %to a very large number.
    if OnOff_func_evals
        MPSO_max_FEs = 2000000;
    else
        MPSO_max_iters = 100000;
    end
end
OnOff_OPSO = logical(0); %Turn on opposition-based PSO.
    %Note that the personal best of particle "i" as plotted on the swarm
    %trajectory is the best of particle "i" and its ghost.
if OnOff_OPSO
    p0 = 0.5; %Set the opposition probability (0.5 worked best in Wang 2007)
end
OnOff_Cauchy_mutation_of_global_best = logical(0); %as used in
    %(Wang 2007) with OPSO except that they mis-state
    %this to be a perturbation of the globally "best particle," which is
    %quite different from mutating the global best as done in their
    %equations (1) & (9) as well as their pseudo code, and which makes
    %more sense than perturbing an actual particle.
    %%%%%%%%%%%%%%%%%%%%%%%%
    %MISCELLANEOUS FEATURES%
    %%%%%%%%%%%%%%%%%%%%%%%%
OnOff_user_input_validation_required = logical(1);
    %When this switch is active, the user will be given the opportunity to
    %verify that certain displayed settings are correct before data is
    %generated.
OnOff_progress_meter = logical(1); %Turns progress meter on or off.
OnOff_asymmetric_initialization = logical(0);
    %This switch activates asymmetric initialization, which modifies the
    %initialization space by setting xmin = xmax/2 on benchmarks instead of
    %xmin = -xmax.  The idea is to increase the difficulty of locating the
    %global minimizer.  This tests the effectiveness of the optimization
    %algorithm at finding solutions that might inadvertently be excluded
    %from the initialization space should the algorithm be applied to
    %problems whose solutions are unknown.
    %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %PSO HISTORIES TO BE MAINTAINED%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %(Caution: Enabling histories consumes extra memory and consequently
        %slows execution speed.)
OnOff_fghist = logical(0); %Record the FUNCTION VALUES OF GLOBAL
    %BEST (i.e. best location in memory).
OnOff_ghist = logical(1); %Record each iteration's global best.
if OnOff_lbest %i.e. if Lbest PSO has been activated
    OnOff_lhist = logical(1); %Record each iteration's local bests.
end
OnOff_fphist = logical(0); %Record the function values at the
    %personal bests.
OnOff_phist = logical(1); %Record the personal bests.
OnOff_fhist = logical(1); %Record all function values (reset with
    %each new grouping).
OnOff_xhist = logical(0); %Maintain matrix "xhist" (reset with each new
    %grouping).
OnOff_vhist = logical(1); % Maintain a history of all velocities (current
    %grouping only).
OnOff_v_cog_hist = logical(0); %Maintain a history of the cognitive
    %velocity components.
OnOff_v_soc_hist = logical(0); %Maintain a history of the social velocity
    %components.
    
%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(2) PARTICLE SWARM ALGORITHM SETTINGS%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if OnOff_Tricias_NN_training
    num_trials = 1; %For NN training, this should always be set to 1
else % i.e. if ~OnOff_Tricias_NN_training
    num_trials = 1; %Specify the # of trials per column here if ANN training is not in use.
end
vmax_perc = .5; %Set the percentage of the range to which each dimension
    %should be clamped.  50% is traditional as it sets vmax = xmax for 
    %objectives whose search spaces are centered at the origin of
    %Euclidean space; however, 15% was recommended by Liu and seems to
    %perform better in general than 50% as per Tables II-1 & II-2 in
    %Chapter II of thesis at http://www.georgeevers.org/thesis.pdf
global dim %The problem dimensionality is used within some objective 
    %functions to improve efficiency over passing the information in
    %iteratively ("dim" is unchanged within the function).
if OnOff_Tricias_NN_training
    dim = length(NN_wb);  %dim set from number of NN weights and biases passed in
else % i.e.  if ~OnOff_Tricias_NN_training
    dim = 2; %Specify the number of dimensions characterizing the search space.
end
np = 5; %Set the number of particles.
c1 = 1.49618; %Set the acceleration constants.
c2 = 1.49618;
if OnOff_w_linear %i.e. if inertia weight is time-varying
    w_i = 0.9; %initial value used in first velocity update
    w_f = 0.4; %final value used in final velocity update
else %i.e. if a static inertia weight is desired
    w = 0.72984;
end
if OnOff_func_evals
    max_FEs_per_grouping = 200; %Set the maximum # of function evaluations
			%to be allowed per grouping.
		%To conduct 2000 iterations, for example, one could set this to
            %np*2000.
		%When switch "OnOff_RegPSO = logical(0),"
			%this is the maximum total number of function evaluations to
            %be allowed.
		%When switch "OnOff_RegPSO = logical(1),"
			%this is the maximum number of function evaluations allowed per
			%RegPSO grouping.
    if OnOff_w_linear %"max_iter_per_grouping" needed to step inertia weight
        max_iter_per_grouping = max_FEs_per_grouping/np;
    end
else %i.e. if iterations are to be monitored as a termination criterion instead of
		%function evaluations, which occurs when switch "OnOff_func_evals" is inactive.
    max_iter_per_grouping =  35; %Set the maximum number of iterations per grouping.
		%When switch "OnOff_RegPSO = logical(0),"
			%this is the maximum total number of iterations to be allowed.
		%When switch "OnOff_RegPSO = logical(1),"
			%this is the maximum number of iterations allowed per RegPSO grouping.
end
format short e; %Short engineering format is useful for function values
    %very near zero, but any format can be specified here.  Type "help
    %format" if you would like to see more options.
    
%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(3) REGPSO ALGORITHM SWITCHES & SETTINGS%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %$%%%%%%%%%%%%%%%%%%%%%%%%%
    %REGPSO ALGORITHM SWITCHES%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
if Reg_Method ~= 0 %Input validation beneficial before proceeding
    %This utilizes Van den Bergh's normalized swarm radius criterion,
    %used by RegPSO in case the user forgets to activate it above.
    OnOff_NormR_stag_det = logical(1);% DO NOT CHANGE: only input validation
end
if OnOff_NormR_stag_det
    %Set the stagnation threshold for the normalized swarm radius
        %termination criterion. "stag_thresh" is
        %listed here for convenience since it is predominantly a regrouping
        %parameter, though it can be used with standard PSO as well to
        %terminate the search when particles have prematurely converged.
    stag_thresh = 1.1*10^(-4);
    %stag_thresh = 10^(-25); %to prevent stagnation on uni-modal functions.
    %stag_thresh = 10^(-6); %other options for general use.
    %stag_thresh = 10^(-3);
end
if Reg_Method ~= 0
    OnOff_range_IS_per_grouping = logical(1); %Option to record the "range_IS"
        %used for each grouping.  From this, each regrouping space (i.e. the
        %initialization space within which particles regroup when premature
        %convergence is detected) can be reconstructed.  When premature
        %convergence is detected, the swarm regroups within this "range_IS"
        %about the global best of the previous grouping.
    OnOff_k_after_each_grouping = logical(1); % Records the final update
        %number per grouping.
    OnOff_fg_after_each_grouping = logical(1); %Maintains a history of
        %function values at the update numbers stored in
        %"RegPSO_k_after_each_grouping." Note: If data is saved per grouping,
        %this will be reconstructed from the final "fg" of each grouping.
        %Otherwise, this should be contributed to throughout main and cleared
		%with each new trial.
    OnOff_g_after_each_grouping = logical(1); % Maintains a history of the
        %global bests prior to each regrouping.
    OnOff_see_data_per_grouping = logical(0); %displays final data per grouping:
		%fg, reg_fact, stag_thresh, g, range_IS, #FE's
    OnOff_num_gs_identical_b4_refinement = logical(0); %inactive by default
    %$%%%%%%%%%%%%%%%%%%%%%%%%%
    %REGPSO ALGORITHM SETTINGS%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if OnOff_num_gs_identical_b4_refinement
        num_gs_identical_b4_refinement = 50; %Over how many groupings should the
            %rounded values of returned global bests possibly be identical before
            %beginning solution refinement?  (Note: This is not a standard feature
			%of RegPSO - just something with which I've been experimenting.)
        reg_reduction_factor = 1.01; %This is the factor by which range_IS will be
            %divided in order to reduce the search space once it is suspected that
            %the global minimum has been encountered.
    end
    if Reg_Method == 1
        reg_fact = 1.2/stag_thresh; %Set RegPSO's regrouping factor (applies when "max_num_groupings" > 1).
        %reg_fact = 50; (Smaller scalar values are better for some unimodal problems)
        %reg_fact = 12*10^5;
            %Note: If you received error "??? Undefined function or variable 'stag_thresh',"
            %it is probably because you have selected "Reg_Method == 1" without activating
            %"OnOff_NormR_stag_det."  If this error warning directed you to this part of
			%the code, press Ctrl + F, search within this file for comment
			%"DO NOT CHANGE: only input validation" above, and set the corresponding
			%variable to logical(1).  This value should not be changed.
    end
    if OnOff_func_evals
        max_FEs_over_all_groupings = 300; %Option to specify a maximum #
			%of RegPSO function evaluations per trial.
        %max_FEs_over_all_groupings = 281*np; 
    else %i.e. if iterations are to be used instead of function evaluations
        max_iter_over_all_groupings = 250; %Option to specify a maximum # of
			%RegPSO iterations per trial.
    end
    max_num_groupings = 99999999; %This parameter need only be set if Reg_Method ~= 0
		%(i.e. if regrouping is to be used).  It is used in all cases when saving
		%data to automatically generated filenames: in the standard case it is
        %automatically changed below to 1 for standard PSO or "max_num_groupings" + 1
		%for case Reg_Method == 2.  The maximum # of (Reg_Method = 1) groupings per
		%trial is one more than the number of regroupings; hence, for standard PSO
		%(without regrouping), "max_num_groupings" = 1.  Note: Not included in file
		%names (of saved data) when >= 99999999, which allows for shorter names.
end

%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(4) TABLE SWITCHES & SETTINGS%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section is available only in the professional version of the PSO
    % Research Toolbox; it allows the automatic incrementing of objectives
    % and parameters between sets of trials.

%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(5) REGPSO & PSO GRAPHING SWITCHES AND SETTINGS%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OnOff_graphs = logical(1); %Turn graphing on or off (When "1," the switches below take effect).
if OnOff_graphs %When this switch is inactive, the switches below will not clutter the workspace.
    %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %REGPSO & PSO GRAPHING SWITCHES: ON (1), OFF (0)%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    OnOff_graph_fg_mean = logical(1); %Mean function value of global best
        %over multiple trials.
    %TWO-D CASE ONLY
    OnOff_swarm_trajectory = logical(0); %Swarm Trajectory (selected swarm states from
        %initial to final: only executed for now when dim = 2)
    OnOff_graph_ObjFun_f_vs_2D = logical(1); %3D plot of the function value at each 2D location
    %TWO-D & SINGLE TRIAL CASE ONLY
    OnOff_phase_plot = logical(1); %Phase Plot per Particle (only executed for now when dim = 2)
    %SINGLE TRIAL ONLY (i.e. These settings only take effect if "num_trials == 1")
    OnOff_graph_fg = logical(0); %Graph objective function's value for each iteration number's global best
    OnOff_graph_g = logical(0); %Graph History of the Global Best
    OnOff_graph_p = logical(0); %Graph History of Personal Best per Particle
    OnOff_graph_f = logical(0); %Graph History of Obj. Function Value by Particle
    OnOff_graph_x = logical(1); %Graph History of Decision Variables per Particle
    OnOff_graph_v = logical(0); %Graph Velocity History per Particle
    %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %REGPSO & PSO GRAPHING SETTINGS%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    OnOff_title = logical(1); %Would u like to have title displayed (0=No, 1=Yes)?
    OnOff_semilogy = logical(0); %Use a logarithmic scale for the y axis.
    OnOff_reuse_figures = logical(0); %Prevent memory flooding by
        %re-using the same figure.
    OnOff_autosave_figs = logical(1); %Saves figures in *.fig format.
    OnOff_autosave_figures_to_another_format = logical(1); %Saves figures in format
        %"GraphParams_autosave_format" specified below.
    if OnOff_autosave_figures_to_another_format
        GraphParams_autosave_format = 'png'; %Specify the desired format.
        %SUPPORTED FORMATS
        % ai:	Adobe® Illustrator `88
        % bmp:	Windows bitmap
        % emf:	Enhanced metafile
        % eps:	EPS Level 1
        % fig:	MATLAB figure (invalid for Simulink block diagrams)
        % jpg:	JPEG image (invalid for Simulink block diagrams)
        % m:	MATLAB M-file (invalid for Simulink block diagrams)
        % pbm:	Portable bitmap
        % pcx:	Paintbrush 24-bit
        % pdf:	Portable Document Format
        % pgm:	Portable Graymap
        % png:	Portable Network Graphics
        % ppm:	Portable Pixmap
        % tif:	TIFF image, compressed
    end
    OnOff_Close_All_Graphs = logical(0); %Option to close all graphs at completion
        %(e.g. after watching particles on the contour map over many figures)
    Figure_Position = [1 76 1920 1058];
        %To set the ideal figure position for automatically
            %displaying figures to your screen:
        %(1) Type "figure(1)" at MATLAB's command prompt.
        %(2) Resize the figure to assume the size and location
            %on the screen desired for automatically generated
            %figures: for best display, this is the maximized size.
        %(3) At the command prompt, type or paste "get(figure(1), 'Position')" 
            %If you maximized the figure in step 2, this method accounts
            %for the space occupied by all Taskbars such as those used by 
            %Windows and Office (i.e. same as "get(0,'ScreenSize')"
            %except that space is reserved for all menu bars).
        %(4) The result is the 1X4 vector to be used as
            %"Figure_Position" above.
    GraphParams_labeltitle_font_size = 40; %Determine font size used for labels and titles.
        %suggested: 40
    GraphParams_axes_font_size = 35; %Determine size of font used for axes values
        %suggested: 35, 20, 12 depending on application
    GraphParams_marker_size = 40; %Determine size of marker on graph
        %suggbested: 40, 25, 6 depending on application
    GraphParams_text_font_size = 30; %Size of font used to display particle #'s inside circle
        %suggbested: 30, 15 depending on application
    if OnOff_swarm_trajectory || OnOff_graph_ObjFun_f_vs_2D || OnOff_phase_plot
        GraphParams_meshgrid_quality = 450; %High values offer contour map
            %curves of high quality but slow graphing considerably and can cause
            %an "out of memory" termination error over many iterations.
            %Recommended range_IS: 20 for quick testing, 450+ for
            %figures to be published
        if OnOff_swarm_trajectory
            OnOff_contourf = logical(1); %Set this TRUE if a colored contour map
                %is desired; set it FALSE if only contour lines are desired.
                %The former is more aesthetically pleasing, but the latter
                %may be more appropriate for black and white printing.
            OnOff_zoom_on_final_graph = logical(1); %Show exact swarm
            %GraphParams_max_num_swarm_state_snapshots_per_grouping = 20; %Set >= 2
				%(for first and last iterations).
            GraphParams_snapshot_per_how_many_iterations = 10; %A shapshot
                %will be taken at least every ... iterations.
            GraphParams_line_width = 2; %Determine width of line around particle markers.
                %suggested width: 2
            OnOff_plot_indices = logical(1); %Plot particles' index numbers.
            OnOff_plot_box_4_new_search_space = logical(1);
            if OnOff_plot_box_4_new_search_space
                GraphParams_fraction_of_line_width = 0.0543;
            end %Without "GraphParams_fraction_of_line_width," the line segments drawn would
                %not overlap at the corners to forma proper rectangle.  To remedy
                %this, the segments can be extended by some fraction of the line
                %width in so that line segments overlap well at the corners.
            OnOff_mark_personal_bests = logical(1); %Activate to mark the
                %locations of personal bests on the contour map.
            OnOff_mark_global_best_always = logical(1); %Activate to mark the
                %location of the global best on the contour map.
            OnOff_mark_global_best_on_zoomed_graph = logical(1); %Activate to mark
                %the location of the global best on the zoomed contour map.
                %distribution at stagnation (1), Off (0).
            GraphParams_swarm_traj_snapshot_mode = 4;
                % 0: Each iteration's snapshot will zoom in on the swarm at
                    % that iteration.
                % 1: All snapshots within each grouping use the same contour map.
                % 2: All snapshots across all groupings use the same
                    % contour map.
                % 3: To reduce the likelihood of any particle leaving the
                    %contour map generated, the boundaries of the search
                    %space are used rather than particle positions to
                    %generate the initial contour map.
                % 4: To be more conservative, the contour map can be
                    %generated over an area larger than the search space
                    %since particles are generally not constrained to lie
                    %within it. This option uses "GraphParams_SwarmTrajMode4Factor"
                    %below and is recommended.
                % Note: These approaches are listed in the order in which
                    %they were developed and used.
            if GraphParams_swarm_traj_snapshot_mode == 4
                %Setting this factor less than 2 results in a contour map
                    %larger than the intended search space.
                GraphParams_SwarmTrajMode4Factor = 1.6;
            end %suggested values: 1.6 - 1.8
        end
    end
end

%$%%%%%%%%%%%%%%
%(6) OBJECTIVES%
%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This paragraph copyright 2010, 2011, 2012 Tricia Rambharose
%   Created on: 2010/09/18
%   info@tricia-rambharose.com
%Neural Network training checks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if OnOff_Tricias_NN_training
    objective_id = 11; %This must be set to 11 for NN training
    %goal = evalin('caller','goal'); %get NN training goal from interface function    
    true_global_minimum = net.trainParam.goal; %This set to the NN training goal.
else %if ~OnOff_Tricias_NN_training
    
    objective_id = 1;
    %If you will use only one objective, set the objective
    %id equal to the objective in "Objectives.m" that you want
    %to use.  If you will be incrementing the objective per table, set
    %"objective_id" to 0 since it will increment each time "Objectives.m"
    %is called - implementing firstly the objective to which id 1 is
    %assigned and then id's 2, 3, 4, and so on.  Objective incrementing is
    %only available in the professional version of the toolbox.

    true_global_minimum = 0;
    %The search will terminate upon reaching this value exactly
    %Note: f<10^(-323) is indiscernible from true 0 in MATLAB
    %(used only in "while" header -- not available to particles for
    %consideration).
end

Objectives %This script associates handle "ObjFun" with the
    %appropriate objective and loads the appropriate initialization space,
    %search space, and threshold for success.

% Please press "F5" to begin program execution.