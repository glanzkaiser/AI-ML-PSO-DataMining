
function [f] = ObjFun_NN(position_matrix, num_particles_2_evaluate) 
    for i = 1:num_particles_2_evaluate %for each PSO particle 
        % Get required variables from caller function
        net = evalin('caller','net'); %get existing network
        Pd = evalin('caller','trainV.Pd');
        Tl = evalin('caller','trainV.Tl');
        Ai = evalin('caller','trainV.Ai');
        Q  = evalin('caller','Q');
        TS = evalin('caller','TS'); 

       particle_positions   = position_matrix(i,:)'; %particle_positions(X) is the weight and bias values of particle i, in column vector form    
       net = setx(net,particle_positions); %set network weight and bias values according to this particles' position in the PSO space
       [perf] = calcperf2(net,particle_positions,Pd,Tl,Ai,Q,TS); %Calculate network performance using training data
       f(i,1) = perf; %column vector, "f," containing one function value per particle or position matrix row.
    end  

    if net.trainParam.plotPSO
        plotPSO_particles; %PSO scatter plot
    end
end
