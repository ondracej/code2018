%% DLC Analysis Scripts

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathToCodeRepository = '/home/janie/Documents/Code/code2018/';
addpath(genpath(pathToCodeRepository)) 

% Define paths

analysisDir = '/home/janie/Dropbox/tmp/turtle/new/';
VidToAnalyze = 'Video 959.avi';
dlc_OBJ = dlcAnalysis_OBJ(analysisDir, VidToAnalyze);

% Load tracked data

dlc_OBJ = loadTrackedData(dlc_OBJ);

% Load Video data

dlc_OBJ = loadVideoData(dlc_OBJ);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Analysis
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Trajectories %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot trajectories
dlc_Obj = plotTrajectories(dlc_OBJ);

%% plot trajectories with likelihood cutoff

likelihood_cutoff = 0.95;

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
