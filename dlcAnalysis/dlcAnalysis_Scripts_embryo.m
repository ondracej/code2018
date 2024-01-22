%% DLC Analysis Scripts for tracking movement in chicken embryo
% written by Janie Ondracek, janie.ondracek@tum.de

%% Run each block of code by pressing Cntrl + Enter

%% 1) Define analysis directory and identify csv files
% Make sure to put all the .csv files for one experiment into one directory

analysisDir = 'Y:\JanieData\DLC-Analysis\ChickEmbryoTracking\NEW-July2022\ProbFiles\'; % path to the analysis directory, should contain the .csv files
ExperimentName = 'ProbFiles';

addpath(genpath('C:\Users\dlc\Documents\DLCEmbryoCode'));
dlc_OBJ = dlcAnalysis_OBJ_embryo(analysisDir, ExperimentName);

%% 2) Load csv files 
tic
dlc_OBJ = loadTrackedData(dlc_OBJ);
toc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3) Analysis
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plot detection clusters

likelihood_cutoff  = 0.98;
SaveNameTxt = 'BeakClusters-';
dlc_OBJ = plotDetectionClusters(dlc_OBJ, likelihood_cutoff, SaveNameTxt );

%% Distance between beak parts
likelihood_cutoff  = 0.98;
dlc_OBJ = plotDistanceBetweenTwoPoints(dlc_OBJ, likelihood_cutoff);

%% Distance between beak parts
likelihood_cutoff   = 0.98;
[dlc_OBJ] = plotAngleBetweenThreePoints(dlc_OBJ, likelihood_cutoff);

%% Movement
dbstop if error
likelihood_cutoff  = 0.98;
[dlc_OBJ] = plotMovement(dlc_OBJ, likelihood_cutoff);

%% Other analysis
%% Raw coordinates
plot_variable_over_time(dlc_OBJ, 1) % likelihood
plot_variable_over_time(dlc_OBJ, 2) % x coordinates
plot_variable_over_time(dlc_OBJ, 3) % y coordinates

%% Velocity and heat maps
% plot velocity over time
SaveNameTxt = 'BeakClusters-';
likelihood_cutoff  = 0.98;
dlc_OBJ = plotVelocity(dlc_OBJ, SaveNameTxt, likelihood_cutoff);

%% 
%dlc_Obj = makePlotsForDistances(dlc_Obj, 2);

% Box plots,heat maps for 5 s windows
%dlc_Obj = makePlotsMeanWindowAnalysis(dlc_Obj, 2);
