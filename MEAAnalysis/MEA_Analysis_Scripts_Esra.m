
%% [1] Initialize the program
% *** To run a cell, type STRG + Enter

close all
clear all

analysisDir = 'Z:\hameddata2\Janie-MEA-Data\Esra-MEA2025\20250729\'; % path to the analysis directory
mea_OBJ = MEA_Analysis_OBJ(analysisDir);

% 
%                 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To load / save analysis data
%                 %% Save object - to save the object in the middle of the analysis
%                 mea_OBJ = saveCurrentAnalysis(mea_OBJ, analysisDir);
% 
%                 %% Load an analysis object - only use if zou have previous analysis to load
%                 mea_OBJ = loadAnalysisObject(mea_OBJ, analysisDir);
%                 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To load / save analysis data

%% Before continuing this analysis

% 0) Move the files into the newly created directorie
% 1) Use the "DataViewer Rack rack" to identify:
    %1a) All channles that have large amplitude spikes for the firing rate == "Firing_Rate_Analysis_channels_with_spikes"    
% 2) Convert the .mcs file into a HDF5 (.h5) file 

%% [2] Inititialize the analysis -- select the file to analyze
% Need 1) noisy channels, 2) 5 SWR channels, 3) spiking channels

mea_OBJ = addAnalysisInfoToObj_noSWR(mea_OBJ);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Firing Rate Analysis
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%cd(mea_OBJ.PATH.h5Files)
mea_OBJ = convertH5DataToPlexonMatlabFormat(mea_OBJ);

%% Spike sort the files using the plexon offline sorter

% Use the same filter for all of the data (ie, butterworth, 2pole)
% Make sure to save the file as
% 1. Export Per-Waveform data (you will have to do this for each channel sorted)
% - make sure to name the file with '__71 (the channel number) at the end
% 2. When you are all done sorting all the channels, export to New .PLX - this takes a long time

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% After spike sorting

spikeDir = 'Z:\hameddata2\Janie-MEA-Data\Esra-MEA2025\20250729\Firing_Rate_Analysis\';

%mea_OBJ = FiringRateAnalysis_makeRasters(spikeDir, mea_OBJ);

mea_OBJ = FiringRateAnalysis_singleChannel(spikeDir, mea_OBJ);

%%
mea_OBJ = FiringRateAnalysis_singleChannel_Base_Drug_Rec(spikeDir, mea_OBJ);

%%

fileToCombineSpikes = '20250729-1401DrugNRecoverE_CH-87-_SpikeData-recovery__87.mat'; % make sure to include .mat
Spike_Counts_To_Combine = [1973 803 56];

combineSpikesInFile_PlotNewFiringRateAnalysis(spikeDir, fileToCombineSpikes,Spike_Counts_To_Combine, mea_OBJ);


%% View the spike sorting statistics for a single channel

UnitsIDs_base_drug_rec = [5 5 5];

doAnalysis_Base_Drug_Rec_Comparison(spikeDir, UnitsIDs_base_drug_rec, mea_OBJ);

%% Combine the spikes from a sorted single channel 




%%
%checkSpikesOnSortedData()
 
%makeSummaryPlotFiringRatePharmacology
% Compare baseline and recover firing rates

%% Make a plot of overall spiking activity on array

fileToLoad = 'D:\Esra-MEA\20250717\_h5_files\20250717-1524.h5'; % .h5 file to load
saveDir = mea_OBJ.PATH.spikeAnalysis_plotDir;            
ChannelsToNoTIncludeInDetections = [];  % numbers of noisy channles, otherwise leave empty: [] 

dbstop if error

%addpath(genpath('C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools'));


% Z = (x - mean(pop))/std(pop)

warning('on','all')
MEA_Analysis__loadingMCSData_calculate_spatial_spike_amplitude(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)


