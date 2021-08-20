%% Jessica's Analysis



%% 1) convert files to a .h5 format with the Multi Channel DataManager


%% 2) Spike Analysis (cntrl + enter) 

% 2.1 convert .h5 files to plexon format


ChannelsToLoad = [25 32 36 53 55 65 67 75 83 86]; % channels of interest
fileToLoad = 'E:\Jessica-Data\20210812\Output\20210812-1133.h5'; % .h5 file to load
SpikeOutputDir= 'E:\Jessica-Data\20210812\Spike Output\'; % spike output driectory (end with \ )


addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\avianShWRAnalysis'));

ConvertMCRackDataToPlexon(ChannelsToLoad, fileToLoad, SpikeOutputDir)

% 2.2 Load the file in the Plexon Spike Sorter

%% 3) SWR analysis % cntrl + enter

dbstop if error

fileToLoad = 'E:\Jessica-Data\20210811\Output\20210811-1338.h5'; % .h5 file to load
saveDir = 'E:\Jessica-Data\20210811\SWR_Detections\';
ChannelsToNoTIncludeInDetections = [12 22 13 23 64];

addpath(genpath('C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools'));

loadingMCSData_filterAndDetectSWRs_Jessica(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)



