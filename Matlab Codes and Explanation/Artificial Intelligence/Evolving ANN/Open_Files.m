%Right-click "Open_Files.m" and select "Run": files will be opened
%in the order specified and the 'Control_Panel.m" tab selected.

%Open the files.
open('gbest_core.m') %Runs Gbest PSO
open('gbest_initialization.m')
open('gbest_core_loop.m')
open('lbest_core.m') %Runs Lbest PSO
open('lbest_initialization.m')
open('lbest_core_loop.m')
open('Control_Panel.m') %Sets parameters
open('Objectives.m') %
open('Input_Validation.m') %Checks the validity of user-selected parameters
open('Display_Settings.m') %
open('RegPSO_main.m') %Called once parameters are loaded
open('Trial_Initializations') %Seeds randomizer and performs other initializations
%open('Display_Table.m') %
%open('Reg_Methods_0And1.m') %
open('Reg_Method_1.m') %
%open('Reg_Method_2.m') %
open('MPSO.m') %
%open('Autosave_Workspace_Per_Column.m') %
%open('RegPSO_save_grouping_data.m') %
%open('RegPSO_load_grouping_data.m') %
%open('Save_data_per_trial.m') %Saves data one trial at a time to free memory
%open('Load_trial_data_for_stats.m') %Reconstructs that data
%open('Title_Graphs.m') %
%open('Standard_Output.m') %
open('Graphs.m')
open('Graph_Objective.m')
open('Swarm_Trajectory.m')

open('Control_Panel.m') %Effectively click on the "Params"
    %tab for the user since this is the usual starting point.