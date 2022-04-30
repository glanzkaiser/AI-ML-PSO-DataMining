
% Calculate 2D meshgrid against which Z will be plotted.
[X1, X2] = meshgrid(...
    Internal_GraphParams_dim1min:(Internal_GraphParams_dim1max - Internal_GraphParams_dim1min)/ ...
    GraphParams_meshgrid_quality:Internal_GraphParams_dim1max, ...
    Internal_GraphParams_dim2min:(Internal_GraphParams_dim2max - Internal_GraphParams_dim2min)/ ...
    GraphParams_meshgrid_quality:Internal_GraphParams_dim2max);

% Clear variables used to calculate [X1, X2] since they are not needed afterward.
clear Internal_GraphParams_dim1min Internal_GraphParams_dim1max ...
    Internal_GraphParams_dim2min Internal_GraphParams_dim2max

% Generate function values to be plotted versus meshgrid.
if isequal(objective, 'Ackley')
    Z = -20*exp(-0.2*sqrt((X1.^2 + X2.^2)./dim)) - exp((cos(2*pi*X1)+cos(2*pi*X2))./dim) + exp(1) + 20;
elseif isequal(objective, 'Griewangk')
    Z = 1 + (X1.^2 + X2.^2)./4000 - cos(X1)*cos(X2./sqrt(2));
elseif isequal(objective, 'Quadric')
    disp('Please visit <a href="http://www.georgeevers.org">www.georgeevers.org</a> for the newest code.')
elseif isequal(objective, 'Quartic_Noisy')
    disp('Please visit <a href="http://www.georgeevers.org">www.georgeevers.org</a> for the newest code.')
elseif isequal(objective, 'Rastrigin')
    Z = X1.^2 - 10*cos(2*pi*X1) + X2.^2 - 10*cos(2*pi*X2) + 20;
elseif isequal(objective, 'Rosenbrock')
    disp('Please visit <a href="http://www.georgeevers.org">www.georgeevers.org</a> for the newest code.')
elseif isequal(objective, 'Schaffers_f6')
    disp('Please visit <a href="http://www.georgeevers.org">www.georgeevers.org</a> for the newest code.')
elseif isequal(objective, 'Schwefel')
    Z = X1.*sin(sqrt(abs(X1))) + X2.*sin(sqrt(abs(X2))) + 418.982887272433799807913601398*2;
elseif isequal(objective, 'Spherical')
    Z = X1.^2 + X2.^2;
elseif isequal(objective, 'Weighted_Sphere')
    disp('Please visit <a href="http://www.georgeevers.org">www.georgeevers.org</a> for the newest code.')
end