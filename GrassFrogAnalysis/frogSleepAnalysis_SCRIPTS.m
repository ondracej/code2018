%% frogSleepAnalysis_SCRIPTS

close all
clear all
dbstop if error


if ispc
    
    % Code dependencies
    pathToCodeRepository = 'C:\Users\Administrator\Documents\code\GitHub\code2018\';
    pathToOpenEphysAnalysisTools = 'C:\Users\Administrator\Documents\code\GitHub\analysis-tools\';
    pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\code2018\NSKToolBox\';
elseif isunix
    pathToCodeRepository = '/home/janie/Documents/code/code2018/';
    pathToOpenEphysAnalysisTools = '/home/janie/Documents/code/analysis-tools-master/';
    pathToNSKToolbox = '/home/janie/Documents/code/NET-master/';
end

    
addpath(genpath(pathToCodeRepository)) 
addpath(genpath(pathToOpenEphysAnalysisTools)) 
addpath(genpath(pathToNSKToolbox)) 

%% Define Session

%recSession = 44; % 20190624_19-14

%recSession = 46; % 20190625_08-32;
%recSession = 50; % 20190626_09-00
%recSession = 54; % 20190627_08-43
%recSession = 56; % 20190628_10-01
%recSession = 63; % 20190630_16-39
%recSession = 69; % 20190630_16-39 -corrupted??

% Frog 2
 recSession = 108; % 20190624_19-14
 
 
 
 
 %% Frog

%dir = 'H:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_08-43\Ephys\2019-06-27_08-43-09';
%dir = 'H:\Grass\FrogSleep\CubanTreeFrog1\20190624\20190624_19-14\Ephys\2019-06-24_19-14-36';



dir = '/home/janie/Data/TUM/SleepChicken/Ephys/Chick1/Chick1K-X_2018-04-27_16-43-53/';
dbstop if error
dataRecordingObj = OERecordingMF(dir);

%% 
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject
timeSeriesViewer(dataRecordingObj); % loads all the channels

 
 
 %%
D_OBJ = frogSleepAnalysis_OBJ(recSession); 
disp([D_OBJ.INFO.Name ': ' D_OBJ.Session.time])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Multi-channel Plot

%doPlot = 1; % Make and print plots
%seg_s = 50; % segment to plot (in s)

%D_OBJ = batchPlotDataForOpenEphys_multiChannel(D_OBJ, doPlot, seg_s);
D_OBJ = batchPlotDataForOpenEphys_multiChannel(D_OBJ); % default is doPlot, 40s
disp('Finished plotting')

%% 

D_OBJ = getTriggers(D_OBJ); 
disp('Triggers Finished')
%%

convertMP4toAVI(D_OBJ)

%%
FrameON = 17000; % 2:40
FrameOFF = 17300; % 2:45
ChanSelOverride = [1, 2, 3, 4, 5];
saveName = 'Test1-jumping';
combineEphysAndMovie(D_OBJ, FrameON, FrameOFF, saveName, ChanSelOverride)


%% Single Channel Plot

%D_OBJ = batchPlotDataForOpenEphys_singleChannel(D_OBJ, doPlot, seg_s); % default is doPlot, 40s
D_OBJ = batchPlotDataForOpenEphys_singleChannel(D_OBJ); % default is doPlot, 40s
 

%% Wavelet

seg_s = 180;
waveletPlot_singleChannel(D_OBJ, seg_s)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing for Sebastian's ShWR detections
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FullFile - creates a "_py_fullFile"

%chanOverride = 7;
%D_OBJ = prepareDataForShWRDetection_FullFile_Python(D_OBJ, chanOverride); 
[D_OBJ] = prepareDataForShWRDetection_FullFile_Python(D_OBJ);

%% Do NOT USE - use fullfile option for now
%chanOverride = [];
%durOverride = [];

%D_OBJ  = prepareDataForShWRDetection_Python(D_OBJ, chanOverride, durOverride);
%D_OBJ  = prepareDataForShWRDetection_Python(D_OBJ);

%% Confirm Detections - not actually using this for now....

% This should be in the code/SWR/Data directory % export_ripples, copy back into directory
%confirmSWR_PythonDetections(D_OBJ) % I cannot figure out how to include this in the analysis object...

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SWR Plotting
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mean shape, saves the snippets for the detections "SWR_data.mat"


%% Remember to change the data name to x_data

useNotch =0;

[D_OBJ] = SWR_PythonDetections_shapeStatistics(D_OBJ, useNotch );

pathToChronuxToolbox = 'C:\Users\Administrator\Documents\code\GitHub\chronux\';
addpath(genpath(pathToChronuxToolbox)) 

%% Wavelet
waveletInd = 5;
useNotch = 1;
[D_OBJ] = SWR_wavelet(D_OBJ, waveletInd, useNotch );

%% Frequency raster
binSize_s = 15;
[D_OBJ] = SWR_raster(D_OBJ, binSize_s);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Spikesorting with KiloSort
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Make sure the Phy is closed before running!!!
% 
% pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort\';
% pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';
% 
% addpath(genpath(pathToKiloSort))
% addpath(genpath(pathToNumpy))
%             
% pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\'; 
% 
% % Config Files - check that the channel map is set correctly there!
% %nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_6088.m';
% nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915.m';
% %nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_7281.m';
% %nameOfConfigFile =  'StandardConfig_avian16Chan_Chick10';
% runKilosortFromConfigFile(D_OBJ, pathToYourConfigFile, nameOfConfigFile)
% 
% disp(['Finished Processing ' D_OBJ.Session.SessionDir])

%%

pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort2\';
pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';
addpath(genpath(pathToKiloSort))
addpath(genpath(pathToNumpy))

%pathToGUIToolbox = 'C:\Users\Administrator\Documents\MATLAB\';
%addpath(genpath(pathToGUIToolbox))

pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles'; 

% Config Files - check that the channel map is set correctly there!

nameOfConfigFile =  'StandardConfig_CubanTF1_16Chan_ECoG_K2';


%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_21-05-36';
%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_18-07-21';
%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_18-48-02'; 

%chanMap = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\chanMap16ChanSilicon.mat';

runKilosort2fromConfigFile(D_OBJ, pathToYourConfigFile, nameOfConfigFile)
disp(['Finished Processing ' D_OBJ.Session.SessionDir])

%% Running Phy
% navigate to the data directory in cmd window (the location of the .dat file)
%> activate phy
%> phy template-gui params.py
% pip install git+https://github.com/kwikteam/phy git+https://github.com/kwikteam/phy-contrib --upgrade
%% Make sure to save which channels have which clusters on them!!

D_OBJ = avianSWRAnalysis_OBJ(recSession); 


%% Make plots of spikes aligned to SWRs

addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\npy-matlab'))
addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\spikes'))

ClustType = 2;
% - 0 = noise
% - 1 = mua
% - 2 = good
% - 3 = unsorted

[D_OBJ] = importPhyClusterSpikeTimes(D_OBJ, ClustType);

%% Make plots of the spikes
ClustType = 1;
if ~isfield(D_OBJ.REC, 'GoodClust_2') || ~isfield(D_OBJ.REC, 'MUAClust_1')
    disp('***Make sure to set the cluster information in the database before running!***')
else
    [D_OBJ]  = loadClustTypesAndMakeSpikePlots(D_OBJ, ClustType);    
end
disp('Finished plotting...')
%%

chanSelectionOverride = [];

ClustType = 1;

%[D_OBJ]  = loadClustTypesAndAlignToSWR_Raster(D_OBJ, chanSelectionOverride);
[D_OBJ]  = loadClustTypesAndAlignToSWR_Raster_ClustType(D_OBJ, ClustType);


%% Analysis using the Sleep code


[D_OBJ] = getFreqBandDetection(D_OBJ);
disp('Finished Printing dendrograms')

%%



[D_OBJ] = plotDBRatioWithData(D_OBJ);

%%

plotDBRatioMatrix(D_OBJ)


%%





