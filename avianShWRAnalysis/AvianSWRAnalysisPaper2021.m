%% Avian SWR Analysis Paper 2021


%% Spike Sorting

SpikeSortingNotes_JO2021
main_kilosort

%'4ShankChanMap.mat;
configFileJO20211115

dataDir = 'G:\SWR\ZF-72-96\20200108\15-02-07\Ephys\';
%chanMap = [2 1 5 11 14 4 8 7 15 16 6 12 13 3 9 10]; % For 72-01 - ML
chanMap = [11 5 1 2 7 8 4 14 12 6 16 15 10 9 3 13]; % For 72-96 - ML

convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys
%% SWR detection 

examineSWRDataForPassbands
detectSWRsJO_2021_FrankMethod
analyzeSWRDetections_2021
averageOverSWRDelayPlots

%% LFP analysis during natural sleep 

plotDBRatioMatrix_standalone

plotDBRatioWithData(D_OBJ)

plotDBRatioMatrix(D_OBJ)

plotPowerSpectrum(D_OBJ)


%%

getTrigsFromOEPSFile
plotDOS_ratioForNights

%%
compareSWRStatsAcrossNights

%% Time Series Viewer



%%

addpath(genpath('C:\Users\Neuropix\Documents\GitHub\NeuralElectrophysilogyTools\'));

dataDir = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-23_22-43-29\Ephys';
dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels





