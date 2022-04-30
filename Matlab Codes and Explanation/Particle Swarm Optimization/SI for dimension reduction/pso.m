%-------------------------------------------------------------------------%
%         P A R T I C L E    S W A R M    O P T I M I Z A T I O N         %
function [pos, f, g] = pso(fun, param, h_cont, h_fit)

    % Storing parameters
    pop_s   = param.pop_s;      % Population size
    w       = param.w;          % Inertia constant (
    C1      = param.C1;         % Individual confidence factor
    C2      = param.C2;         % Swarm confidence factor
    type    = param.type;       % Minimization or maximization?
    max_gen = param.max_gen;    % Maximum generation limit
    xy_lim  = param.xy_lim;     % Recommended X and Y limits
    n       = param.n;          % Recommended number of lines to plot
    err     = param.err;        % Precision (error tolerance)
    
    % Parameter correction: percentage of the region of interest limits
    w  = abs((w*xy_lim(2))/100); 
    C1 = abs((C1*xy_lim(2))/100); 
    C2 = abs((C2*xy_lim(2))/100); 
    
    % Initialization: S contains the whole swarm
    S = NaN(pop_s, 4, 2);
    
        % Position initialization in S(:,1,[x y]) 
        S(:,1,1) = xy_lim(1) + (xy_lim(2)-xy_lim(1)).*rand(pop_s,1);
        S(:,1,2) = xy_lim(1) + (xy_lim(2)-xy_lim(1)).*rand(pop_s,1);
        
        % Velocity initialization in S(:,2,[vx,vy])
        S(:,2,1:2) = 0.10.*S(:,1,1:2);
        
        % Best particle position so far init in S(:,3,[best_x,best_y])
        S(:,3,1:2) = S(:,1,1:2);
        
        % Best particle fitness value so far init in S(:,4,best_f)
        S(:,4,1) = fun(S(:,1,1), S(:,1,2));
        
        % Best global value and position ever found initialization
        if(type == 1), [gBest(3),index] = min(S(:,4,1)); end
        if(type == 2), [gBest(3),index] = max(S(:,4,1)); end
        gBest(1:2) = S(index,3,1:2);
    
        % Plotting the swarm
            % Particles position
            hold(h_cont,'on');
            h_par = plot(h_cont, S(:,1,1), S(:,1,2),'.k');
            axis(h_cont, [xy_lim(1) xy_lim(2) xy_lim(1) xy_lim(2)]);
            hold(h_cont,'on');
            % Best global and generation fitness init
            fGlo = []; fGen = []; h_bes = [];
        
    % Generations' iteration loop
    tol = err * 100;
    gen = 0;
    while ((gen <= max_gen) && (tol > err))
        
        % New generation
        gen = gen + 1;
        
        % Updating the particles velocity
        S(:,2,1:2) = w.*squeeze(S(:,2,1:2)) + ...
                    (C1.*repmat(rand(pop_s,1),1,2).*(squeeze(S(:,3,1:2)-S(:,1,1:2)))) + ...
                    (C2.*repmat(rand(pop_s,1),1,2).*(repmat(gBest(1:2),pop_s,1)-squeeze(S(:,1,1:2))));
        
        % Updating the particles position
        S(:,1,1:2) = S(:,1,1:2) + S(:,2,1:2);

        % Evaluating the fitness of each particle
        f = fun(squeeze(S(:,1,1)), squeeze(S(:,1,2)));
        if(type == 1)       % Minimization
            S(f<S(:,4,1),3,1:2) = S(f<S(:,4,1),1,1:2);  % Updating p_best position
            S(f<S(:,4,1),4,1)   = f(f<S(:,4,1));        % Updating p_best fitness
            [genBest,index] = min(S(:,4,1));            % Best generation global fitness
            if(genBest < gBest(3))
                tol = gBest(3) - genBest;               % Tolerance
                gBest(3) = genBest;                     % Updating g_best fitness
                gBest(1:2) = S(index,3,1:2);            % Updating g_best position
            end
        end
        if(type == 2)       % Maximization
            S(f>S(:,4,1),3,1:2) = S(f>S(:,4,1),1,1:2);  % Updating p_best position
            S(f>S(:,4,1),4,1) = f(f>S(:,4,1));          % Updating p_best fitness
            [genBest,index] = max(S(:,4,1));            % Best generation global fitness
            if(genBest > gBest(3))
                tol = genBest - gBest(3);               % Tolerance
                prevBest = gBest(3);                    % Previous g_best for tolerance
                gBest(3) = genBest;                     % Updating g_best fitness
                gBest(1:2) = S(index,3,1:2);            % Updating g_best position
            end
        end

        % Plotting the swarm
            % Particles position
            delete(h_par); delete(h_bes)
            h_par = plot(h_cont, S(:,1,1), S(:,1,2),'.k'); hold(h_cont,'on');
            h_bes = plot(h_cont, gBest(1), gBest(2),'+r'); hold(h_cont,'on');
            axis(h_cont, [xy_lim(1) xy_lim(2) xy_lim(1) xy_lim(2)]);
            
            % Best global and generation fitness
            if(type == 1), fGlo(length(fGlo)+1) = 1/gBest(3); else fGlo(length(fGlo)+1) = gBest(3); end
            if(type == 1), fGen(length(fGen)+1) = 1/min(f); else fGen(length(fGen)+1) = min(f); end
            plot(h_fit, 1:gen, fGlo, 'm', 'LineWidth', 2); hold(h_fit,'on');  
            plot(h_fit, 1:gen, fGen, 'k'); hold(h_fit,'on');
            xlim(h_fit, [1 max_gen]); xlabel(h_fit, 'Generations','FontSize',9);
            title(h_fit,['Generation : ' num2str(gen) ' - Fitness: ' num2str(gBest(3))]);
            legend(h_fit,'f_{global}','f_{gen}','Location','SouthEast');
            if(type == 1), ylabel(h_fit, '1/f','FontSize',9); else ylabel(h_fit, 'f','FontSize',9); end
            set(gca,'FontSize',10);
            drawnow;
    end
    hold(h_fit,'off'); hold(h_cont,'off');
    
    % Returning the sub-optimal minima/maxima
    pos = gBest(1:2);
    f   = gBest(3);
    g   = gen;
end

