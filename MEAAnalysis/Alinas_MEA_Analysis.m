%% Alina's Analysis



%% 1) convert files to a .h5 format with the Multi Channel DataManager


%% 2) Spike Analysis (cntrl + enter) 

% 2.1 convert .h5 files to plexon format


ChannelsToLoad = [16 36 38 85]; % channels of interest
fileToLoad = 'Z:\20211117\Output\20211117-1501rec.h5'; % .h5 file to load
SpikeOutputDir= 'Z:\20211117\Spikeoutput\'; % spike output driectory (end with \ )


addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

ConvertMCRackDataToPlexon(ChannelsToLoad, fileToLoad, SpikeOutputDir)

%% 2.2 Load the file in the Plexon Spike Sorter

% Make sure to save the file as
% 1. Export Per-Waveform data (you will have to do this for each channel sorted)
% - make sure to name the file with '__71 (the channel number) at the end
% 2. Export to New .PLX


%% 2.2 After spikesorting - make spike rasters for sorted data

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

makeSpikeRastersForMEAAnalysis



%% 3) SWR analysis % cntrl + enter

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));
addpath(genpath('C:\Users\dlc\Documents\GitHub\McsMatlabDataTools\'));

dbstop if error

fileToLoad = 'Z:\20210902\Output\20210902-1507-recovery.h5'; % .h5 file to load
saveDir = 'Z:\20210902\SWR_Detection\';              
             
ChannelsToNoTIncludeInDetections = [12 22 42 52 71 74 84];   

%addpath(genpath('C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools'));

loadingMCSData_filterAndDetectSWRs_Alina(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)

%% 4) Hamed's SWR plotter analysis % Must run in Matlab2018a

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

DetectionFileToAnalyze = 'Z:\20210901\SWR_Detection\20210901-1151-5HT\20210901-1151-5HT-Detections.mat';
DetectionNumberToAnalyze = [2 4 7 8 9 12 15 16 17 19 30 31 35 36 38 41 46 49 61];

SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze)

%SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze, [])


%%