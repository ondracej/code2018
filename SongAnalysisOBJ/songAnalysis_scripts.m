
%% Song Analysis - Scripts

analysisDir = '/home/janie/Data/ArtemisDataToAnalyze/'; % path to the analysis directory, should contain the .csv files
birdName = 'w027';
last100Songs_dph = 'dph59';


addpath(genpath('/home/janie/Documents/code/code2018/SongAnalysisOBJ/'));
song_OBJ = songAnalysis_OBJ(analysisDir, birdName, last100Songs_dph);

%% Load Data

song_OBJ = loadData_xls(song_OBJ);

%% Cluster syllables


fileSwitch = 1; % 1 == last 100 files; 2 == first 100 files;
[song_OBJ] = clusterSyllables(song_OBJ, fileSwitch);

%% Plot Clustered Variables


fileSwitch = 1; % 1 == last 100 files; 2 == first 100 files;
[song_OBJ] = plotSongVariableClusters(song_OBJ, fileSwitch);



