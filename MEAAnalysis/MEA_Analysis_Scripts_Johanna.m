
%% Initialize the program

analysisDir = 'E:\MEA_Data\allSWRData\20210813\'; % path to the analysis directory
mea_OBJ = MEA_Analysis_OBJ(analysisDir);

%% Before continuing this analysis

%% 0) Move the files into the newly created directories

%% 1)  Use the "Analyzer rack" to identify:
    %1a) All noisy channles to exclude for the SWR analysis == "SWR_Analysis_noisy_channels" 
    %1b) All channles that have large amplitude spikes for the firing rate == "Firing_Rate_Analysis_channels_with_spikes"    

%% 2)  Convert the .mcs file into a HDF% (.h5) file 

%% Inititialize the analysis

mea_OBJ = addAnalysisInfoToObj(mea_OBJ);

%% SWR Analysis

%mea_OBJ = load_MCS_data_detectSWRs_rippleDetection(mea_OBJ);
mea_OBJ = load_MCS_data_detectSWRs_zscore_detection(mea_OBJ);

mea_OBJ = collectAllSWRDetections(mea_OBJ);

% printing figures
mea_OBJ = plotSWRDetection(mea_OBJ);

%% 

mea_OBJ = validateSWRDetections(mea_OBJ);

% SWR validation - base this off of the grid plotting combined with 
% SWRValidation_key_press

% Delay plotter
% SWR_delay_map_plotter_function(DetectionFileToAnalyze, DetectionNumberToAnalyze)

%% SWR statistics
% save this as a mat files

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

%checkSpikesOnSortedData()
 
%makeSummaryPlotFiringRatePharmacology
% Compare baseline and recover firing rates
