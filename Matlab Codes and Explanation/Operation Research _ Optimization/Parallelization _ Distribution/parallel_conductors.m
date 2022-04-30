% Magnetic Flux distribution using Finite Element Method...

clc

ln = 20;                % Length of conductors...
d = 2;                  % Distance between the conductors m & n..
m = 1;                  % Direction of current through the conductor, m (RIGHT)... 1(INTO), -1(OUT)
n = -1;                 % Direction of current through the conductor, n (LEFT)...
N = 20;                 % Number sections/elements in the conductors...
dl = ln/N;              % Length of each element..

% XYZ Coordinates/Location of each element from the origin(0,0,0), i.e 'd/2' is taken as origin.. 
xCm =  (d/2)*ones(1,N);    % Conductor m located @ +d/2...
xCn = (-d/2)*ones(1,N);    % Condcutor n located @ -d/2...

yC = (-ln/2+dl/2) : dl : (ln/2-dl/2);   % Y Coordinate of each element from origin, half on +Y & other half on -Y...
                                        % and also same for both conductors..

% zC remains 0 throughout the length, as conductors are lying on XY plane...
zC = zeros(1,N);

% Length(Projection) & Direction of each current element in Vector form..
Lx = zeros(1,N);        % Length of each element is zero on X axis..
Ly = dl*ones(1,N);      % Length of each element = dl on Y axis..
Lz = zeros(1,N);        % Length of each element is zero on Z axis..

% Points/Locations in space (here XZ plane) where B is to be computed..
NP = 125;               % Detector points..
xPmax = 3*d;            % Dimensions of detector space.., arbitrary..
zPmax = 2.5*d;

xP = linspace(-xPmax,xPmax,NP);        % Divide space with NP points..
zP = linspace(-zPmax,zPmax,NP);
[xxP zzP] = meshgrid(xP,zP);            % Creating the Mesh..

% Initialize B..
Bx = zeros(NP,NP);
By = zeros(NP,NP);
Bz = zeros(NP,NP);

% Computation of Magnetic Field (B) using Superposition principle..
% Compute B at each detector points due to each small cond elements & integrate them..
for q = 1:N
    rxm = xxP - xCm(q);         % Displacement Vector along X direction, from cond m..
    rxn = xxP - xCn(q);         % Displacement Vector along X direction, from cond n..
    ry = yC(q);                 % Same for m & n, no detector points on Y direction..
    rz = zzP - zC(q);           % Same for m & n..
    
    rm = sqrt(rxm.^2+ry.^2+rz.^2);      % Displacement Magnitude for an element on cond m..
    rn = sqrt(rxn.^2+ry.^2+rz.^2);      % Displacement Magnitude for an element on cond n..
    
    r3m = rm.^3;
    r3n = rn.^3;
    
    % Hence, Bx = Ly.rz/r^3, By = 0, Bz = -Ly.rx/r^3
    Bx = Bx + m*Ly(q).*rz./r3m + n*Ly(q).*rz./r3n;      % m & n, direction of current element..
    % By = 0;
    Bz = Bz - m*Ly(q).*rxm./r3m - n*Ly(q).*rxn./r3n;
end
B = sqrt(Bx.^2 + By.^2 + Bz.^2);        % Magnitude of B..
B = B/max(max(B));                      % Normalizing...

% Plotting...

figure(1);
pcolor(xxP,zzP,B);
colormap(jet);
shading interp;
axis equal;
axis([-xPmax xPmax -zPmax zPmax]);
xlabel('<-- x -->');ylabel('<-- z -->');
title('Magnetic Field Distibution');
colorbar;

figure(2);
surf(xxP,zzP,B,'FaceColor','interp',...
    'EdgeColor','none',...
    'FaceLighting','phong');
daspect([1 1 1]);
axis tight;
view(0,30);
camlight right;
colormap(jet);
grid off;
axis off;
colorbar;
title('Magnetic Field Distibution');

figure(3);
quiver(xxP,zzP,Bx,Bz);
colormap(lines);
%axis tight;
axis([-d d -0.75*d 0.75*d]);
title('Magnetic Field Distibution');
xlabel('<-- x -->');ylabel('<-- z -->');
zoom on;
