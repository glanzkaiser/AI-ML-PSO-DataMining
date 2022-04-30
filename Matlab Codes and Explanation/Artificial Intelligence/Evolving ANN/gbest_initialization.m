
%%%%%%%%%%%%%%%%%
%Initializations%
%%%%%%%%%%%%%%%%%
p = x; %Initialize personal bests (i.e. personally best positions).
%Initialize "phist" as an empty array which will take its first value
%within the loop.
if OnOff_phist
    phist = p;
end
%Randomize initial velocities.
%The formula below works both when range_IS is a scalar and when range_IS is a
    %matrix of order "np" by "dim."  The former applies when initialization
    %is the same on each dimension.  The latter applies otherwise.
v = 2*vmax.*rand(np, dim) - vmax;
    %The velocities are randomly initialized from a uniform distribution.
    %At this time, I'm initializing -vmax<v<vmax, though it might be
        %better to start smaller.
    %Each row of "v" contains one particle's velocity components.
    %Variable "vmax" is used here to initialize velocities even when it is
        %not used for velocity clamping.
k = 0; %Initialize the counter of the number of iterations.
if OnOff_func_evals %Whether or not OPSO is used, initialize this to
    OPSO_ghost_FEs_counter = 0; %0 for use in "((k + 1)*np + OPSO_ghost_FEs_counter) <
end	%max_FEs_per_grouping." OPSO increments this with each ghost evaluation.
if np > 1 %"f" is given a column structure for consistency with the dimensions of "x."
    f = [0;0];
end

f = ObjFun(x, np); %Calculate the function value per particle.
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
fp = f; %After initialization of particles, the vector of personally best function values
    %is equal to the vector of initial function values.
if OnOff_fhist
    clear fhist
    fhist(:, 1) = f;
end
if OnOff_fphist
    clear fphist
    fphist(:, 1) = fp;
end
if (Reg_Method == 1) && (RegPSO_k ~= 0) %If RegPSO && not iteration 0 of initial grouping
    fg = min(min(f), fg);
else %if iteration 0 of the first and possibly only grouping
    fg = min(f);
end
if OnOff_fghist
    clear fghist
    fghist(1) = fg;
end
for Internal_i = 1:np
    %A new location yielding the same "fg" value will have
        %a chance to be considered the "g."
    if f(Internal_i) == fg %for particle producing the best function value
        %Store the globally best location (one row of matrix "x")
            %over "np" rows in order to create a matrix "g"
            %with the same dimensions (i.e. np X dim) as matrix "x."
        g = repmat(x(Internal_i,:), np, 1);
        if OnOff_Cauchy_mutation_of_global_best %Or for any other
            %application requiring the index of the global best...
            g_index = Internal_i; %... store the index of global best.
        end
    end
end
if OnOff_Cauchy_mutation_of_global_best %(between "g" and "ghist")
    clear W N gm fm %necessary when "dim" is changed while stepping
        %across objectives (specifically for Schaffer's f6 which is only 2D).
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
if OnOff_GCPSO
    fpbest = min(f); %Create "fpbest," which is equal to "fg" for standard...
    for Internal_i = 1:np %PSO but differs for RegPSO, which retains...
            %the global best and its function value from earlier groupings.
        if f(Internal_i) == fpbest %Set the index of the best particle.
            GCPSO_index_of_best_particle = Internal_i;
        end
    end
    GCPSO_r = 1; %Initialize GCPSO parameters.
	GCPSO_num_consecutive_successes = 0;
	GCPSO_num_consecutive_failures = 0;
end
if OnOff_ghist
    clear ghist
    ghist(1, :) = g(1, :);
end
if OnOff_xhist
    xhist = x;
end
if OnOff_vhist
    vhist = v;
end %"vhist" will be a "np" X "dim"*("k"+1) matrix of all "v" values.
if OnOff_v_soc_hist
    v_soc_hist = [];
end
if OnOff_v_cog_hist
    v_cog_hist = [];
end