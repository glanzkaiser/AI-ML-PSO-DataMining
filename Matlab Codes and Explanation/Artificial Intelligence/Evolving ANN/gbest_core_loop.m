
k = k + 1; %Update "k" until reaching "max_iter_per_grouping" or "max_FEs_per_grouping."

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Update "w" (If Iteration-Varying Inertia Weight is Used).%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if OnOff_w_linear
    w = w_i - w_diff*(k - 1)/(max_iter_per_grouping - 2);
    %w_diff = w_i - w_f is calculated only once in "RegPSO_main"
    %This produces w_i when k = 1 and
    %w_i - w_diff = w_f when k = max_iter_per_grouping - 1.
    %Since Merriam Webster's dictionary defines an iteration as "the
    %repetition of a sequence of computer instructions a specified number
    %of times or until a condition is met," the PSO Research Toolbox did
    %not originally count initialization of the swarm at iteration 0 as an
    %"iteration" (i.e. since the velocity and position update equations do
    %not begin until iteration 1 so that the repititious sequence actually
    %begins at iteration 1).  The decision to count initialization as an
    %iteration for sake of straightforward comparison of data with that of
    %other researchers who generally consider initialization of the swarm
    %to be an iteration necessitated a slight change in the formula.
    %This formula differs from the traditional formula for linearly
    %varying the inertia weight only in that Mr. Evers's formula
    %applies the initial inertia weight to the velocity update of 
    %iteration 1 and initializes the swarm at iteration 0,
    %whereas the traditional formula applies the initial
    %inertia weight to iteration 0.  Having
    %the first velocity update occur at iteration 1 makes
    %counting more natural.  Both equations linearly vary the inertia
    %weight - this equation applying the first inertia weight to iteration
    %1 and the other to iteration 0.
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Update "v" Using a Different Random Number for Each Element.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r1 = rand(np, dim);
r2 = rand(np, dim);
if OnOff_GCPSO
    for Internal_i = 1:np
        if Internal_i == GCPSO_index_of_best_particle
            v(Internal_i, :) = -x(Internal_i, :) + g(Internal_i, :) + w*v(Internal_i, :) + GCPSO_r*(1 - 2*r2(Internal_i, :));
        else
            v(Internal_i, :) = w*v(Internal_i, :) + c1*r1(Internal_i, :).*(p(Internal_i, :) - x(Internal_i, :))+c2*r2(Internal_i, :).*(g(Internal_i, :) - x(Internal_i, :));
        end
    end
else %i.e. GCPSO is inactive
    v = w*v + c1*r1.*(p - x)+c2*r2.*(g - x);
end
if OnOff_v_cog_hist
    v_cog_hist = [v_cog_hist, c1*r1.*(p - x)];
end
if OnOff_v_soc_hist
    v_soc_hist = [v_soc_hist, c2*r2.*(g - x)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Implement Velocity Clamping (If Activated)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if OnOff_v_clamp %If velocity clamping is on,
    %then clamp each excessive component of "v."
    for Internal_i = 1:dim*np
        if abs(v(Internal_i)) > vmax(Internal_i)
            v(Internal_i) = sign(v(Internal_i))*vmax(Internal_i);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Update "x" after storing its current value.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if OnOff_v_reset %Store x before updating it in case it
        %needs to be restored and the velocity set to zero.
    Internal_xprev = x;
end
x = x + v; %This also works with GCPSO since the same basic position update
    %is used with the unique velocity update equation already implemented.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Implement Velocity Resetting (If Activated)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find which elements of "x" are outside the search space.
if OnOff_v_reset %&& (RegPSO_grouping_counter > 1)
    Internal_xmad = (x > xmax); % Initialize
        %matrix "Internal_xmad" with a 1 corresponding to each
        %element of "x" that is greater than the center_IS of the
        %original search space plus half the inintial range_IS,
        %"range_IS0."
    Internal_xmad = Internal_xmad + (x < xmin);
        %Add a 1 to each 0 element of the same matrix for
        %each element of "x" that violates the lower bound of the search
        %space
    if sum(sum(Internal_xmad)) ~= 0 %i.e. if any particle is out of bounds
        for Internal_i = 1:np %(since "any" operates only on vectors.)
            if any(Internal_xmad(Internal_i,:)) == 1 %If any dimension of any particle exits the
                    %search space, set all responsible elements of the velocity matrix "v" to zero.
                v(Internal_i, :) = (1 - Internal_xmad(Internal_i, :)).*v(Internal_i, :);
                %Recalculate matrix "x" using the previous iteration's values (rather than
                    %those that violated the boundaries) and the new velocity with
                    %elements responsible for boundary violations set to zero.
                x(Internal_i, :) = Internal_xprev(Internal_i, :) + v(Internal_i, :);
            end
        end
    end
elseif OnOff_position_clamping
    x = min(x, xmax);
    x = max(x, xmin);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find Current Function Values and Personally Best Function Values & Locations%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the function value for each row/particle.
f = ObjFun(x, np); %The column vector "f" of function values is updated.

%Compare the new function value of "GCPSO_index_of_best_particle" with its
    %value from the previous iteration and update the number of consecutive
    %successes and failures accordingly: then update "GCPSO_r" as
    %appropriate according to those values.
if OnOff_GCPSO
    if f(GCPSO_index_of_best_particle)< fpbest
        GCPSO_num_consecutive_successes = GCPSO_num_consecutive_successes + 1;
        GCPSO_num_consecutive_failures = 0;
    else
        GCPSO_num_consecutive_successes = 0;
        GCPSO_num_consecutive_failures = GCPSO_num_consecutive_failures + 1;
    end
    if GCPSO_num_consecutive_successes > GCPSO_threshold_num_successes
        GCPSO_r = 2*GCPSO_r;
    elseif GCPSO_num_consecutive_failures > GCPSO_threshold_num_failures
        GCPSO_r = GCPSO_r/2;
    end
end

if OnOff_OPSO
    x_min = min(x); %Calculate the min and max per dimension of the swarm.
    x_max = max(x);
    ox = repmat(x_min, np, 1) + repmat(x_max, np, 1) - x; %Calculate each
        %particle's ghost position opposite the center_IS of the swarm: the
        %sum of the swarm's minimum and maximum on any dimension divided by
        %2 gives the swarm's center_IS on that dimension.  The positions, x,
        %minus the center_IS vector/matrix are then subtracted from
        %center_IS to give the ghost positions that may or may not be selected
        %by "OPSO_selections" below for evaluation: (x_min + x_max)/2 -
        %(x - (x_min + x_max)/2) = x_min + x_max - x when simplified.
    of = ObjFun(ox, np); %Find the function values of the
        %opposite positions that may or may not be selected for official
        %evaluation by "OPSO_selections" below using probability "p0."
    OPSO_selections = repmat((rand(np, 1)<p0).*(of<f), 1, dim); %Select
        %opposite positions that (i) satisfy probability "p0" and
        %(ii) produce better function values than the original population.
    x = OPSO_selections.*ox + (1 - OPSO_selections).*x; %Store selected
        %opposite positions to position matrix "x."
    f = OPSO_selections(:, 1).*of + (1 - OPSO_selections(:, 1)).*f;%Store the function
        %values of selected opposite positions to column vector "f."
    if OnOff_func_evals %Count the additional OPSO function evaluations.
        OPSO_ghost_FEs_counter = OPSO_ghost_FEs_counter + sum(OPSO_selections(:, 1));
    end
end
for Internal_i = 1:np
    if f(Internal_i) <= fp(Internal_i) %if the new function value is better
        %than that of the personal best at the previous iteration
        fp(Internal_i) = f(Internal_i);
            %updates the personally best function value (but only
            %updates a particular row if it has improved)
        p(Internal_i,:) = x(Internal_i,:);
            %updates the personally best location for each particle
            %(but only updates a particular row if it has improved)
        if OnOff_GCPSO %The index of the best particle will only change...
            if fp(Internal_i) < fpbest %if another particle improves to...
                fpbest = fp(Internal_i); %a better value than the previous...
                GCPSO_index_of_best_particle = Internal_i; %best.  Note,...
            end %fpbest is used for compatibility with RegPSO...
        end %where the global best of the previous grouping is remembered....
    end %This strictly agrees with Van den Bergh's usage...
end %in "A New Locally Convergent Particle Swarm Optimiser," 2002.
if OnOff_phist
    phist = [phist, p];
end
if OnOff_fhist
    fhist(:, k+1) = f;
end
if OnOff_fphist
    fphist(:, k+1) = fp;
end
%Add the updated values to "vhist" and "xhist."
if OnOff_vhist
    vhist = [vhist, v];
end
if OnOff_xhist
    xhist = [xhist, x];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Update the Globally Best Function Value & Location.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg = min(fg, min(f)); %Update the function value produced by global best.
if OnOff_SuccessfulUnsuccessful %"OnOff_iter_success" is only created in this case to avoid unnecessary workspace clutter: "if ... && ..." cannot be used.
        %Do we want to measure success?
    if OnOff_iter_success && (~iter_success_switch)
        if (fg <= thresh_for_succ) %not a logical check like the two above
                %If so: (i) do we want a history of where it occured?
                      %(ii) has it not occurred previously?
                     %(iii) is the trial currently successful?
            iter_success(1, Internal_k_trials) = 1 + k + RegPSO_k + MPSO_k;
            iter_success_switch = true; %Success occurred at iteration "k"
                %and was recorded in "iter_success."  Switching this
                %to 1 prevents access to "iter_success."
        end
    end
end
if OnOff_fghist %Store the function value produced by global best to...
    fghist(k+1) = fg; %... its history when that history is activated.
end
%Update below the global best using the updated function value.
for Internal_i = 1:np %"Internal_i" named so as to group internal variables
        %together in the workspace, thus enabling data to more easily be analyzed
    %A new location yielding the same "fg" value will have
        %a chance to be considered the "g."
    if f(Internal_i) <= fg %"<" should not occur but is placed her in case
        %Store the globally best location (one row of matrix "x")
            %over "np" rows in order to create a matrix "g"
                %with the same dimensions (i.e. np X dim) as matrix "x."
        g = repmat(x(Internal_i,:), np, 1);
        if OnOff_Cauchy_mutation_of_global_best %Or for any other
            %application requiring the index of the global best...
            g_index = Internal_i; %... update the index of global best.
        end
    end
end
if OnOff_Cauchy_mutation_of_global_best %(between "g" and "ghist")
    W = max(min(sum(v)./np, 1), -1); %eq. 8 of (Wang 2007 OPSO) calculates
        %the average velocity per dimension and clamps it to el[-1, 1]
    for i = 1:dim %generate a random # from Cauchy dist. per dim.
        N(i) = cauchyrnd;
    end %Clamp the Cauchy #'s to the bounds of the search space below,
    %multiply the Cauchy #'s per dim by the avg. vel. per dim, & mutate the
        %global best by this amount to see if a better "g" results.
        %Note that this does not equate to perturbing the globally best
        %particle, which may no longer be at location "g."
    gm = g(1, :) + W.*min(max(N, xmin_row), xmax_row); %eq. 9 of (Wang 2007 OPSO)
        %Store the mutated global best.
    fm = ObjFun(gm, 1); %Evaluate the quality of the mutation.
    if fm < fg %If "gm" is of higher quality, update "g" & "fg"
        fg = fm; %(i.e. if mutation is beneficial, replace gloabl best).
        g = repmat(gm, np, 1); %Repeat "gm" per row for matrix addition.
        x(g_index, :) = gm;
        p(g_index, :) = gm;
        f(g_index) = fm;
        fp(g_index) = fm;
    end
    if OnOff_func_evals
        OPSO_ghost_FEs_counter = OPSO_ghost_FEs_counter + 1;
    end %Count the extra function evaluation for termination purposes.
end
if OnOff_ghist
    ghist(k + 1, :) = g(1, :);
end