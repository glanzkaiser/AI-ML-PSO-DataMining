%Right-click "Open_All_Files.m" and select "Run" when changes are to be
%made to all files (e.g. improving a variable's name to have greater
%transparency, for which the [Ctrl+{Home, f} + (Alt + a) + (Ctrl + s)]
%sequence with "whole word" selected makes the desired replacements).


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
open('Trial_Initializations') %Seeds randomizer and performs other initializations
open('RegPSO_main.m') %Called once parameters are loaded
open('Reg_Methods_0And1.m') %
open('Reg_Method_1.m') %
open('Reg_Method_2.m') %
open('MPSO.m') %
open('Autosave_Workspace_Per_Column.m') %
open('RegPSO_save_grouping_data.m') %
open('RegPSO_load_grouping_data.m') %
open('Save_data_per_trial.m') %Saves data one trial at a time to free memory
open('Load_trial_data_for_stats.m') %Reconstructs that data
open('Title_Graphs.m') %
open('Standard_Output.m') %
open('Graphs.m')
open('Graph_Objective.m')
open('Swarm_Trajectory.m')
open('Open_Files.m')
open('Open_All_Files.m')

open('Control_Panel.m') %Effectively, this clicks on the "Params"
    %tab for the user since this is the usual starting point.