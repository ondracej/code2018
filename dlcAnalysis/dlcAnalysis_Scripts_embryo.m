%% DLC Analysis Scripts for tracking movement in chicken embryo
% written by Janie Ondracek, janie.ondracek@tum.de

%% 1) Define analysis directory
analysisDir = 'G:\EmbryoAnalysis\BT18_140222-2_040222\'; % path to the analysis directory, should contain the 'BL', 'postPain', and 'postTouch' directories

dlc_OBJ = dlcAnalysis_OBJ_embryo(analysisDir);

%% 2) Load csv files 

    whichExperiment = 1; % 1: BL; 2: postPain; 3: postTouch
    isFiltered = 0;
    dlc_OBJ = loadTrackedData(dlc_OBJ, whichExperiment, isFiltered);


%% 3) Load Video data

%dlc_OBJ = loadVideoData(dlc_OBJ);

%% 3) Analysis
% plot likelihood
plot_liklihood_over_time(dlc_OBJ, whichExperiment)

% plot x coordinates
x_or_y = 1; % 1) x coords; 2) y coords;
plot_coords_over_time(dlc_OBJ, whichExperiment, x_or_y)

% plot y coordinates
x_or_y = 2; % 1) x coords; 2) y coords;
plot_coords_over_time(dlc_OBJ, whichExperiment, x_or_y)

% plot detection clusters
likelihood_cutoff = 0.0;
dlc_OBJ = plotDetectionClusters(dlc_OBJ, whichExperiment, likelihood_cutoff);

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
