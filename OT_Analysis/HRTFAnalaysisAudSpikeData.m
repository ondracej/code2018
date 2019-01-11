clear all
dbstop if error
close all

%%
%[OT_DB] = OT_database();

%% Create Chicken Analysis Object

experiment = 2; %efc
recSession = 4; %sc

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%%
audSelInd = 2; % This is the index, not the stim number!!!

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)

%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%
disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
load(objPath);
disp(['Loaded: ' objPath])

%% Define Analysis Window - This is where we plot rasters and audspat RFs

[C_OBJ] = defineAnalysisWindow(C_OBJ);

%%