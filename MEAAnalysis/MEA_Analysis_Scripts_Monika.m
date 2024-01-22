
%% [1] Initialize the program
% *** To run a cell, type STRG + Enter


addpath(genpath('D:\Github\code2018'));
cd 'D:\Github\code2018\MEAAnalysis\'


analysisDir = 'F:\20220622\'; % path to the analysis directory
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
% 1) Use the "Analyzer rack" to identify:
    %1a) All channles that have large amplitude spikes for the firing rate == "Firing_Rate_Analysis_channels_with_spikes"    
% 2) Convert the .mcs file into a HDF5 (.h5) file 

%% [2] Inititialize the analysis -- select the file to analyze
% Need 1) noisy channels, 2) 5 SWR channels, 3) spiking channels

mea_OBJ = addAnalysisInfoToObj_noSWR(mea_OBJ);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Firing Rate Analysis
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mea_OBJ = convertH5DataToPlexonMatlabFormat(mea_OBJ);

%% Spike sort the files using the plexon offline sorter

% Use the same filter for all of the data (ie, butterworth, 2pole)
% Make sure to save the file as
% 1. Export Per-Waveform data (you will have to do this for each channel sorted)
% - make sure to name the file with '__71 (the channel number) at the end
% 2. When you are all done sorting all the channels, export to New .PLX - this takes a long time

%% After spike sorting

mea_OBJ = FiringRateAnalysis_makeRasters(mea_OBJ);

%%
spikeDir = 'F:\20220622\Firing_Rate_Analysis\';
doAnalysisFiringRateComparison(spikeDir, mea_OBJ, 2);

%%
%checkSpikesOnSortedData()
 
%makeSummaryPlotFiringRatePharmacology
% Compare baseline and recover firing rates
