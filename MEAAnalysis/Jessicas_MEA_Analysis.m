%% Jessica's Analysis



%% 1) convert files to a .h5 format with the Multi Channel DataManager


%% 2) Spike Analysis (cntrl + enter) 

% 2.1 convert .h5 files to plexon format


ChannelsToLoad = [57 65]; % channels of interest
fileToLoad = 'Z:\20210816\Output\20210816-1352.h5'; % .h5 file to load
SpikeOutputDir= 'Z:\20210816\Spike Output\'; % spike output driectory (end with \ )


addpath(genpath('C:\Users\dlc\Documents\GitHub\code2018\'));

ConvertMCRackDataToPlexon(ChannelsToLoad, fileToLoad, SpikeOutputDir)

% 2.2 Load the file in the Plexon Spike Sorter

%% 3) SWR analysis % cntrl + enter

dbstop if error

fileToLoad = 'Z:\20210810\Output\20210810-1631.h5'; % .h5 file to load
saveDir = 'Z:\20210810\SWR Detection\';              
             
ChannelsToNoTIncludeInDetections = [ 21 12 22 13 23];   

%addpath(genpath('C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools'));

loadingMCSData_filterAndDetectSWRs_Jessica(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)



