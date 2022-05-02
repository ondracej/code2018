%% DLC Analysis Scripts for tracking movement in chicken embryo
% written by Janie Ondracek, janie.ondracek@tum.de

%% 1) Define analysis directory
analysisDir = 'G:\EmbryoAnalysis\ED18\BT18_280322-2_150422\AllData\'; % path to the analysis directory, should contain the 'BL', 'postPain', and 'postTouch' directories
ExperimentName = 'BT18_280322-2_150422';
likelihood_cutoff = 0.0;
dlc_OBJ = dlcAnalysis_OBJ_embryo(analysisDir, ExperimentName);

%% 2) Load csv files 

dlc_OBJ = loadTrackedData(dlc_OBJ);

%% 3) Load Video data

%dlc_OBJ = loadVideoData(dlc_OBJ);

%% 3) Analysis

plot_variable_over_time(dlc_OBJ, 1) % likelihood
plot_variable_over_time(dlc_OBJ, 2) % x coordinates
plot_variable_over_time(dlc_OBJ, 3) % y coordinates

% plot detection clusters
dlc_OBJ = plotDetectionClusters(dlc_OBJ, likelihood_cutoff);

% plot velocity (euclidean distance)
dlc_Obj = plotVelocity(dlc_OBJ, likelihood_cutoff);

% 
dlc_Obj = makePlotsForDistances(dlc_Obj, 2);

% Box plots,heat maps for 5 s windows
dlc_Obj = makePlotsMeanWindowAnalysis(dlc_Obj, 2);

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
