%% Jessica's Analysis



%% 1) convert files to a .h5 format with the Multi Channel DataManager


%% 2) Spike Analysis (cntrl + enter) 

% 2.1 convert .h5 files to plexon format


ChannelsToLoad = [16 23 24 33 34 43 44 54 61 66 67 ]; % channels of interest
fileToLoad = 'Z:\20210831\Output\20210831-1134.h5'; % .h5 file to load
SpikeOutputDir= 'Z:\20210831\Spike_Output\'; % spike output driectory (end with \ )


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

fileToLoad = 'Z:\20210819\Output\20210819-1207.h5'; % .h5 file to load
saveDir = 'Z:\20210819\SWR_Detection\';              
             
ChannelsToNoTIncludeInDetections = [12 22 71];   

%addpath(genpath('C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools'));

loadingMCSData_filterAndDetectSWRs_Jessica(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)

%% 4) Hamed's SWR plotter analysis % Must run in Matlab2018a

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

DetectionFileToAnalyze = 'Z:\20210809\SWR-Detections\20210809-16-17\20210809-16-17-Detections.mat';
DetectionNumberToAnalyze = [1 2 6 7 8 9];

SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze)

%SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze, [])


%%