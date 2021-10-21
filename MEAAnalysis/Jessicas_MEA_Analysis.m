%% Jessica's Analysis



%% 1) convert files to a .h5 format with the Multi Channel DataManager


%% 2) Spike Analysis (cntrl + enter) 

% 2.1 convert .h5 files to plexon format


ChannelsToLoad = [28 74]; % channels of interest
fileToLoad = 'Z:\20210923\Output\20210923-1429.h5'; % .h5 file to load
SpikeOutputDir= 'Z:\20210923\Spike_Output\'; % spike output driectory (end with \ )


addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

ConvertMCRackDataToPlexon(ChannelsToLoad, fileToLoad, SpikeOutputDir)

% 2.2 Load the file in the Plexon Spike Sorter

% Make sure to save the file as
% 1. Export Per-Waveform data (you will have to do this for each channel sorted
% - make sure to name the file with '__71 (the channel number) at the end
% 2. Export to New .PLX



%% 2.2 After spikesorting - make spike rasters for sorted data

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

makeSpikeRastersForMEAAnalysis



%% 3) SWR analysis % cntrl + enter

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));
addpath(genpath('C:\Users\dlc\Documents\GitHub\McsMatlabDataTools\'));

dbstop if error

fileToLoad = 'Z:\20210827\Output\20210827-1341.h5'; % .h5 file to load
saveDir = 'Z:\20210827\SWR_Detection\';              
             
ChannelsToNoTIncludeInDetections = [12 22 42 71 84];   

%addpath(genpath('C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools'));

loadingMCSData_filterAndDetectSWRs_Jessica(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)

%% 4) Hamed's SWR plotter analysis % Must run in Matlab2018a

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

DetectionFileToAnalyze = 'Z:\20210826\SWR_Detections\20210826-1254-recovery\20210826-1254-recovery-Detections.mat';
DetectionNumberToAnalyze = [1 3 7 10 15 16 19 20 23 28 29 31 32 35 38 40 42 45];

SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze)

%SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze, [])


%%