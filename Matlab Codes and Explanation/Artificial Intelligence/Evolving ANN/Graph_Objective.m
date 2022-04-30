
if OnOff_graph_ObjFun_f_vs_2D
    if size(center_IS0, 2) == 1
        if size(range_IS0, 2) == 1
            Internal_GraphParams_dim1min = center_IS0 - range_IS0/2;
            Internal_GraphParams_dim1max = center_IS0 + range_IS0/2;
            Internal_GraphParams_dim2min = center_IS0 - range_IS0/2;
            Internal_GraphParams_dim2max = center_IS0 + range_IS0/2;
        else %i.e. range_IS0 was specified as a vector or matrix - implying that
            %it may not be the same on each dimension
            Internal_GraphParams_dim1min = center_IS0 - range_IS0(1, 1)/2;
            Internal_GraphParams_dim1max = center_IS0 + range_IS0(1, 1)/2;
            Internal_GraphParams_dim2min = center_IS0 - range_IS0(1, 2)/2;
            Internal_GraphParams_dim2max = center_IS0 + range_IS0(1, 2)/2;
        end
    else %i.e. center_IS0 was specified as a vector or matrix - implying that
        %it may not be the same on each dimension
        if size(range_IS0, 2) == 1
            Internal_GraphParams_dim1min = center_IS0(1, 1) - range_IS0/2;
            Internal_GraphParams_dim1max = center_IS0(1, 1) + range_IS0/2;
            Internal_GraphParams_dim2min = center_IS0(1, 2) - range_IS0/2;
            Internal_GraphParams_dim2max = center_IS0(1, 2) + range_IS0/2;
        else %i.e. range_IS0 was specified as a vector or matrix - implying that
            %it may not be the same on each dimension
            Internal_GraphParams_dim1min = center_IS0(1, 1) - range_IS0(1, 1)/2;
            Internal_GraphParams_dim1max = center_IS0(1, 1) + range_IS0(1, 1)/2;
            Internal_GraphParams_dim2min = center_IS0(1, 2) - range_IS0(1, 2)/2;
            Internal_GraphParams_dim2max = center_IS0(1, 2) + range_IS0(1, 2)/2;
        end
    end

    if OnOff_reuse_figures
        Internal_GraphParams_cur_fig_handle = figure(1000);
    else
        Internal_GraphParams_cur_fig_handle = figure(10^7 + Internal_unique_table_counter);
    end
    set(Internal_GraphParams_cur_fig_handle, 'Position', Figure_Position);
    
    f_vs_2d %Call script to generate points for graphing obj. func. vs 2D meshgrid.

    mesh(X1, X2, Z);
    xlabel('Dimension 1', 'FontSize', GraphParams_labeltitle_font_size);
    ylabel('Dimension 2', 'FontSize', GraphParams_labeltitle_font_size);
    zlabel('Cost Function Value', 'FontSize', GraphParams_labeltitle_font_size);
    if OnOff_title
        if isequal(objective, 'Ackley')
            title('2D Ackley', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Griewangk')
            title('2D Griewangk', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Quadric')
            title('2D Quadric', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Quartic_Noisy')
            title('2D Quartic with noise', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Rastrigin')
            title('2D Rastrigin', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Rosenbrock')
            title('2D Rosenbrock', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Schaffers_f6')
            title('2D Schaffers_f6', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Schwefel')
            title('2D Schwefel', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Spherical')
            title('2D Spherical', 'FontSize', GraphParams_labeltitle_font_size);
        elseif isequal(objective, 'Weighted_Sphere')
            title('2D Weighted Sphere', 'FontSize', GraphParams_labeltitle_font_size);
        end
    end
    if OnOff_reuse_figures
        close(Internal_GraphParams_cur_fig_handle)
    end
end