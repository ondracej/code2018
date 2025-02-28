
%% [1] Initialize the program
% *** To run a cell, type STRG + Enter

addpath(genpath('C:\Users\SWR-Analysis\Documents\GitHub\code2018'));
cd 'C:\Users\SWR-Analysis\Documents\GitHub\code2018\MEAAnalysis\'

analysisDir = 'F:\Johanna_MEA_Data\20220603\'; % path to the analysis directory %% CHANGE THIS 
mea_OBJ = MEA_Analysis_OBJ(analysisDir);

                %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To load / save analysis data
                %% Save object - to save the object in the middle of the analysis
                mea_OBJ = saveCurrentAnalysis(mea_OBJ, analysisDir);

                %% Load an analysis object - only use if zou have previous analysis to load
                mea_OBJ = loadAnalysisObject(mea_OBJ, analysisDir);
                %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To load / save analysis data

%% Before continuing this analysis

% 0) Move the files into the newly created directorie
% 1) Use the "Analyzer rack" to identify:
    %1a) All noisy channles to exclude for the SWR analysis == "SWR_Analysis_noisy_channels" 
    %1b) 5 channels with good SWRs
    %1c) All channles that have large amplitude spikes for the firing rate == "Firing_Rate_Analysis_channels_with_spikes"    
% 2) Convert the .mcs file into a HDF% (.h5) file 

%% [2] Inititialize the analysis -- select the file to analyze
% Need 1) noisy channels, 2) 5 SWR channels, 3) spiking channels

mea_OBJ = addAnalysisInfoToObj(mea_OBJ);

%mea_OBJ = addAnalysisInfoToObj_noSWR(mea_OBJ);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% SWR Analysis
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SWR Detection Analysis - this takes a long time

mea_OBJ = load_MCS_data_detectSWRs_SW_detection(mea_OBJ);
%mea_OBJ = load_MCS_data_detectSWRs_zscore_detection(mea_OBJ);
%mea_OBJ  = load_MCS_data_detectSWRs_rippleDetection(mea_OBJ);

mea_OBJ = collectAllSWRDetections(mea_OBJ);
% printing figures
%mea_OBJ = plotSWRDetection(mea_OBJ);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Analysis on SWRs 

SWRAnalysisDir = 'Z:\hameddata2\Janie-MEA-Data\JohannasData2022\20220503\SWR_Analysis\20220503_1538_SWR_Detections\'; %% CHANGE THIS 
cd(SWRAnalysisDir);

%% Validate detected SWRs
mea_OBJ = validateSWRDetections(mea_OBJ);

%% Plot valid SWRs 
textSave = 'Baseline';
mea_OBJ = plotValidSWRDetections(textSave , SWRAnalysisDir, mea_OBJ);

%% Make delay plot
textSave = 'Baseline';
mea_OBJ = calculateDelaysfromValidSWRs_makePlots(textSave, mea_OBJ);

%% SWR statistics 

SWR_Ind = 3;
SWR_Chans = [32 33 34 35 36 37 38]; % Maximum 7 channels
textSave = 'Baseline';
mea_OBJ = calcSWRStatistics_SWR_Ind_And_Chan(textSave, SWRAnalysisDir, SWR_Ind, SWR_Chans, mea_OBJ);


%%
%mea_OBJ = calcSWRStatistics(SWRAnalysisDir, mea_OBJ);

%%

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

textSave = 'Baseline';
mea_OBJ = FiringRateAnalysis_makeRasters(mea_OBJ, textSave);

%% Standalone code

spikeDir = 'Z:\JanieData\MEA-Projects\JessicaMeaData\20210826\Firing_Rate_Analysis\';

doAnalysisFiringRateComparison(spikeDir, mea_OBJ, 1);



%checkSpikesOnSortedData()
 
%makeSummaryPlotFiringRatePharmacology
% Compare baseline and recover firing rates
