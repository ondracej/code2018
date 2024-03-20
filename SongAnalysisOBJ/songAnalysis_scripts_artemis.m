
%% Song Analysis - Scripts

analysisDir = 'X:\EEG-LFP-songLearning\Artemis\w027_17.01.2024\w027_SongDevelopment\'; % path to the analysis directory, should contain the .csv files
birdName = 'w027';
night_dph = ['dph61'];

addpath(genpath('C:\artemis\Universität\7. WS 2023-24\Bachelor Thesis\Matlab\SongAnalysisOBJ_artemis\'));
song_OBJ = songAnalysis_OBJ_artemis(analysisDir, birdName, night_dph);

%% Load Data

song_OBJ = loadData_xls(song_OBJ);

%% Cluster syllables

fileSwitch = 2; % 1 == last 100 files; 2 == first 100 files;
[song_OBJ] = clusterSyllables(song_OBJ, fileSwitch);

%% Plot Clustered Variables

fileSwitch = 2; % 1 == last 100 files; 2 == first 100 files;
[song_OBJ] = plotSongVariableClusters(song_OBJ, fileSwitch);
