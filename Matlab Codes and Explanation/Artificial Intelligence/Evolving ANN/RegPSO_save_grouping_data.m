%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DateString = datestr(now);
DateString(12) = '-';
DateString([15, 18]) = '.';
DateString(3) = [];
DateString(7) = [];
DateString(7) = [];
Internal_date_string_array = [Internal_date_string_array; DateString]; %used to load files
    %and to provide information that is useful when the regrouping
    %factor is changed across trials
if OnOff_MPSO %The final function value per grouping is displayed in...
    fg_array(MPSO_grouping_counter) = fg; %saved file names and recalled...
    Rand_seq_start_point_array(MPSO_grouping_counter) = Rand_seq_start_point;
else %sequentially from "fg_array" when reconstructing data.
    fg_array(RegPSO_grouping_counter) = fg;
end
if OnOff_num_gs_identical_b4_refinement %If "reg_fact" can change, keep an array of values...
    reg_fact_array = [reg_fact_array reg_fact]; %used to load files.
end
if OnOff_MPSO
    if OnOff_func_evals
        if Reg_Method == 1 %which implies for now that OnOff_NormR_stag_det == 1
            if OnOff_w_linear == 0
                save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                    num2str(stag_thresh), ',', num2str(reg_fact),...
                    ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                    num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                    ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                    num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                    DateString, '.mat']);
            else
                save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                    num2str(stag_thresh), ',', num2str(reg_fact),...
                    ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                    num2str(c1), ',', num2str(c2), ',',...
                    num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                    ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                    num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                    DateString, '.mat']);
            end
        else %(i.e. Reg_Method == 2)
            if OnOff_NormR_stag_det
                if OnOff_w_linear == 0
                    save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(stag_thresh), ',', num2str(num_runs_b4_reduction), ',', ...
                        num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                else
                    save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(stag_thresh), ',', num2str(num_runs_b4_reduction), ',', ...
                        num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',',...
                        num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                end
            else %(i.e. OnOff_NormR_stag_det ~=1 and presumably == 0, in which case "stag_thresh" is removed from the filename)
                if OnOff_w_linear == 0
                    save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(num_runs_b4_reduction), ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                else
                    save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(num_runs_b4_reduction), ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',',...
                        num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                end                                
            end
        end
    else %i.e. if iterations are to be used instead of function evaluations
        if Reg_Method == 1 %which implies for now that OnOff_NormR_stag_det == 1
            if OnOff_w_linear == 0
                save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                    num2str(stag_thresh), ',', num2str(reg_fact),...
                    ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                    num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                    ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                    num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                    DateString, '.mat']);
            else
                save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                    num2str(stag_thresh), ',', num2str(reg_fact),...
                    ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                    num2str(c1), ',', num2str(c2), ',',...
                    num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                    ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                    num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                    DateString, '.mat']);
            end
        else %(i.e. Reg_Method == 2)
            if OnOff_NormR_stag_det
                if OnOff_w_linear == 0
                    save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(stag_thresh), ',', num2str(num_runs_b4_reduction), ',', ...
                        num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                else
                    save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(stag_thresh), ',', num2str(num_runs_b4_reduction), ',', ...
                        num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',',...
                        num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                end
            else %(i.e. OnOff_NormR_stag_det ~=1 and presumably == 0, in which case "stag_thresh" is removed from the filename)
                if OnOff_w_linear == 0
                    save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(num_runs_b4_reduction), ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                else
                    save(['Data/', DateString_dir, '/WS/MPSORM', num2str(Reg_Method), ',Gr', num2str(MPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(num_runs_b4_reduction), ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',',...
                        num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                end
            end
        end
    end
else %i.e. no multi-start of core algorithm
    if OnOff_func_evals
        if Reg_Method == 1 %which implies for now that OnOff_NormR_stag_det == 1
            if OnOff_w_linear == 0
                save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                    num2str(stag_thresh), ',', num2str(reg_fact),...
                    ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                    num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                    ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                    num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                    DateString, '.mat']);
            else
                save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                    num2str(stag_thresh), ',', num2str(reg_fact),...
                    ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                    num2str(c1), ',', num2str(c2), ',',...
                    num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                    ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                    num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                    DateString, '.mat']);
            end
        else %(i.e. Reg_Method == 2)
            if OnOff_NormR_stag_det
                if OnOff_w_linear == 0
                    save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(stag_thresh), ',', num2str(num_runs_b4_reduction), ',', ...
                        num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                else
                    save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(stag_thresh), ',', num2str(num_runs_b4_reduction), ',', ...
                        num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',',...
                        num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                end
            else %(i.e. OnOff_NormR_stag_det ~=1 and presumably == 0, in which case "stag_thresh" is removed from the filename)
                if OnOff_w_linear == 0
                    save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(num_runs_b4_reduction), ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                else
                    save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(num_runs_b4_reduction), ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',',...
                        num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_FEs_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                end                                
            end
        end
    else %i.e. if iterations are to be used instead of function evaluations
        if Reg_Method == 1 %which implies for now that OnOff_NormR_stag_det == 1
            if OnOff_w_linear == 0
                save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                    num2str(stag_thresh), ',', num2str(reg_fact),...
                    ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                    num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                    ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                    num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                    DateString, '.mat']);
            else
                save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                    num2str(stag_thresh), ',', num2str(reg_fact),...
                    ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                    num2str(c1), ',', num2str(c2), ',',...
                    num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                    ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                    num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                    DateString, '.mat']);
            end
        else %(i.e. Reg_Method == 2)
            if OnOff_NormR_stag_det
                if OnOff_w_linear == 0
                    save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(stag_thresh), ',', num2str(num_runs_b4_reduction), ',', ...
                        num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                else
                    save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(stag_thresh), ',', num2str(num_runs_b4_reduction), ',', ...
                        num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',',...
                        num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                end
            else %(i.e. OnOff_NormR_stag_det ~=1 and presumably == 0, in which case "stag_thresh" is removed from the filename)
                if OnOff_w_linear == 0
                    save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(num_runs_b4_reduction), ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',', num2str(OnOff_w_linear), ',', num2str(w),...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                else
                    save(['Data/', DateString_dir, '/WS/RM', num2str(Reg_Method), ',Gr', num2str(RegPSO_grouping_counter), ',',  objective(1:2), ',', num2str(dim), ',', num2str(np), ',',...
                        num2str(num_runs_b4_reduction), ',', num2str(vmax_perc), ',', num2str(OnOff_v_clamp), ',', num2str(OnOff_v_reset), ',',...
                        num2str(c1), ',', num2str(c2), ',',...
                        num2str(OnOff_w_linear), ',', num2str(w_i), ',', num2str(w_f)...
                        ',', num2str(Rand_seq_start_point), ',', num2str(max_num_groupings), ',',...
                        num2str(num_trials), ',Fm', num2str(max_iter_per_grouping), ',', num2str(fg), ',',...
                        DateString, '.mat']);
                end
            end
        end
    end
end
clear DateString %Reduce workspace clutter by clearing this internally used variable once it has been used.