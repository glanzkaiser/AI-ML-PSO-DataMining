
%close all
%clear all

%% Global parameters
global XMAX YMAX X_CELL_NUMB Y_CELL_NUMB STEP_MAX;
global J_DD J_LL J_DL J_DM J_LM LAM_AREA TARGET_CELL_SIZE;

%% Parameter Setting
XMAX=50; % domain size in x axis
YMAX=50; % domain size in y axis

STEP_MAX=XMAX*YMAX*1600; % time step number

X_CELL_NUMB=6; % initial cell number in x axis
Y_CELL_NUMB=6; % initial cell number in y axis

% Size constraint %
LAM_AREA=1; %
TARGET_CELL_SIZE=40;

% Interfacial energy %
J_DD=2; % dark-dark cells
J_LL=14; % light-light cells
J_DL=11; % dark-light cells
J_DM=16; % dark cells - medium
J_LM=J_DM; % light cells - medium

TEMPERATURE=10.0;

%% Error Handling
if sqrt(TARGET_CELL_SIZE)*X_CELL_NUMB > XMAX || sqrt(TARGET_CELL_SIZE)*Y_CELL_NUMB > YMAX
    error('Error: the initial cell configuration is unsuitable in the domain size');
end

%% Initial Condition
sigma = GetInitialCondition();

%% Setting for Model Variables and Parameters
cells = SetInitialParameters(sigma);

%% Time Step
for step = 1:STEP_MAX
    
    rnd_x = randi([2,XMAX-1]);
    rnd_y = randi([2,YMAX-1]);
    c = sigma(rnd_y,rnd_x);
    
    nb_indx=randi(8);
    switch nb_indx
        case 1
            nb_x=-1; nb_y=-1;
        case 2
            nb_x=-1; nb_y=0;
        case 3
            nb_x=-1; nb_y=1;
        case 4
            nb_x=0; nb_y=-1;
        case 5
            nb_x=0; nb_y=1;
        case 6
            nb_x=1; nb_y=-1;
        case 7
            nb_x=1; nb_y=0;
        case 8
            nb_x=1; nb_y=1;
    end
    nb_c = sigma(rnd_y+nb_y,rnd_x+nb_x);
    
    if c ~= nb_c
        % Calculation of energy difference and transition probability
        e_all = GetAdhesionEnergyDiff(cells, sigma, rnd_x, rnd_y, c, nb_c)...
            + GetSizeEnergyDiff(cells, c, nb_c);
        
        if e_all >= 0
            prob = exp(-e_all/TEMPERATURE);
        elseif e_all < 0
            prob = 1.0;
        end
        
        % Update of the state
        if prob >= rand
            sigma(rnd_y,rnd_x) = nb_c;
            if c > 0
                cells.area(c) = cells.area(c)-1;
            end
            if nb_c > 0
                cells.area(nb_c) = cells.area(nb_c)+1;
            end
        end
        
    end
    
    %% Output Figure
    if mod(step,XMAX*YMAX*16)==0
        disp(step/(XMAX*YMAX*16));
        OutputCellFigure(cells, sigma)
    end
    
end
