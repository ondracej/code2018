
%% [1] Initialize the program
% *** To run a cell, type STRG + Enter

close all
clear all

analysisDir = 'Y:\Janie-MEA-Data\Esra-MEA2025\July2025\20250731\'; % path to the analysis directory
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



%% (1) %% Firing rate analysis on 1 file
spikeDir = 'Y:\Janie-MEA-Data\Esra-MEA2025\July2025\20250730\Firing_Rate_Analysis\';

mea_OBJ = FiringRateAnalysis_singleChannel(spikeDir, mea_OBJ);

%% (1) Firing rate analysis across 3 files (baseline, drug, and recovery)

cd(spikeDir)

mea_OBJ = FiringRateAnalysis_singleChannel_Base_Drug_Rec(spikeDir, mea_OBJ);

%%  (2) To combine clusters in a file

fileToCombineSpikes = '20250721-1639mcd_CH-13-23-62-84-_SpikeData__84.mat'; % make sure to include .mat
Spike_Counts_To_Combine = [793 166]; % enter the spike numbers (read from the other figure)

combineSpikesInFile_PlotNewFiringRateAnalysis(spikeDir, fileToCombineSpikes,Spike_Counts_To_Combine, mea_OBJ); % this will give unit ID 5

%% View the spike sorting statistics for a BASELINE DRUG RECOVERY COMPARISON

UnitsIDs_base_drug_rec = [5 1 5]; % Baseline, drug, recovery Cluster IDs

doAnalysis_Base_Drug_Rec_Comparison(spikeDir, UnitsIDs_base_drug_rec, mea_OBJ);

%% Combine the spikes from a sorted single channel 

%mea_OBJ = FiringRateAnalysis_makeRasters(spikeDir, mea_OBJ);


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


