%% eeg_lfp_song_analysis_SCRIPTS - SCRIPTS


%% PerBird Analysis
 

%% w038
xlsFile = "X:\EEG-LFP-songLearning\JaniesAnalysis\w038\w038.xlsx";

startRow = 2;
endRow  = 31;

P.AllPlots = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\';
P.VideoPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w038\DATA_VIDEO\';
P.EphysPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w038\DATA_EPHYS\';
P.AnalysisPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w038\ANALYSIS\';
P.PlotPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w038\PLOTS\';
P.SongPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w038\Data\';
P.OriginalSongPath = 'X:\EEG-LFP-songLearning\songs\w038\Data\';

%%

data_OBJ = eeg_lfp_song_analysis_OBJ(xlsFile, startRow, endRow, P);

nEntries = data_OBJ.INFO.nEntries;


%% Video analysis
 % Saves plots and mvmt variable to ALL_PLOTS\bird\VideoMvmt\
 for j = 1:nEntries    
     vid_path = data_OBJ.VIDEO.VidDir{j};
     if ~isempty(vid_path)
         analyze_mvmt_in_video_frames(data_OBJ, j)
     end
 end
 
 %% Motif Analysis
 
d = dir(data_OBJ.PATH.SongPath);
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]);

dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
SylInds = [];
for j = 1:numel(dfolders)
    thisName = dfolders(j).name;
    SylInds(j) = sum(strfind(thisName, 'Motifs')); % for motif files
    %SylInds(j) = sum(strfind(thisName, 'Play')); % for playback files
end

dirsToLoad_inds = find(SylInds ~=0);

%% Override
%thisDirToLoad = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w038\Data\2021-09-07-Last100Songs-Motifs\';
%plotDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w038\Motifs\';

%% Create dirs for plots and analysis 
MotifPlotDir = [data_OBJ.PATH.AllPlots data_OBJ.INFO.birdName{:} data_OBJ.PATH.dirD 'Motifs' data_OBJ.PATH.dirD];

if exist(MotifPlotDir , 'dir') == 0
    mkdir(MotifPlotDir );
    disp(['Created: '  MotifPlotDir ])
end

data_OBJ.PATH.MotifPlotDir = MotifPlotDir;

AllEntropyDataDir = [data_OBJ.PATH.AllPlots data_OBJ.INFO.birdName{:} data_OBJ.PATH.dirD 'Entropy' data_OBJ.PATH.dirD];

if exist(AllEntropyDataDir, 'dir') == 0
    mkdir(AllEntropyDataDir);
    disp(['Created: '  AllEntropyDataDir])
end

data_OBJ.PATH.AllEntropyDataDir = AllEntropyDataDir;

bla = find(data_OBJ.PATH.SongPath == data_OBJ.PATH.dirD);
DirInd = bla(end-1);

DirUpOneLevel = data_OBJ.PATH.SongPath(1: DirInd);

TimeInfoSaveDir_motifs =   [DirUpOneLevel  'SongTimeInfo' data_OBJ.PATH.dirD];

if exist(TimeInfoSaveDir_motifs, 'dir') == 0
    mkdir(TimeInfoSaveDir_motifs);
    disp(['Created: '  TimeInfoSaveDir_motifs])
end

data_OBJ.PATH.TimeInfoSaveDir_motifs = TimeInfoSaveDir_motifs;

TimeInfoSaveDir_playbacks =   [DirUpOneLevel  'PlaybackTimeInfo' data_OBJ.PATH.dirD];

if exist(TimeInfoSaveDir_playbacks, 'dir') == 0
    mkdir(TimeInfoSaveDir_playbacks);
    disp(['Created: '  TimeInfoSaveDir_playbacks])
end

data_OBJ.PATH.TimeInfoSaveDir_playbacks = TimeInfoSaveDir_playbacks;

%%
doSortedMotifs = 0;

for k = 1:numel(dirsToLoad_inds)
    
    thisDirInd = dirsToLoad_inds(k);
    thisDirToLoad = [data_OBJ.PATH.SongPath dfolders(thisDirInd).name '\'];
    
    disp(['Loading files: ' thisDirToLoad])

    data_OBJ = plotMotifExamples(data_OBJ, thisDirToLoad, MotifPlotDir, doSortedMotifs );
    data_OBJ = calc_wienerEntropy_on_motifs(data_OBJ, thisDirToLoad, AllEntropyDataDir);
    
    % This plots the songs relative to 10:00, need to change the limits if earlier
    data_OBJ = calcTimeOfSongFiles(data_OBJ, thisDirToLoad, data_OBJ.PATH.OriginalSongPath);
    %data_OBJ = calcTimeOfPlaybackFiles(data_OBJ, thisDirToLoad);
    
    
end
 
%% make a summary plot of motifs, playbacks and lights on-off for each file
% requires that calcTimeOfRecFiles and calcTimeOfPlaybackFiles has been run

%Plot_SongsPlaybackLights_Alignment

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Meta analysis per bird across days
%% make a plot of entropy versus time

firstOrLastSwitch = 1; % 1 = First, 2 = Last, 0 = both
data_OBJ = meta_make_plot_of_entropy_with_times_first_last(data_OBJ, firstOrLastSwitch);

data_OBJ = metaAnalysis_make_plot_of_entropy_across_days_with_times(data_OBJ);

data_OBJ = metaAnalysis_make_plot_of_entropy_means_across_days_all_data(data_OBJ, entropyFilesDir, birdName);


