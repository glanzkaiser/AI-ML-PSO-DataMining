
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
if (Reg_Method == 1) && (RegPSO_k ~= 0)
    fg = min(min(f), fg);
else
    fg = min(f);
end
if OnOff_fghist
    clear fghist
    fghist(1) = fg;
end
if (OnOff_ghist) || (Reg_Method == 1) %For Lbest PSO, the global best
    %is only calculated when the history of global bests is maintained
    %or when regrouping is to be done (i.e. about the global best at
    %stagnation).
    for Internal_i = 1:np
        %A new location yielding the same "fg" value will have
            %a chance to be considered the "g."
        if f(Internal_i) == fg
            %Store the globally best location (one row of matrix "x")
                %over "np" rows in order to create a matrix "g"
                %with the same dimensions (i.e. np X dim) as matrix "x."
            g = repmat(x(Internal_i,:), np, 1);
        end
    end
    if OnOff_ghist
        clear ghist
        ghist(1, :) = g(1, :);
    end
end

% The neighborhood size is examined below to determine whether it is even or
    %odd.  If "lbest_neighb_size" is even, half of each particle's
    %neighborhood will be to its left and half to its right.  Otherwise,
    %each particle's neighborhood will have one more particle on the right
    %than on the left.
if mod(lbest_neighb_size, 2) == 0 %i.e. even neighborhood size
    LBEST_size_to_left = lbest_neighb_size/2;
    LBEST_size_to_right = LBEST_size_to_left;
else %i.e. odd neighborhood size
    LBEST_size_to_left = floor(lbest_neighb_size/2);
    LBEST_size_to_right = LBEST_size_to_left + 1;
end
l = p;
    % Initially, each particle has knowledge only of its own best.  The code
    % below will give each particle knowledge of its neighbors' bests as well.
for LBEST_particle_index = 1:np
    % For each particle index.
    LBEST_f_neighborhood_best = fp(LBEST_particle_index);
        %Initialize the best function value in the neighborhood to be the
        %best of the current particle.
    for LBEST_neighbor_index_unadjusted = (LBEST_particle_index - LBEST_size_to_left):(LBEST_particle_index + LBEST_size_to_right)
        % Determine the neighborhood around "LBEST_particle_index."
        LBEST_neighbor_index_adjusted = mod(LBEST_neighbor_index_unadjusted + np, np);
            %The index is guaranteed to be positive by adding the swarm size
                %and taking the result mod the swarm size.
            %The index is guaranteed to be less than the swarm size by
                %taking the sum mod the swarm size.
        if LBEST_neighbor_index_adjusted == 0
            LBEST_neighbor_index_adjusted = np;
        end
        if fp(LBEST_neighbor_index_adjusted) < LBEST_f_neighborhood_best
            % Find the best function value of all neighbor indices
            % Compare to own particles function value
            % If better, store position of neighbor to l(LBEST_particle_index, 1:dim)
            l(LBEST_particle_index, 1:dim) = p(LBEST_neighbor_index_adjusted, 1:dim);
            LBEST_f_neighborhood_best = fp(LBEST_neighbor_index_adjusted);
        end
    end
end
if OnOff_lhist
    lhist = l;
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