
%* The graphing code is sufficiently scaleable to handle any number of
    %dimensions and particles and to display a correct title for each
    %possible situation.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate Graphs for cases:                              %
%(1) RegPSO Method 1 was Employed                        %
%(2) More Than One Standard PSO Simulation Was Conducted.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (Reg_Method ~= 0 && OnOff_graph_fg) || (OnOff_graph_fg_mean && (num_trials > 1)) %i.e. multiple trials or multiple groupings (non-standard graph)
    if OnOff_reuse_figures
        Internal_GraphParams_cur_fig_handle = figure(1000);
    else
        Internal_GraphParams_cur_fig_handle = figure(Internal_unique_table_counter*10000 + Internal_unique_column_counter);
    end
    set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
    axes('FontSize', GraphParams_axes_font_size)
    hold on
    Title_Graphs
    xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
    if OnOff_semilogy
        if (OnOff_graph_fg_mean && (num_trials > 1))
            semilogy(1:length(fghist_mean), fghist_mean, '-b.')
        else %i.e. "OnOff_graph_fg" true
            semilogy(1:length(fghist_current_trial), fghist_current_trial, '-b.')
        end
    else
        if (OnOff_graph_fg_mean && (num_trials > 1))
            plot(1:length(fghist_mean), fghist_mean, '-b.')
        else %i.e. "OnOff_graph_fg" true
            plot(1:length(fghist_current_trial), fghist_current_trial, '-b.')
        end
    end
    %Save figures with a uniquely descriptive name.
    if OnOff_autosave_figs
        DateString = datestr(now);
        DateString(15) = '.';
        DateString(18) = '.';
        if Reg_Method ~= 0
            hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/ObjFuncValue,', objective, 'RM', num2str(Reg_Method),...
                ',np', num2str(np), ',dim', num2str(dim), ',rf',...
                num2str(reg_fact), ',stag_thr', num2str(stag_thresh), ',', ...
                DateString, '.fig'])
        else
            hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/ObjFuncValue,', objective, 'RM', num2str(Reg_Method),...
                ',np', num2str(np), ',dim', num2str(dim), ',', DateString, '.fig'])
        end
    end
    if OnOff_autosave_figures_to_another_format
        if Reg_Method ~= 0
            saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                'ObjFuncValue,', objective, 'RM', num2str(Reg_Method),...
                ',np', num2str(np), ',dim', num2str(dim), ',rf',...
                num2str(reg_fact), ',stag_thr', num2str(stag_thresh), ',', ...
                DateString, '.', GraphParams_autosave_format], GraphParams_autosave_format)
        else
            saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                'ObjFuncValue,', objective, 'RM', num2str(Reg_Method),...
                ',np', num2str(np), ',dim', num2str(dim), ',', DateString, '.', GraphParams_autosave_format], GraphParams_autosave_format)
        end
    end
    hold off
    if OnOff_reuse_figures
        close(Internal_GraphParams_cur_fig_handle)
    end
else %i.e. 1 trial of standard PSO
    if OnOff_MPSO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Phase Plot (Activated When "OnOff_phase_plot == 1")%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %x2 vs x1 (only generated if dim = 2)
        if OnOff_phase_plot
            if dim == 2
                for Internal_i = 1:np
                    if OnOff_reuse_figures
                        Internal_GraphParams_cur_fig_handle = figure(1000);
                    else
                        Internal_GraphParams_cur_fig_handle = figure(1000+Internal_i);
                    end
                    set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                    axes('FontSize', GraphParams_axes_font_size)
                    hold on
                    plot(xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)), xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)), '-.')
                    if OnOff_title
                        title(strcat('Phase Plot for Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                    end
                    xlabel('Dimension 1', 'FontSize', GraphParams_labeltitle_font_size)
                    ylabel('Dimension 2', 'FontSize', GraphParams_labeltitle_font_size)
                    phase_plot_particle_number = 0;
                    for Internal_j = 1:dim:size(xhist_current_trial, 2)
                        text(xhist_current_trial(Internal_i,  Internal_j), xhist_current_trial(Internal_i, Internal_j+1), int2str(phase_plot_particle_number), 'FontSize', 15)
                        phase_plot_particle_number = phase_plot_particle_number + 1;
                    end
                    clear phase_plot_particle_number
                    Internal_GraphParams_dim1min = min(xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)));
                    Internal_GraphParams_dim1max = max(xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)));
                    Internal_GraphParams_dim2min = min(xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)));
                    Internal_GraphParams_dim2max = max(xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)));
                    f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.
                    contour(X1, X2, Z)
                    axis tight
                    if OnOff_autosave_figs
                        hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Phase_Plot_Particle_', num2str(Internal_i)])
                    end
                    if OnOff_autosave_figures_to_another_format
                        saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                            'Phase_Plot_Particle_', num2str(Internal_i), '.',...
                            GraphParams_autosave_format], GraphParams_autosave_format)
                    end
                    hold off
                    if OnOff_reuse_figures
                        close(Internal_GraphParams_cur_fig_handle)
                    end
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph: Position Per Particle%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_x
            for Internal_i = 1:np
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(Internal_i);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title(strcat('Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Position', 'FontSize', GraphParams_labeltitle_font_size)
                if dim == 2
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)), '-r*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)), '--g*')
                    legend('x1', 'x2', 'Location', 'EastOutside')
                end
                if dim == 3
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)), '-r*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)), '--g*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 3:dim:size(xhist_current_trial, 2)), ':b*')
                    legend('x1', 'x2', 'x3', 'Location', 'EastOutside')
                end
                if dim == 4
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)), '-r*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)), '--g*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 3:dim:size(xhist_current_trial, 2)), ':b*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 4:dim:size(xhist_current_trial, 2)), '-.c*')
                    legend('x1', 'x2', 'x3', 'x4', 'Location', 'EastOutside')
                end
                if dim == 5
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)), '-r*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)), '--g*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 3:dim:size(xhist_current_trial, 2)), ':b*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 4:dim:size(xhist_current_trial, 2)), '-.c*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 5:dim:size(xhist_current_trial, 2)), '-m*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'Location', 'EastOutside')
                end
                if dim == 6
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)), '-r*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)), '--g*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 3:dim:size(xhist_current_trial, 2)), ':b*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 4:dim:size(xhist_current_trial, 2)), '-.c*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 5:dim:size(xhist_current_trial, 2)), '-m*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 6:dim:size(xhist_current_trial, 2)), '--y*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'Location', 'EastOutside')
                end
                if dim == 7
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 1:dim:size(xhist_current_trial, 2)), '-r*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 2:dim:size(xhist_current_trial, 2)), '--g*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 3:dim:size(xhist_current_trial, 2)), ':b*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 4:dim:size(xhist_current_trial, 2)), '-.c*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 5:dim:size(xhist_current_trial, 2)), '-m*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 6:dim:size(xhist_current_trial, 2)), '--y*')
                    plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i, 7:dim:size(xhist_current_trial, 2)), ':k*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'Location', 'EastOutside')
                end
                if dim > 7
                    for Internal_j = 1:dim
                        plot(1:1:size(xhist_current_trial,2)/dim, xhist_current_trial(Internal_i,  Internal_j:dim:size(xhist_current_trial, 2)), '-.*')
                    end
                end
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Position_Particle_', num2str(Internal_i)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Position_Particle_', num2str(Internal_i), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph Velocity Components%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_v
            for Internal_i = 1:np
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(10000+Internal_i);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title(strcat('Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Velocity Components', 'FontSize', GraphParams_labeltitle_font_size)
                if dim == 2
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 1:dim:size(vhist_current_trial, 2)), '-r*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 2:dim:size(vhist_current_trial, 2)), '--g*')
                    legend('x1', 'x2', 'Location', 'EastOutside')
                end
                if dim == 3
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 1:dim:size(vhist_current_trial, 2)), '-r*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 2:dim:size(vhist_current_trial, 2)), '--g*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 3:dim:size(vhist_current_trial, 2)), ':b*')
                    legend('x1', 'x2', 'x3', 'Location', 'EastOutside')
                end
                if dim == 4
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 1:dim:size(vhist_current_trial, 2)), '-r*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 2:dim:size(vhist_current_trial, 2)), '--g*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 3:dim:size(vhist_current_trial, 2)), ':b*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 4:dim:size(vhist_current_trial, 2)), '-.c*')
                    legend('x1', 'x2', 'x3', 'x4', 'Location', 'EastOutside')
                end
                if dim == 5
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 1:dim:size(vhist_current_trial, 2)), '-r*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 2:dim:size(vhist_current_trial, 2)), '--g*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 3:dim:size(vhist_current_trial, 2)), ':b*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 4:dim:size(vhist_current_trial, 2)), '-.c*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 5:dim:size(vhist_current_trial, 2)), '-m*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'Location', 'EastOutside')
                end
                if dim == 6
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 1:dim:size(vhist_current_trial, 2)), '-r*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 2:dim:size(vhist_current_trial, 2)), '--g*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 3:dim:size(vhist_current_trial, 2)), ':b*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 4:dim:size(vhist_current_trial, 2)), '-.c*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 5:dim:size(vhist_current_trial, 2)), '-m*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 6:dim:size(vhist_current_trial, 2)), '--y*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'Location', 'EastOutside')
                end
                if dim == 7
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 1:dim:size(vhist_current_trial, 2)), '-r*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 2:dim:size(vhist_current_trial, 2)), '--g*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 3:dim:size(vhist_current_trial, 2)), ':b*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 4:dim:size(vhist_current_trial, 2)), '-.c*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 5:dim:size(vhist_current_trial, 2)), '-m*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 6:dim:size(vhist_current_trial, 2)), '--y*')
                    plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i, 7:dim:size(vhist_current_trial, 2)), ':k*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'Location', 'EastOutside')
                end
                if dim > 7
                    for Internal_j = 1:dim
                        plot(1:1:size(vhist_current_trial,2)/dim, vhist_current_trial(Internal_i,  Internal_j:dim:size(vhist_current_trial, 2)), '-.*')
                    end
                end
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Vel_Comp_Particle_', num2str(Internal_i)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Vel_Comp_Particle_', num2str(Internal_i), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph Particles' Function Values%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_f
            for Internal_i = 1:np
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(100000+Internal_i);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title(strcat('Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Function Value', 'FontSize', GraphParams_labeltitle_font_size)
                plot(1:1:size(fhist_current_trial,2), fhist_current_trial(Internal_i, 1:size(fhist_current_trial,2)), '-r*') %"If you receive an error, set 'OnOff_fhist = 1;.'"
                axis tight
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Personal_Function_Value_Particle_', num2str(Internal_i)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Personal_Function_Value_Particle_', num2str(Internal_i), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph: Personal Bests Per Particle%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_p
            for Internal_i = 1:np
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(100+Internal_i);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title(strcat('Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Personal Best', 'FontSize', GraphParams_labeltitle_font_size)
                if dim == 2
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 1:dim:size(phist_current_trial, 2)), '-r*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 2:dim:size(phist_current_trial, 2)), '--g*')
                    legend('x1', 'x2', 'Location', 'EastOutside')
                end
                if dim == 3
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 1:dim:size(phist_current_trial, 2)), '-r*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 2:dim:size(phist_current_trial, 2)), '--g*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 3:dim:size(phist_current_trial, 2)), ':b*')
                    legend('x1', 'x2', 'x3', 'Location', 'EastOutside')
                end
                if dim == 4
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 1:dim:size(phist_current_trial, 2)), '-r*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 2:dim:size(phist_current_trial, 2)), '--g*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 3:dim:size(phist_current_trial, 2)), ':b*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 4:dim:size(phist_current_trial, 2)), '-.c*')
                    legend('x1', 'x2', 'x3', 'x4', 'Location', 'EastOutside')
                end
                if dim == 5
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 1:dim:size(phist_current_trial, 2)), '-r*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 2:dim:size(phist_current_trial, 2)), '--g*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 3:dim:size(phist_current_trial, 2)), ':b*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 4:dim:size(phist_current_trial, 2)), '-.c*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 5:dim:size(phist_current_trial, 2)), '-m*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'Location', 'EastOutside')
                end
                if dim == 6
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 1:dim:size(phist_current_trial, 2)), '-r*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 2:dim:size(phist_current_trial, 2)), '--g*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 3:dim:size(phist_current_trial, 2)), ':b*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 4:dim:size(phist_current_trial, 2)), '-.c*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 5:dim:size(phist_current_trial, 2)), '-m*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 6:dim:size(phist_current_trial, 2)), '--y*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'Location', 'EastOutside')
                end
                if dim == 7
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 1:dim:size(phist_current_trial, 2)), '-r*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 2:dim:size(phist_current_trial, 2)), '--g*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 3:dim:size(phist_current_trial, 2)), ':b*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 4:dim:size(phist_current_trial, 2)), '-.c*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 5:dim:size(phist_current_trial, 2)), '-m*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 6:dim:size(phist_current_trial, 2)), '--y*')
                    plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i, 7:dim:size(phist_current_trial, 2)), ':k*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'Location', 'EastOutside')
                end
                if dim > 7
                    for Internal_j = 1:dim
                        plot(1:1:size(phist_current_trial,2)/dim, phist_current_trial(Internal_i,  Internal_j:dim:size(phist_current_trial, 2)), '-.*')
                    end
                end
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Personal_Best_Particle_', num2str(Internal_i)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Personal_Best_Particle_', num2str(Internal_i), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph: Global Best (Location)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_g
            Internal_GraphParams_cur_fig_handle = figure(1000);
            set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
            axes('FontSize', GraphParams_axes_font_size)
            hold on
                if dim == 2
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 1), '-ro')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 2), '--go')
                    legend('x1', 'x2', 'Location', 'EastOutside')
                end
                if dim == 3
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 1), '-ro')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 2), '--go')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 3), ':bo')
                    legend('x1', 'x2', 'x3', 'Location', 'EastOutside')
                end
                if dim == 4
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 1), '-ro')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 2), '--go')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 3), ':bo')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 4), '-.co')
                    legend('x1', 'x2', 'x3', 'x4', 'Location', 'EastOutside')
                end
                if dim == 5
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 1), '-ro')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 2), '--go')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 3), ':bo')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 4), '-.co')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 5), '-mo')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'Location', 'EastOutside')
                end
                if dim == 6
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 1), '-ro')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 2), '--go')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 3), ':bo')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 4), '-.co')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 5), '-mo')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 6), '--yo')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'Location', 'EastOutside')
                end
                if dim == 7
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 1), '-ro')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 2), '--go')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 3), ':bo')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 4), '-.co')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 5), '-mo')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 6), '--yo')
                    plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, 7), ':ko')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'Location', 'EastOutside')
                end
                if dim > 7
                    for Internal_j = 1:dim
                        plot(1:1:size(ghist_current_trial, 1), ghist_current_trial(:, Internal_j), '-.o')
                    end
                end
            if OnOff_title
                title('Global Best', 'FontSize', GraphParams_labeltitle_font_size)
            end
            xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
            ylabel('Position', 'FontSize', GraphParams_labeltitle_font_size)
            if OnOff_autosave_figs
                hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Position_Global_Best'])
            end
            if OnOff_autosave_figures_to_another_format
                saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                    'Position_Global_Best.',...
                    GraphParams_autosave_format], GraphParams_autosave_format)
            end
            hold off
            if OnOff_reuse_figures
                close(Internal_GraphParams_cur_fig_handle)
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph Function Value of Global Best%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_fg
            if OnOff_reuse_figures
                Internal_GraphParams_cur_fig_handle = figure(1000);
            else
                Internal_GraphParams_cur_fig_handle = figure(1000000);
            end
            set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
            axes('FontSize', GraphParams_axes_font_size)
            hold on
            if OnOff_title
                title('Global Best', 'FontSize', GraphParams_labeltitle_font_size)
            end
            xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
            ylabel('Function Value', 'FontSize', GraphParams_labeltitle_font_size)
            if OnOff_semilogy
                semilogy(1:length(fghist_current_trial), fghist_current_trial, '-b*')
            else
                plot(1:length(fghist_current_trial), fghist_current_trial, '-b*')
            end
            axis tight
            if OnOff_autosave_figs
                hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Func_Value,RM', num2str(Reg_Method), ',np', num2str(np), ',dim', num2str(dim)])
            end
            if OnOff_autosave_figures_to_another_format
                saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                    'Func_Value,RM', num2str(Reg_Method), ',np', num2str(np), ',dim', num2str(dim), '.',...
                    GraphParams_autosave_format], GraphParams_autosave_format)
            end
            hold off
            if OnOff_reuse_figures
                close(Internal_GraphParams_cur_fig_handle)
            end

            if fg < 0.3
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(1000001);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title('Global Best', 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Func. Value Zoomed', 'FontSize', GraphParams_labeltitle_font_size)
                if OnOff_semilogy
                    semilogy(1:length(fghist_current_trial), fghist_current_trial, '-b*')
                else
                    plot(1:length(fghist_current_trial), fghist_current_trial, '-b*')
                end
                if fg ~= 0
                    axis([0 size(fghist_current_trial, 2) 0 fg*100]) %ymax is 100 times larger than the final function value, which
                        %zooms nicely when the desired solution is the null vector
                else %(i.e. fg == 0)
                    axis([0 size(fghist_current_trial, 2) 0 10^(-10)])
                end
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Func_Value_zoomed,RM', num2str(Reg_Method), ',np', num2str(np), ',dim', num2str(dim)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Func_Value_zoomed,RM', num2str(Reg_Method), ',np', num2str(np), ',dim', num2str(dim), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end
    else %i.e. ~OnOff_MPSO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Phase Plot (Activated When "OnOff_phase_plot == 1")%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %x2 vs x1 (only generated if dim = 2)
        if OnOff_phase_plot
            if dim == 2
                for Internal_i = 1:np
                    if OnOff_reuse_figures
                        Internal_GraphParams_cur_fig_handle = figure(1000);
                    else
                        Internal_GraphParams_cur_fig_handle = figure(1000+Internal_i);
                    end
                    set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                    axes('FontSize', GraphParams_axes_font_size)
                    hold on
                    plot(xhist(Internal_i, 1:dim:dim*(k + 1)), xhist(Internal_i, 2:dim:dim*(k + 1)), '-.')
                    if OnOff_title
                        title(strcat('Phase Plot for Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                    end
                    xlabel('Dimension 1', 'FontSize', GraphParams_labeltitle_font_size)
                    ylabel('Dimension 2', 'FontSize', GraphParams_labeltitle_font_size)
                    phase_plot_particle_number = 0;
                    for Internal_j = 1:dim:dim*(k + 1)
                        text(xhist(Internal_i,  Internal_j), xhist(Internal_i, Internal_j+1), int2str(phase_plot_particle_number), 'FontSize', 15)
                        phase_plot_particle_number = phase_plot_particle_number + 1;
                    end
                    clear phase_plot_particle_number
                    Internal_GraphParams_dim1min = min(xhist(Internal_i, 1:dim:size(xhist, 2)));
                    Internal_GraphParams_dim1max = max(xhist(Internal_i, 1:dim:size(xhist, 2)));
                    Internal_GraphParams_dim2min = min(xhist(Internal_i, 2:dim:size(xhist, 2)));
                    Internal_GraphParams_dim2max = max(xhist(Internal_i, 2:dim:size(xhist, 2)));
                    f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.
                    contour(X1, X2, Z)
                    axis tight
                    if OnOff_autosave_figs
                        hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Phase_Plot_Particle_', num2str(Internal_i)])
                    end
                    if OnOff_autosave_figures_to_another_format
                        saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                            'Phase_Plot_Particle_', num2str(Internal_i), '.',...
                            GraphParams_autosave_format], GraphParams_autosave_format)
                    end
                    hold off
                    if OnOff_reuse_figures
                        close(Internal_GraphParams_cur_fig_handle)
                    end
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph: Position Per Particle%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_x
            for Internal_i = 1:np
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(Internal_i);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title(strcat('Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Position', 'FontSize', GraphParams_labeltitle_font_size)
                if dim == 2
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    legend('x1', 'x2', 'Location', 'EastOutside')
                end
                if dim == 3
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    legend('x1', 'x2', 'x3', 'Location', 'EastOutside')
                end
                if dim == 4
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    legend('x1', 'x2', 'x3', 'x4', 'Location', 'EastOutside')
                end
                if dim == 5
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'Location', 'EastOutside')
                end
                if dim == 6
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 6:dim:dim*(k + 1)), '--y*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'Location', 'EastOutside')
                end
                if dim == 7
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 6:dim:dim*(k + 1)), '--y*')
                    plot(1:1:size(xhist,2)/dim, xhist(Internal_i, 7:dim:dim*(k + 1)), ':k*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'Location', 'EastOutside')
                end
                if dim > 7
                    for Internal_j = 1:dim
                        plot(1:1:size(xhist,2)/dim, xhist(Internal_i,  Internal_j:dim:dim*(k + 1)), '-.*')
                    end
                end
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Position_Particle_', num2str(Internal_i)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Position_Particle_', num2str(Internal_i), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph Velocity Components%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_v
            for Internal_i = 1:np
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(10000+Internal_i);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title(strcat('Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Velocity Components', 'FontSize', GraphParams_labeltitle_font_size)
                if dim == 2
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    legend('x1', 'x2', 'Location', 'EastOutside')
                end
                if dim == 3
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    legend('x1', 'x2', 'x3', 'Location', 'EastOutside')
                end
                if dim == 4
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    legend('x1', 'x2', 'x3', 'x4', 'Location', 'EastOutside')
                end
                if dim == 5
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'Location', 'EastOutside')
                end
                if dim == 6
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 6:dim:dim*(k + 1)), '--y*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'Location', 'EastOutside')
                end
                if dim == 7
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 6:dim:dim*(k + 1)), '--y*')
                    plot(1:1:size(vhist,2)/dim, vhist(Internal_i, 7:dim:dim*(k + 1)), ':k*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'Location', 'EastOutside')
                end
                if dim > 7
                    for Internal_j = 1:dim
                        plot(1:1:size(vhist,2)/dim, vhist(Internal_i,  Internal_j:dim:dim*(k + 1)), '-.*')
                    end
                end
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Vel_Comp_Particle_', num2str(Internal_i)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Vel_Comp_Particle_', num2str(Internal_i), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph Particles' Function Values%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_f
            for Internal_i = 1:np
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(100000+Internal_i);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title(strcat('Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Function Value', 'FontSize', GraphParams_labeltitle_font_size)
                plot(1:k + 1, fhist(Internal_i, 1:k + 1), '-r*') %"If you receive an error, set 'OnOff_fhist = 1;.'"
                axis tight
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Personal_Function_Value_Particle_', num2str(Internal_i)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Personal_Function_Value_Particle_', num2str(Internal_i), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph: Personal Bests Per Particle%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_p
            for Internal_i = 1:np
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(100+Internal_i);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title(strcat('Particle ', [' ', int2str(Internal_i)]), 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Personal Best', 'FontSize', GraphParams_labeltitle_font_size)
                if dim == 2
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    legend('x1', 'x2', 'Location', 'EastOutside')
                end
                if dim == 3
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    legend('x1', 'x2', 'x3', 'Location', 'EastOutside')
                end
                if dim == 4
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    legend('x1', 'x2', 'x3', 'x4', 'Location', 'EastOutside')
                end
                if dim == 5
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'Location', 'EastOutside')
                end
                if dim == 6
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 6:dim:dim*(k + 1)), '--y*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'Location', 'EastOutside')
                end
                if dim == 7
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 1:dim:dim*(k + 1)), '-r*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 2:dim:dim*(k + 1)), '--g*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 3:dim:dim*(k + 1)), ':b*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 4:dim:dim*(k + 1)), '-.c*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 5:dim:dim*(k + 1)), '-m*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 6:dim:dim*(k + 1)), '--y*')
                    plot(1:1:size(phist,2)/dim, phist(Internal_i, 7:dim:dim*(k + 1)), ':k*')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'Location', 'EastOutside')
                end
                if dim > 7
                    for Internal_j = 1:dim
                        plot(1:1:size(phist,2)/dim, phist(Internal_i,  Internal_j:dim:dim*(k + 1)), '-.*')
                    end
                end
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Personal_Best_Particle_', num2str(Internal_i)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Personal_Best_Particle_', num2str(Internal_i), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph: Global Best (Location)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_g
            Internal_GraphParams_cur_fig_handle = figure(1000);
            set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
            axes('FontSize', GraphParams_axes_font_size)
            hold on
                if dim == 2
                    plot(1:1:size(ghist, 1), ghist(:, 1), '-ro')
                    plot(1:1:size(ghist, 1), ghist(:, 2), '--go')
                    legend('x1', 'x2', 'Location', 'EastOutside')
                end
                if dim == 3
                    plot(1:1:size(ghist, 1), ghist(:, 1), '-ro')
                    plot(1:1:size(ghist, 1), ghist(:, 2), '--go')
                    plot(1:1:size(ghist, 1), ghist(:, 3), ':bo')
                    legend('x1', 'x2', 'x3', 'Location', 'EastOutside')
                end
                if dim == 4
                    plot(1:1:size(ghist, 1), ghist(:, 1), '-ro')
                    plot(1:1:size(ghist, 1), ghist(:, 2), '--go')
                    plot(1:1:size(ghist, 1), ghist(:, 3), ':bo')
                    plot(1:1:size(ghist, 1), ghist(:, 4), '-.co')
                    legend('x1', 'x2', 'x3', 'x4', 'Location', 'EastOutside')
                end
                if dim == 5
                    plot(1:1:size(ghist, 1), ghist(:, 1), '-ro')
                    plot(1:1:size(ghist, 1), ghist(:, 2), '--go')
                    plot(1:1:size(ghist, 1), ghist(:, 3), ':bo')
                    plot(1:1:size(ghist, 1), ghist(:, 4), '-.co')
                    plot(1:1:size(ghist, 1), ghist(:, 5), '-mo')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'Location', 'EastOutside')
                end
                if dim == 6
                    plot(1:1:size(ghist, 1), ghist(:, 1), '-ro')
                    plot(1:1:size(ghist, 1), ghist(:, 2), '--go')
                    plot(1:1:size(ghist, 1), ghist(:, 3), ':bo')
                    plot(1:1:size(ghist, 1), ghist(:, 4), '-.co')
                    plot(1:1:size(ghist, 1), ghist(:, 5), '-mo')
                    plot(1:1:size(ghist, 1), ghist(:, 6), '--yo')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'Location', 'EastOutside')
                end
                if dim == 7
                    plot(1:1:size(ghist, 1), ghist(:, 1), '-ro')
                    plot(1:1:size(ghist, 1), ghist(:, 2), '--go')
                    plot(1:1:size(ghist, 1), ghist(:, 3), ':bo')
                    plot(1:1:size(ghist, 1), ghist(:, 4), '-.co')
                    plot(1:1:size(ghist, 1), ghist(:, 5), '-mo')
                    plot(1:1:size(ghist, 1), ghist(:, 6), '--yo')
                    plot(1:1:size(ghist, 1), ghist(:, 7), ':ko')
                    legend('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'Location', 'EastOutside')
                end
                if dim > 7
                    for Internal_j = 1:dim
                        plot(1:1:size(ghist, 1), ghist(:, Internal_j), '-.o')
                    end
                end
            if OnOff_title
                title('Global Best', 'FontSize', GraphParams_labeltitle_font_size)
            end
            xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
            ylabel('Position', 'FontSize', GraphParams_labeltitle_font_size)
            if OnOff_autosave_figs
                hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Position_Global_Best'])
            end
            if OnOff_autosave_figures_to_another_format
                saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                    'Position_Global_Best.',...
                    GraphParams_autosave_format], GraphParams_autosave_format)
            end
            hold off
            if OnOff_reuse_figures
                close(Internal_GraphParams_cur_fig_handle)
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Graph Function Value of Global Best%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OnOff_graph_fg
            if OnOff_reuse_figures
                Internal_GraphParams_cur_fig_handle = figure(1000);
            else
                Internal_GraphParams_cur_fig_handle = figure(1000000);
            end
            set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
            axes('FontSize', GraphParams_axes_font_size)
            hold on
            if OnOff_title
                title('Global Best', 'FontSize', GraphParams_labeltitle_font_size)
            end
            xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
            ylabel('Function Value', 'FontSize', GraphParams_labeltitle_font_size)
            if OnOff_semilogy
                semilogy(1:length(fghist), fghist, '-b*')
            else
                plot(1:length(fghist), fghist, '-b*')
            end
            axis tight
            if OnOff_autosave_figs
                hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Func_Value,RM', num2str(Reg_Method), ',np', num2str(np), ',dim', num2str(dim)])
            end
            if OnOff_autosave_figures_to_another_format
                saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                    'Func_Value,RM', num2str(Reg_Method), ',np', num2str(np), ',dim', num2str(dim), '.',...
                    GraphParams_autosave_format], GraphParams_autosave_format)
            end
            hold off

            if fg < 0.3
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
                if OnOff_reuse_figures
                    Internal_GraphParams_cur_fig_handle = figure(1000);
                else
                    Internal_GraphParams_cur_fig_handle = figure(1000001);
                end
                set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
                axes('FontSize', GraphParams_axes_font_size)
                hold on
                if OnOff_title
                    title('Global Best', 'FontSize', GraphParams_labeltitle_font_size)
                end
                xlabel('Iteration', 'FontSize', GraphParams_labeltitle_font_size)
                ylabel('Func. Value Zoomed', 'FontSize', GraphParams_labeltitle_font_size)
                if OnOff_semilogy
                    semilogy(1:length(fghist), fghist, '-b*')
                else
                    plot(1:length(fghist), fghist, '-b*')
                end
                if fg ~= 0
                    axis([0 k 0 fg*100]) %ymax is 100 times larger than the final function value, which
                        %zooms nicely when the desired solution is the null vector
                else %(i.e. fg == 0)
                    axis([0 k 0 10^(-10)])
                end
                if OnOff_autosave_figs
                    hgsave(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/Func_Value_zoomed,RM', num2str(Reg_Method), ',np', num2str(np), ',dim', num2str(dim)])
                end
                if OnOff_autosave_figures_to_another_format
                    saveas(Internal_GraphParams_cur_fig_handle, ['Data/', DateString_dir, '/Figures/'...
                        'Func_Value_zoomed,RM', num2str(Reg_Method), ',np', num2str(np), ',dim', num2str(dim), '.',...
                        GraphParams_autosave_format], GraphParams_autosave_format)
                end
                hold off
                if OnOff_reuse_figures
                    close(Internal_GraphParams_cur_fig_handle)
                end
            end
        end
    end
end