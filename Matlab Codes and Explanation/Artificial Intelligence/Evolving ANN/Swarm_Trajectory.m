
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Swarm Trajectory (Activated When "OnOff_swarm_trajectory == true")%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_2 vs x_1 (only generated if dim = 2)
%close all
if (OnOff_plot_box_4_new_search_space) && (RegPSO_k ~= 0) %If box showing new search space is to be drawn.
    upper_borders = RegPSO_g_after_each_grouping(RegPSO_grouping_counter - 1, :) + range_IS(1, :)/2;
    lower_borders = RegPSO_g_after_each_grouping(RegPSO_grouping_counter - 1, :) - range_IS(1, :)/2;
end %Calculate these now so that X1, X2, and Z can account for the box when it moves outside the original search space -
    %such as when asymmetric initialization is used.
if GraphParams_swarm_traj_snapshot_mode == 1; %{0, 1, 2, 3, 4} are possible.
        % If contour map is constant per grouping (but not over all groupings as in case 2),
        % then generate the meshgrid based on "xhist" of grouping that just finished.
    %Set min & max on each dimension then generate a meshgrid.
    if (OnOff_plot_box_4_new_search_space) && (RegPSO_k ~= 0)
        % These definitions account for the regrouping box
            % if it is to be drawn.
        Internal_GraphParams_dim1min = min(min(xhist(:, 1:2:size(xhist, 2))), lower_borders(1)); %2*0+1 = 1st column (iter 0, 1st dim), 
        Internal_GraphParams_dim1max = max(max(xhist(:, 1:2:size(xhist, 2))), upper_borders(1)); %2*1+1 = 3rd column (1st iter, 1st dim)
        Internal_GraphParams_dim2min = min(min(xhist(:, 2:2:size(xhist, 2))), lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width); %2*0+1 = 1st column (iter 0, 2nd dim),
        Internal_GraphParams_dim2max = max(max(xhist(:, 2:2:size(xhist, 2))), upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width); %2*1+1 = 3rd column (1st iter, 2nd dim)
    else
        Internal_GraphParams_dim1min = min(xhist(:, 1:2:size(xhist, 2))); %2*0+1 = 1st column (iter 0, 1st dim), 
        Internal_GraphParams_dim1max = max(xhist(:, 1:2:size(xhist, 2))); %2*1+1 = 3rd column (1st iter, 1st dim)
        Internal_GraphParams_dim2min = min(xhist(:, 2:2:size(xhist, 2))); %2*0+1 = 1st column (iter 0, 2nd dim),
        Internal_GraphParams_dim2max = max(xhist(:, 2:2:size(xhist, 2))); %2*1+1 = 3rd column (1st iter, 2nd dim)
    end
    f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.
elseif GraphParams_swarm_traj_snapshot_mode == 3; %{0, 1, 2, 3, 4} are possible.
    if (OnOff_plot_box_4_new_search_space) && (RegPSO_k ~= 0)
        % These definitions account for the regrouping box
            % if it is to be drawn.
        if size(center_IS0, 2) == 1
            if size(range_IS, 2) == 1
                Internal_GraphParams_dim1min = min(center_IS - range_IS/2, lower_borders(1));
                Internal_GraphParams_dim1max = max(center_IS + range_IS/2, upper_borders(1));
                Internal_GraphParams_dim2min = min(center_IS - range_IS/2, lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width);
                Internal_GraphParams_dim2max = max(center_IS + range_IS/2, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width);
            else %i.e. range_IS was specified as a vector or matrix - implying that
                %it may not be the same on each dimension
                Internal_GraphParams_dim1min = min(center_IS - range_IS(1, 1)/2, lower_borders(1));
                Internal_GraphParams_dim1max = max(center_IS + range_IS(1, 1)/2, upper_borders(1));
                Internal_GraphParams_dim2min = min(center_IS - range_IS(1, 2)/2, lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width);
                Internal_GraphParams_dim2max = max(center_IS + range_IS(1, 2)/2, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width);
            end
        else %i.e. center_IS0 was specified as a vector or matrix - implying that
            %it may not be the same on each dimension
            if size(range_IS, 2) == 1
                Internal_GraphParams_dim1min = min(center_IS(1, 1) - range_IS/2, lower_borders(1));
                Internal_GraphParams_dim1max = max(center_IS(1, 1) + range_IS/2, upper_borders(1));
                Internal_GraphParams_dim2min = min(center_IS(1, 2) - range_IS/2, lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width);
                Internal_GraphParams_dim2max = max(center_IS(1, 2) + range_IS/2, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width);
            else %i.e. range_IS was specified as a vector or matrix - implying that
                %it may not be the same on each dimension
                Internal_GraphParams_dim1min = min(center_IS(1, 1) - range_IS(1, 1)/2, lower_borders(1));
                Internal_GraphParams_dim1max = max(center_IS(1, 1) + range_IS(1, 1)/2, upper_borders(1));
                Internal_GraphParams_dim2min = min(center_IS(1, 2) - range_IS(1, 2)/2, lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width);
                Internal_GraphParams_dim2max = max(center_IS(1, 2) + range_IS(1, 2)/2, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width);
            end
        end
    else
        if size(center_IS0, 2) == 1
            if size(range_IS, 2) == 1
                Internal_GraphParams_dim1min = center_IS - range_IS/2;
                Internal_GraphParams_dim1max = center_IS + range_IS/2;
                Internal_GraphParams_dim2min = center_IS - range_IS/2;
                Internal_GraphParams_dim2max = center_IS + range_IS/2;
            else %i.e. range_IS was specified as a vector or matrix - implying that
                %it may not be the same on each dimension
                Internal_GraphParams_dim1min = center_IS - range_IS(1, 1)/2;
                Internal_GraphParams_dim1max = center_IS + range_IS(1, 1)/2;
                Internal_GraphParams_dim2min = center_IS - range_IS(1, 2)/2;
                Internal_GraphParams_dim2max = center_IS + range_IS(1, 2)/2;
            end
        else %i.e. center_IS0 was specified as a vector or matrix - implying that
            %it may not be the same on each dimension
            if size(range_IS, 2) == 1
                Internal_GraphParams_dim1min = center_IS(1, 1) - range_IS/2;
                Internal_GraphParams_dim1max = center_IS(1, 1) + range_IS/2;
                Internal_GraphParams_dim2min = center_IS(1, 2) - range_IS/2;
                Internal_GraphParams_dim2max = center_IS(1, 2) + range_IS/2;
            else %i.e. range_IS was specified as a vector or matrix - implying that
                %it may not be the same on each dimension
                Internal_GraphParams_dim1min = center_IS(1, 1) - range_IS(1, 1)/2;
                Internal_GraphParams_dim1max = center_IS(1, 1) + range_IS(1, 1)/2;
                Internal_GraphParams_dim2min = center_IS(1, 2) - range_IS(1, 2)/2;
                Internal_GraphParams_dim2max = center_IS(1, 2) + range_IS(1, 2)/2;
            end
        end
    end
    f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.
elseif GraphParams_swarm_traj_snapshot_mode == 4;
    if (OnOff_plot_box_4_new_search_space) && (RegPSO_k ~= 0)
        % These definitions account for the regrouping box
            % if it is to be drawn.
        if size(center_IS0, 2) == 1
            if size(range_IS, 2) == 1
                Internal_GraphParams_dim1min = min(center_IS - range_IS/GraphParams_SwarmTrajMode4Factor, lower_borders(1));
                Internal_GraphParams_dim1max = max(center_IS + range_IS/GraphParams_SwarmTrajMode4Factor, upper_borders(1));
                Internal_GraphParams_dim2min = min(center_IS - range_IS/GraphParams_SwarmTrajMode4Factor, lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width);
                Internal_GraphParams_dim2max = max(center_IS + range_IS/GraphParams_SwarmTrajMode4Factor, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width);
            else %i.e. range_IS was specified as a vector or matrix - implying that
                %it may not be the same on each dimension
                Internal_GraphParams_dim1min = min(center_IS - range_IS(1, 1)/GraphParams_SwarmTrajMode4Factor, lower_borders(1));
                Internal_GraphParams_dim1max = max(center_IS + range_IS(1, 1)/GraphParams_SwarmTrajMode4Factor, upper_borders(1));
                Internal_GraphParams_dim2min = min(center_IS - range_IS(1, 2)/GraphParams_SwarmTrajMode4Factor, lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width);
                Internal_GraphParams_dim2max = max(center_IS + range_IS(1, 2)/GraphParams_SwarmTrajMode4Factor, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width);
            end
        else %i.e. center_IS0 was specified as a vector or matrix - implying that
            %it may not be the same on each dimension
            if size(range_IS, 2) == 1
                Internal_GraphParams_dim1min = min(center_IS(1, 1) - range_IS/GraphParams_SwarmTrajMode4Factor, lower_borders(1));
                Internal_GraphParams_dim1max = max(center_IS(1, 1) + range_IS/GraphParams_SwarmTrajMode4Factor, upper_borders(1));
                Internal_GraphParams_dim2min = min(center_IS(1, 2) - range_IS/GraphParams_SwarmTrajMode4Factor, lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width);
                Internal_GraphParams_dim2max = max(center_IS(1, 2) + range_IS/GraphParams_SwarmTrajMode4Factor, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width);
            else %i.e. range_IS was specified as a vector or matrix - implying that
                %it may not be the same on each dimension
                Internal_GraphParams_dim1min = min(center_IS(1, 1) - range_IS(1, 1)/GraphParams_SwarmTrajMode4Factor, lower_borders(1));
                Internal_GraphParams_dim1max = max(center_IS(1, 1) + range_IS(1, 1)/GraphParams_SwarmTrajMode4Factor, upper_borders(1));
                Internal_GraphParams_dim2min = min(center_IS(1, 2) - range_IS(1, 2)/GraphParams_SwarmTrajMode4Factor, lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width);
                Internal_GraphParams_dim2max = max(center_IS(1, 2) + range_IS(1, 2)/GraphParams_SwarmTrajMode4Factor, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width);
            end
        end
    else
        if size(center_IS0, 2) == 1
            if size(range_IS, 2) == 1
                Internal_GraphParams_dim1min = center_IS - range_IS/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim1max = center_IS + range_IS/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim2min = center_IS - range_IS/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim2max = center_IS + range_IS/GraphParams_SwarmTrajMode4Factor;
            else %i.e. range_IS was specified as a vector or matrix - implying that
                %it may not be the same on each dimension
                Internal_GraphParams_dim1min = center_IS - range_IS(1, 1)/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim1max = center_IS + range_IS(1, 1)/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim2min = center_IS - range_IS(1, 2)/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim2max = center_IS + range_IS(1, 2)/GraphParams_SwarmTrajMode4Factor;
            end
        else %i.e. center_IS0 was specified as a vector or matrix - implying that
            %it may not be the same on each dimension
            if size(range_IS, 2) == 1
                Internal_GraphParams_dim1min = center_IS(1, 1) - range_IS/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim1max = center_IS(1, 1) + range_IS/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim2min = center_IS(1, 2) - range_IS/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim2max = center_IS(1, 2) + range_IS/GraphParams_SwarmTrajMode4Factor;
            else %i.e. range_IS was specified as a vector or matrix - implying that
                %it may not be the same on each dimension
                Internal_GraphParams_dim1min = center_IS(1, 1) - range_IS(1, 1)/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim1max = center_IS(1, 1) + range_IS(1, 1)/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim2min = center_IS(1, 2) - range_IS(1, 2)/GraphParams_SwarmTrajMode4Factor;
                Internal_GraphParams_dim2max = center_IS(1, 2) + range_IS(1, 2)/GraphParams_SwarmTrajMode4Factor;
            end
        end
    end
    f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.
end
%Check to ensure that the figure generated at iteration "k" is included but not repeated.
if mod(k, GraphParams_snapshot_per_how_many_iterations) == 0
    Set = 0:GraphParams_snapshot_per_how_many_iterations:k;
else
    Set = [0:GraphParams_snapshot_per_how_many_iterations:k,k];
end

for m = Set
    if OnOff_reuse_figures
        Internal_GraphParams_cur_fig_handle = figure(1000);
    else
        if RegPSO_grouping_counter == 1
            Internal_GraphParams_cur_fig_handle = figure(MPSO_k + RegPSO_k + m + 20000001);
        else
            Internal_GraphParams_cur_fig_handle = figure(MPSO_k + RegPSO_k + m + 20000002);
        end
            % Set figure numbers to correspond to iteration
                % numbers - except offset by 20000000 to prevent
                % conflict with any other graph types generated.
    end
    set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
    axes('FontSize', GraphParams_axes_font_size)
    hold on %hold the current figure for plotting each time this "for" loop is called.
    if OnOff_title
        if RegPSO_grouping_counter == 1
            title(['Swarm State at Iteration ', int2str(MPSO_k + RegPSO_k + m + 1)], 'FontSize', GraphParams_labeltitle_font_size)
        else
            title(['Swarm State at Iteration ', int2str(MPSO_k + RegPSO_k + m + 2)], 'FontSize', GraphParams_labeltitle_font_size)
        end
    end
    xlabel('x_1', 'FontSize', GraphParams_labeltitle_font_size)
    ylabel('x_2', 'FontSize', GraphParams_labeltitle_font_size)

    if GraphParams_swarm_traj_snapshot_mode == 0 %If contour map is to zoom in on locations
            %each graph rather than using the same contour map defined prior to
            %entering the for loop.
        %Find min and max on each dimension and use these to
        %generate a meshgrid for the contour map.
        if (OnOff_plot_box_4_new_search_space) && (m == 0) && (RegPSO_k ~= 0)
            % These definitions account for the regrouping box
                % if it is to be drawn.
            Internal_GraphParams_dim1min = min(min(xhist(:, dim*m + 1)), lower_borders(1)); %2*0+1 = 1st column (iter 0, 1st dim), 
            Internal_GraphParams_dim1max = max(max(xhist(:, dim*m + 1)), upper_borders(1)); %2*1+1 = 3rd column (1st iter, 1st dim)
            Internal_GraphParams_dim2min = min(min(xhist(:, dim*m + 2)), lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width); %2*0+1 = 1st column (iter 0, 2nd dim),
            Internal_GraphParams_dim2max = max(max(xhist(:, dim*m + 2)), upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width); %2*1+1 = 3rd column (1st iter, 2nd dim)
        else
            Internal_GraphParams_dim1min = min(xhist(:, dim*m + 1)); %2*0+1 = 1st column (iter 0, 1st dim), 
            Internal_GraphParams_dim1max = max(xhist(:, dim*m + 1)); %2*1+1 = 3rd column (1st iter, 1st dim)
            Internal_GraphParams_dim2min = min(xhist(:, dim*m + 2)); %2*0+1 = 1st column (iter 0, 2nd dim),
            Internal_GraphParams_dim2max = max(xhist(:, dim*m + 2)); %2*1+1 = 3rd column (1st iter, 2nd dim)
        end
        f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.
    %If last iteration of current grouping && stagnation detected (rather than termination due to max iteration being reached)
    elseif (OnOff_zoom_on_final_graph) && (m == k) %&& (max(sqrt(sum((x - g).^2, 2)))/sqrt(sum((range_IS(1, :)).^2)) <= stag_thresh))
        %Graph once regularly before zooming.
        if OnOff_contourf;
            contourf(X1, X2, Z) %Graph the contour map first, then overlay particles.
        else
            contour(X1, X2, Z) %Graph the contour map first, then overlay particles.
        end

        if OnOff_mark_global_best_always  %first check prevents repetitious graphing of "g"
            text(ghist(m + 1, 1), ghist(m + 1, 2), 'g\rightarrow\rightarrow', 'HorizontalAlignment', 'right', 'BackgroundColor', 'black', 'FontSize', 0.6*GraphParams_marker_size, 'Color', 'white', 'FontWeight', 'bold', 'LineWidth',2,'LineStyle','-')
        end
        for Internal_i = 1:np %For all particles
            %Graph particles' current positions.
            if OnOff_mark_personal_bests
                if Internal_i < 10
                    text(phist(Internal_i, dim*m + 1), phist(Internal_i, dim*m + 2), strcat('\leftarrow\leftarrowp_',num2str(Internal_i)), 'BackgroundColor', 'black', 'FontSize', 0.57*GraphParams_marker_size, 'Color', 'white', 'FontWeight', 'bold', 'LineWidth',2,'LineStyle','-')
                else
                    text(phist(Internal_i, dim*m + 1), phist(Internal_i, dim*m + 2), strcat('\leftarrow\leftarrowp_',num2str(floor(Internal_i/10)),'_',num2str(mod(Internal_i,10))), 'BackgroundColor', 'black', 'FontSize', 0.57*GraphParams_marker_size, 'Color', 'white', 'FontWeight', 'bold')
                end
            end
            plot(xhist(Internal_i, dim*m + 1), xhist(Internal_i, dim*m + 2), 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', GraphParams_marker_size, 'LineWidth', GraphParams_line_width)
            if OnOff_plot_indices
                text(xhist(Internal_i, dim*m + 1), xhist(Internal_i, dim*m + 2), num2str(Internal_i), 'HorizontalAlignment', 'center', 'FontSize', GraphParams_text_font_size)
            end
            %Place text at each particle's current location.
        end
        axis tight
        if OnOff_autosave_figs || OnOff_autosave_figures_to_another_format
            %Save current figure before zooming.
            DateString = datestr(now);
            DateString(12) = '-';
            DateString([15, 18]) = '.';
            if RegPSO_grouping_counter == 1
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 1), ',', DateString, '.fig'])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 1), ',', DateString, '.', GraphParams_autosave_format], GraphParams_autosave_format)
                end
            else %i.e. RegPSO_grouping_counter >= 1
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 2), ',', DateString, '.fig'])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 2), ',', DateString, '.', GraphParams_autosave_format], GraphParams_autosave_format)
                end
            end
            clear DateString
        end
        hold off

        %& Define a new figure for the already scheduled zoom.
        if OnOff_reuse_figures
            close(figure(1000))
            Internal_GraphParams_cur_fig_handle = figure(1000);
        else
            if OnOff_autosave_figs
                Internal_GraphParams_cur_fig_handle = figure(10000000 - MPSO_k - RegPSO_k - m);
            end
        end
        set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
        axes('FontSize', GraphParams_axes_font_size) %needs 2 come b4 "hold on"
        hold on
        if OnOff_title
            if Reg_Method == 1
                title(['Final Iteration of Grouping #', int2str(RegPSO_grouping_counter)], 'FontSize', GraphParams_labeltitle_font_size)
            elseif Reg_Method == 0
                title('Final Iteration', 'FontSize', GraphParams_labeltitle_font_size)
            end
        end
        xlabel('x_1', 'FontSize', GraphParams_labeltitle_font_size)
        ylabel('x_2', 'FontSize', GraphParams_labeltitle_font_size)
        if GraphParams_swarm_traj_snapshot_mode == 2 %If the same
                %contour map is to be used over all groupings but the final state per grouping is to be
                %zoomed on, then the initial meshgrid, boundary, and Z values must be stored for reload
                %since they are changed with the zoom on the final state of each grouping.
            %Store initial values.
            X1_0 = X1; 
            X2_0 = X2;
            Z_0 = Z;
        end
        %Set min & max on each dimension then generate a meshgrid.
        if (OnOff_plot_box_4_new_search_space) && (m == 0) && (RegPSO_k ~= 0)
            % These definitions account for the regrouping box
                % if it is to be drawn.
            Internal_GraphParams_dim1min = min(min(xhist(:, dim*m + 1)), lower_borders(1)); %2*0+1 = 1st column (iter 0, 1st dim), 
            Internal_GraphParams_dim1max = max(max(xhist(:, dim*m + 1)), upper_borders(1)); %2*1+1 = 3rd column (1st iter, 1st dim)
            Internal_GraphParams_dim2min = min(min(xhist(:, dim*m + 2)), lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width); %2*0+1 = 1st column (iter 0, 2nd dim),
            Internal_GraphParams_dim2max = max(max(xhist(:, dim*m + 2)), upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width); %2*1+1 = 3rd column (1st iter, 2nd dim)
        else
            Internal_GraphParams_dim1min = min(xhist(:, dim*m + 1)); %2*0+1 = 1st column (iter 0, 1st dim), 
            Internal_GraphParams_dim1max = max(xhist(:, dim*m + 1)); %2*1+1 = 3rd column (1st iter, 1st dim)
            Internal_GraphParams_dim2min = min(xhist(:, dim*m + 2)); %2*0+1 = 1st column (iter 0, 2nd dim),
            Internal_GraphParams_dim2max = max(xhist(:, dim*m + 2)); %2*1+1 = 3rd column (1st iter, 2nd dim)
        end
        if OnOff_mark_personal_bests
            % Adjust minimum and maximum of each axis for
                % personal best markers.
            Internal_GraphParams_dim1min = min(phist(:, dim*m + 1), Internal_GraphParams_dim1min); %2*0+1 = 1st column (iter 0, 1st dim), 
            Internal_GraphParams_dim1max = max(phist(:, dim*m + 1), Internal_GraphParams_dim1max); %2*1+1 = 3rd column (1st iter, 1st dim)
            Internal_GraphParams_dim2min = min(phist(:, dim*m + 2), Internal_GraphParams_dim2min); %2*0+1 = 1st column (iter 0, 2nd dim),
            Internal_GraphParams_dim2max = max(phist(:, dim*m + 2), Internal_GraphParams_dim2max); %2*1+1 = 3rd column (1st iter, 2nd dim)
        end
        if OnOff_mark_global_best_always
            % Adjust minimum and maximum of each axis for
                % global best markers.
            Internal_GraphParams_dim1min = min(ghist(m + 1, 1), Internal_GraphParams_dim1min); %2*0+1 = 1st column (iter 0, 1st dim), 
            Internal_GraphParams_dim1max = max(ghist(m + 1, 1), Internal_GraphParams_dim1max); %2*1+1 = 3rd column (1st iter, 1st dim)
            Internal_GraphParams_dim2min = min(ghist(m + 1, 2), Internal_GraphParams_dim2min); %2*0+1 = 1st column (iter 0, 2nd dim),
            Internal_GraphParams_dim2max = max(ghist(m + 1, 2), Internal_GraphParams_dim2max); %2*1+1 = 3rd column (1st iter, 2nd dim)
        end
        f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.
    end
    if OnOff_contourf;
        contourf(X1, X2, Z) %Graph the contour map first, then overlay particles.
    else
        contour(X1, X2, Z) %Graph the contour map first, then overlay particles.
    end
    if (OnOff_plot_box_4_new_search_space) && (m == 0) && (RegPSO_k ~= 0) %If box showing new search space is to be drawn.
        plot([lower_borders(1), lower_borders(1)], [lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width], 'LineWidth',12,'Color',[0.502 0 0.251]) %the value added each end is to prevent a gap from appearing at corners where the lines segments don't overlap nicely
        plot([upper_borders(1), upper_borders(1)], [lower_borders(2) - GraphParams_fraction_of_line_width*GraphParams_line_width, upper_borders(2) + GraphParams_fraction_of_line_width*GraphParams_line_width], 'LineWidth',12,'Color',[0.502 0 0.251])
        plot([lower_borders(1), upper_borders(1)], [lower_borders(2), lower_borders(2)], 'LineWidth',12,'Color',[0.502 0 0.251])
        plot([lower_borders(1), upper_borders(1)], [upper_borders(2), upper_borders(2)], 'LineWidth',12,'Color',[0.502 0 0.251])
    end
    if OnOff_mark_global_best_always || ((OnOff_mark_global_best_on_zoomed_graph) && (OnOff_zoom_on_final_graph) && (m == k))
        %plots over particles since in the case that "g" is only plotted on the zoomed graph, this is
        %presumably done to infer the maximum distance from global best, which is used to determine the range_IS
        %within which particles regroup so that the location of the global takes precedence and is graphed in front
        %of the particles
        text(ghist(m + 1, 1), ghist(m + 1, 2), 'g\rightarrow\rightarrow', 'HorizontalAlignment', 'right', 'BackgroundColor', 'black', 'FontSize', 0.6*GraphParams_marker_size, 'Color', 'white', 'FontWeight', 'bold', 'LineWidth',2,'LineStyle','-')
    end %works, like the rest of this code, by stepping through the history
    for Internal_i = 1:np %For all particles
        %Graph particles' current positions.
        if OnOff_mark_personal_bests
            if Internal_i < 10
                text(phist(Internal_i, dim*m + 1), phist(Internal_i, dim*m + 2), strcat('\leftarrow\leftarrowp_',num2str(Internal_i)), 'BackgroundColor', 'black', 'FontSize', 0.57*GraphParams_marker_size, 'Color', 'white', 'FontWeight', 'bold', 'LineWidth',2,'LineStyle','-')
            else
                text(phist(Internal_i, dim*m + 1), phist(Internal_i, dim*m + 2), strcat('\leftarrow\leftarrowp_',num2str(floor(Internal_i/10)),'_',num2str(mod(Internal_i,10))), 'BackgroundColor', 'black', 'FontSize', 0.57*GraphParams_marker_size, 'Color', 'white', 'FontWeight', 'bold')
            end
        end
        plot(xhist(Internal_i, dim*m + 1), xhist(Internal_i, dim*m + 2), 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', GraphParams_marker_size, 'LineWidth', GraphParams_line_width)
        if OnOff_plot_indices
            text(xhist(Internal_i, dim*m + 1), xhist(Internal_i, dim*m + 2), num2str(Internal_i), 'HorizontalAlignment', 'center', 'FontSize', GraphParams_text_font_size)
        end
        %Place text at each particle's current location.
    end
    axis tight
    if OnOff_autosave_figs || OnOff_autosave_figures_to_another_format
        DateString = datestr(now);
        DateString(12) = '-';
        DateString([15, 18]) = '.';
        if RegPSO_grouping_counter == 1
            if (OnOff_zoom_on_final_graph) && (m == k)
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 1), '_Zoomed', ',', DateString, '.fig'])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 1), '_Zoomed', ',', DateString, '.', GraphParams_autosave_format], GraphParams_autosave_format)
                end
            else
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 1), ',', DateString, '.fig'])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 1), ',', DateString, '.', GraphParams_autosave_format], GraphParams_autosave_format)
                end
            end
        else %i.e. if RegPSO_grouping_counter >= 1
            if (OnOff_zoom_on_final_graph) && (m == k)
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 2), '_Zoomed', ',', DateString, '.fig'])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 2), '_Zoomed', ',', DateString, '.', GraphParams_autosave_format], GraphParams_autosave_format)
                end
            else
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 2), ',', DateString, '.fig'])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Tr', num2str(Internal_k_trials),',',  'SwarmTrajectory_at_iteration_', num2str(MPSO_k + RegPSO_k + m + 2), ',', DateString, '.', GraphParams_autosave_format], GraphParams_autosave_format)
                end
            end
        end
        clear DateString
    end
    hold off

    if (GraphParams_swarm_traj_snapshot_mode == 2) && OnOff_zoom_on_final_graph && (m == k)
        %If the same contour map is to be used over all
            %groupings but the final state per grouping is to
            %be zoomed on, initial meshgrid, boundary, and Z
            %values must be restored after the zoom.
        X1 = X1_0;
        X2 = X2_0;
        Z = Z_0;
        clear X1_0 X2_0 Z_0; %Clear temporary contour info once restored to primary names.
    end
    if OnOff_reuse_figures
        close(figure(1000))
    end
end
if (Reg_Method ~= 0) %Display range_IS, so that it can easily be monitored.
    if OnOff_see_data_per_grouping
        disp(['range_IS(1, :) = ', num2str(range_IS(1, :))]) %Display "range_IS" for monitoring.
    end
end
clear m Internal_GraphParams_dim1min Internal_GraphParams_dim1max Internal_GraphParams_dim2min Internal_GraphParams_dim2max X1 X2 Z
clear lower_borders upper_borders Set