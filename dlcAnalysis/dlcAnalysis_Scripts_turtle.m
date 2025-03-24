%% DLC Analysis Scripts

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathToCodeRepository = 'C:\Users\Neuropix\Documents\GitHub\code2018\';
addpath(genpath(pathToCodeRepository)) 

% Define paths

close all
clear all

analysisDir = 'E:\TurtleTestFiles_forMatlabGUI\New\videos\E9\Target-4\';
TurtleName = 'E9';
TargetText = 'Target-4';
filtered = 1; % 1 use filtered data, 0, use unfiltered data

dlc_OBJ = dlcAnalysis_OBJ_turtle(analysisDir, filtered );

dlc_OBJ.DATA.TurtleName  = TurtleName;
dlc_OBJ.DATA.TargetText  = TargetText;

% Load tracked data

dlc_OBJ = loadTrackedData_generic(dlc_OBJ);
%dlc_OBJ = loadTrackedData(dlc_OBJ);

% Load Video data

%dlc_OBJ = loadVideoData(dlc_OBJ);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Trajectories %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot trajectories
dlc_Obj = plotTrajectories(dlc_OBJ);

%% plot trajectories with likelihood cutoff

likelihood_cutoff = 0.65;

[dlc_Obj ] = plotTrajectories_with_likelihood(dlc_OBJ, likelihood_cutoff);

%% Videos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotTrajectoriesMakeVideo(dlc_Obj);

%% Make Video with Likelihood cutoff and frame cutoff

likelihood_cutoff = 0.95;
frame_cutoff = 105;

plotTrajectoriesMakeVideo_LH_And_Frame(dlc_OBJ,likelihood_cutoff, frame_cutoff)

%% Distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dlc_Obj = plotVelocity(dlc_OBJ);

%% plot distance with likelihood cutoff

likelihood_cutoff = 0.95;
dlc_Obj = plotVelocity(dlc_OBJ, likelihood_cutoff);

%% Quadrants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dlc_Obj = plotTimeSpentInQuadrants(dlc_Obj);

%% plot time in quadrants with likelihood cutoff
likelihood_cutoff = 0.95;
dlc_Obj = plotTimeSpentInQuadrants(dlc_Obj, likelihood_cutoff);
