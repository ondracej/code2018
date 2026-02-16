%% DLC Analysis Scripts

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathToCodeRepository = 'C:\Users\Neuropix\Documents\GitHub\code2018\';
addpath(genpath(pathToCodeRepository)) 

% Define paths

close all
clear all

%% Change this informaiton here

analysisDir = 'X:\tadpoledata-khaled\'; %make sure that it ands with a \
nAnimals = 5;
filtered = 1; % 1 use filtered data, 0, use unfiltered data
%%
dlc_OBJ = dlcAnalysis_OBJ_tadpole(analysisDir, filtered, nAnimals);


%% Load tracked data

dlc_OBJ = loadTrackedData_multianimalTadpole(dlc_OBJ);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
likelihood_cutoff = 0.65;
dlc_Obj = plotVelocity(dlc_OBJ, likelihood_cutoff);
dlc_Obj = plotVelocity(dlc_OBJ);






%% Trajectories %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot trajectories
dlc_OBJ = plotTrajectories(dlc_OBJ);

%% plot trajectories with likelihood cutoff

likelihood_cutoff = 0.65;

[dlc_OBJ ] = plotTrajectories_with_likelihood(dlc_OBJ, likelihood_cutoff);

%% Videos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotTrajectoriesMakeVideo(dlc_OBJ);

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
