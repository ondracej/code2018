%avianSWRAnalysis_SCRIPTS

close all
clear all
dbstop if error

% Code dependencies
pathToCodeRepository = 'C:\Users\Administrator\Documents\code\GitHub\code2018\';
pathToOpenEphysAnalysisTools = 'C:\Users\Administrator\Documents\code\GitHub\analysis-tools\';
pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\code2018\NSKToolBox\';

addpath(genpath(pathToCodeRepository)) 
addpath(genpath(pathToOpenEphysAnalysisTools)) 
addpath(genpath(pathToNSKToolbox)) 

%% Define Session
recSession = 61; % One session at a time;
%recSession = 82; % One session at a time;
D_OBJ = avianSWRAnalysis_OBJ(recSession);
disp([D_OBJ.INFO.birdName ': ' D_OBJ.Session.time])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting 
%% Multi-channel Plot

%doPlot = 1; % Make and print plots
%seg_s = 50; % segment to plot (in s)

%D_OBJ = batchPlotDataForOpenEphys_multiChannel(D_OBJ, doPlot, seg_s);
D_OBJ = batchPlotDataForOpenEphys_multiChannel(D_OBJ);

%% Single Channel Plot

doPlot = 1; % Make and print plots
seg_s = 50; % segment to plot (in s)

%D_OBJ = batchPlotDataForOpenEphys_singleChannel(D_OBJ, doPlot, seg_s);
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing for Sebastians ShWR detections

%% FullFile - creates a "_py_fullFile"
%chanOverride = [];

D_OBJ = prepareDataForShWRDetection_FullFile_Python(D_OBJ, 5); 
%[D_OBJ] = prepareDataForShWRDetection_FullFile_Python(D_OBJ);

%%
%chanOverride = [];
%durOverride = [];

%D_OBJ  = prepareDataForShWRDetection_Python(D_OBJ, chanOverride, durOverride);
D_OBJ  = prepareDataForShWRDetection_Python(D_OBJ);


%% Confirm Detections - not actually using this for now....

% This should be in the code/SWR/Data directory % export_ripples, copy back into directory

confirmSWR_PythonDetections(D_OBJ) % I cannot figure out how to include this in the analysis object...

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SWR Plotting

% Mean shape, saves the snippets for the detections "SWR_data.mat"
SWR_PythonDetections_shapeStatistics(D_OBJ)

pathToChronuxToolbox = 'C:\Users\Administrator\Documents\code\GitHub\chronux\';
addpath(genpath(pathToChronuxToolbox)) 

SWR_wavelet(D_OBJ)

SWR_raster(D_OBJ)

%% Spikesorting withh KiloSort

% Make sure the Phy is closed before running

pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort\';
pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';

addpath(genpath(pathToKiloSort))
addpath(genpath(pathToNumpy))
            
pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\'; 
%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_6088.m';
nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915.m';
%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915_test.m';
%nameOfConfigFile =  'StandardConfig_avian16Chan_Chick10';
runKilosortFromConfigFile(D_OBJ, pathToYourConfigFile, nameOfConfigFile)

%% Running Phy
% navigate to data directory in cmd window (the location of the .dat file)
% activate phy
% template-gui params.py

%% Analysis using the Sleep code

[D_OBJ] = getFreqBandDetection(D_OBJ);

[D_OBJ] = plotDBRatio(D_OBJ);




