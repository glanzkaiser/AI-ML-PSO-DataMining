% When tables are not generated (i.e. when only one column of one table is
% generated), the output below is used rather than "Display_Table."


if OnOff_w_linear
    if OnOff_v_clamp
        if OnOff_asymmetric_initialization
            disp(['objective=', objective, ', dim=', num2str(dim), ', np=', num2str(np), ...
                ', c1=', num2str(c1), ', c2=', num2str(c2), ', w_i=', num2str(w_i), ', w_f=', num2str(w_f), ...
                ', vmax=', num2str(vmax_perc/4*100), '% of the range of the search space per dimension'])
        else %i.e. if ~OnOff_asymmetric_initialization
            disp(['objective=', objective, ', dim=', num2str(dim), ', np=', num2str(np), ...
                ', c1=', num2str(c1), ', c2=', num2str(c2), ', w_i=', num2str(w_i), ', w_f=', num2str(w_f), ...
                ', vmax=', num2str(vmax_perc), '*range_IS'])
        end
    else
        disp(['objective=', objective, ', dim=', num2str(dim), ', np=', num2str(np), ...
            ', c1=', num2str(c1), ', c2=', num2str(c2), ', w_i=', num2str(w_i), ', w_f=', num2str(w_f)])
    end
else %i.e. if static inertia weight
    if OnOff_v_clamp
        if OnOff_asymmetric_initialization
            disp(['objective=', objective, ', dim=', num2str(dim), ', np=', num2str(np), ...
                ', c1=', num2str(c1), ', c2=', num2str(c2), ', w=', num2str(w), ...
                ', vmax=', num2str(vmax_perc/4*100), '% of the range of the search space per dimension'])
        else %i.e. if ~OnOff_asymmetric_initialization
            disp(['objective=', objective, ', dim=', num2str(dim), ', np=', num2str(np), ...
                ', c1=', num2str(c1), ', c2=', num2str(c2), ', w=', num2str(w), ...
                ', vmax=', num2str(vmax_perc), '*range_IS'])
        end
    else
        disp(['objective=', objective, ', dim=', num2str(dim), ', np=', num2str(np), ...
            ', c1=', num2str(c1), ', c2=', num2str(c2), ', w=', num2str(w)])
    end
end
if OnOff_SuccessfulUnsuccessful
    disp(['Number of Successful Trials: ' num2str(num_trials_successful)])
    disp(['Number of Unsuccessful Trials: ' num2str(num_trials_unsuccessful)])
    if num_trials_successful + num_trials_unsuccessful ~= num_trials
        errordlg('num_trials_successful + num_trials_unsuccessful ~= num_trials!')
    end
end
if num_trials > 1
    if OnOff_SuccessfulUnsuccessful
        disp(['Success Rate: ' num2str(num_trials_successful/num_trials*100), '%'])
    end
    if OnOff_SuccessfulUnsuccessful
        if OnOff_iter_success
            if OnOff_func_evals
                if (~OnOff_OPSO) && (~OnOff_Cauchy_mutation_of_global_best)
                    disp(['Mean # of FE''s required for success (when successful): ', num2str(np*(1 + iter_success_mean))])
                end
            else %i.e. if iterations are to be used instead of function evaluations
                disp(['Mean # of iterations required for success (when successful): ', num2str(1 + iter_success_mean)])
            end
        end
    end
    if OnOff_func_evals
        if (~OnOff_OPSO) && (~OnOff_Cauchy_mutation_of_global_best)
            disp(['Mean # of function eval''s = ', num2str(np*(iter_mean_per_trial))])
        end
    else %i.e. if iterations are to be used instead of function evaluations
        disp(['Mean # of iterations = ', num2str(iter_mean_per_trial)])
    end
    disp(['fg_median = ', num2str(fg_median)])
    disp(['fg_mean = ', num2str(fg_mean)])
    disp(['fg_min = ', num2str(fg_min)])
    disp(['fg_max = ', num2str(fg_max)])
    disp(['fg_std = ', num2str(fg_std)])
    disp(['t_per_trial_mean = ', num2str(t_per_trial_mean)])
    disp(['time_elapsed = ', num2str(time_elapsed)])
else %(i.e. "num_trials" == 1)
    if OnOff_func_evals
        if OnOff_MPSO
            disp(['# of function eval''s = ', num2str(np*(MPSO_k))])
        else %i.e. ~OnOff_MPSO
            if Reg_Method == 0 %standard case
                disp(['# of function eval''s = ', num2str((1 + k)*np + OPSO_ghost_FEs_counter)])
            else % Regrouping case
                disp(['# of function eval''s = ', num2str((1 + RegPSO_k)*np + OPSO_ghost_FEs_RegPSO)])
            end
        end
    else %i.e. if iterations are to be used instead of function evaluations
        if OnOff_MPSO
            disp(['# of iterations = ', num2str(MPSO_k)])
        else %i.e. ~OnOff_MPSO
            if Reg_Method == 0 %standard case
                disp(['# of iterations = ', num2str(1 + k)])
            else % Regrouping case
                disp(['# of iterations = ', num2str(1 + RegPSO_k)])
            end
        end
    end
    if Reg_Method ~= 2
        disp(['fg = ', num2str(fg)])
    else %(i.e. if Reg_Method == 2)
        disp(['fz_best = ', num2str(fz_best)])
    end
    disp(['time_elapsed = ', num2str(time_elapsed)])
end