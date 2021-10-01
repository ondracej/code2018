%% Jessica's Analysis



%% 1) convert files to a .h5 format with the Multi Channel DataManager


%% 2) Spike Analysis (cntrl + enter) 

% 2.1 convert .h5 files to plexon format


ChannelsToLoad = [17 21 24 74 77 87]; % channels of interest
fileToLoad = 'Z:\20210826\Output\20210826-1459.h5'; % .h5 file to load
SpikeOutputDir= 'Z:\20210826\Spike_Output\'; % spike output driectory (end with \ )


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

fileToLoad = 'Z:\20210809\Output\20210809-16-17.h5'; % .h5 file to load
saveDir = 'Z:\20210809\SWR-Detections\';              
             
ChannelsToNoTIncludeInDetections = [21 12 22 13 23 33 34 64 66];   

%addpath(genpath('C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools'));

loadingMCSData_filterAndDetectSWRs_Jessica(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)

%% 4) Hamed's SWR plotter analysis % Must run in Matlab2018a

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

DetectionFileToAnalyze = 'Z:\20210809\SWR-Detections\20210809-16-03\20210809-16-03-Detections.mat';
DetectionNumberToAnalyze = [1 2 6 7 8 9];

SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze)

%SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze, [])


%%