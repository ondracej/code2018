%% Johanna's Analysis

%% 1) convert files to a .h5 format with the Multi Channel DataManager

%% 1A Look at the data with Analyzer rack!!  = Identify noisy channels
 % - identify channels with spikes

%% 2) SWR analysis % cntrl + enter


fileToLoad = 'F:\Johanna_MEA_Data\20220404\h5_output\20220404-1430-Recovery.h5'; % .h5 file to load
saveDir = 'F:\Johanna_MEA_Data\20220404\swr_analysis';         %make sure it ends with a \     
             
ChannelsToNoTIncludeInDetections = [];  % numbers of noisy channles, otherwise leave empty: [] 

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));
addpath(genpath('C:\Users\dlc\Documents\GitHub\McsMatlabDataTools\'));
dbstop if error

%addpath(genpath('C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools'));

MEA_Analysis__loadingMCSData_filterAndDetectSWRs(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)

%% 3) SWR plotter analysis 

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

DetectionFileToAnalyze = 'E:\MEA_Data\allSWRData\20210809\swr_analysis\20210809-16-03-Detections.mat';
DetectionNumberToAnalyze = [1 10 12 ];

SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze)

%SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze, [])


%% 4) Spike Analysis (cntrl + enter) 

% 2.1 convert .h5 files to plexon format

ChannelsToLoad = [42 62 38]; % channels of interest
fileToLoad = 'F:\Johanna_MEA_Data\20220404\h5_output\20220404-1430-Baseline.h5'; % .h5 file to load
SpikeOutputDir= 'F:\Johanna_MEA_Data\20220404\spike_output\'; % spike output driectory (end with \ )


addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

MEA_Analysis__ConvertMCRackDataToPlexon(ChannelsToLoad, fileToLoad, SpikeOutputDir)

% 2.2 Load the file in the Plexon Spike Sorter

% Make sure to save the file as
% 1. Export Per-Waveform data (you will have to do this for each channel sorted
% - make sure to name the file with '__71 (the channel number) at the end
% 2. Export to New .PLX - this takes a long time



%% 2.2 After spikesorting - make spike rasters for sorted data

addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

makeSpikeRastersForMEAAnalysis

