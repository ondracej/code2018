%% 1) Define analysis directory

analysisDir = 'E:\MEA_Data\allSWRData\20210811\'; % path to the analysis directory, should contain the 'BL', 'postPain', and 'postTouch' directories

mea_OBJ = MEA_Analysis_OBJ(analysisDir);

%% 2) convert .mcd files into .hdf5 files
%% 3) use the 'Analyzer Rack' to look at the raw data and identify all of the noisy channels

%% 4)  SWR Analysis

h5_fileToLoad = 'E:\MEA_Data\allSWRData\20210811\_h5_files\20210811-1442.h5'; % .h5 file to load
ChannelsToNoTIncludeInDetections = [21 12 22 13 23 33 34 64 66];

mea_OBJ = load_MCS_data_detectSWRs(mea_OBJ, fileToLoad, ChannelsToNoTIncludeInDetections);

%%

