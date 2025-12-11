%% eeg_lfp_song_analysis_SCRIPTS - SCRIPTS


%% PerBird Analysis
 clear all
 close all
 

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


%% w037
xlsFile = "X:\EEG-LFP-songLearning\JaniesAnalysis\w037\w037.xlsx";

startRow = 2;
endRow  = 40;

P.AllPlots = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\';
P.VideoPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w037\DATA_VIDEO\';
P.EphysPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w037\DATA_EPHYS\';
P.AnalysisPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w037\ANALYSIS\';
P.PlotPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w037\PLOTS\';
P.SongPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w037\Data\';
P.OriginalSongPath = 'X:\EEG-LFP-songLearning\songs\w037\Data\';

%% w025
xlsFile = "X:\EEG-LFP-songLearning\JaniesAnalysis\w025\w025.xlsx";

startRow = 2;
endRow  = 39;

P.AllPlots = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\';
P.VideoPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w025\DATA_VIDEO\';
P.EphysPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w025\DATA_EPHYS\';
P.AnalysisPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w025\ANALYSIS\';
P.PlotPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w025\PLOTS\';
P.SongPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025\Data\';
P.OriginalSongPath = 'X:\EEG-LFP-songLearning\songs\w025\Data\';


%% w027
xlsFile = "X:\EEG-LFP-songLearning\JaniesAnalysis\w027\w027.xlsx";

startRow = 2;
endRow  = 29;

P.AllPlots = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\';
P.VideoPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w027\DATA_VIDEO\';
P.EphysPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w027\DATA_EPHYS\';
P.AnalysisPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w027\ANALYSIS\';
P.PlotPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w027\PLOTS\';
P.SongPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w027\Data\';
P.OriginalSongPath = 'X:\EEG-LFP-songLearning\songs\w027\Data\';


%% w044
xlsFile = "X:\EEG-LFP-songLearning\JaniesAnalysis\w044\w044.xlsx";

startRow = 2;
endRow  = 20;

P.AllPlots = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\';
P.VideoPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w044\DATA_VIDEO\';
P.EphysPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w044\DATA_EPHYS\';
P.AnalysisPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w044\ANALYSIS\';
P.PlotPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w044\PLOTS\';
P.SongPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w044\Data\';
P.OriginalSongPath = 'X:\EEG-LFP-songLearning\songs\w044\Data\';



%% w042
xlsFile = "X:\EEG-LFP-songLearning\JaniesAnalysis\w042\w042.xlsx";

startRow = 2;
endRow  = 21;

P.AllPlots = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\';
P.VideoPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w042\DATA_VIDEO\';
P.EphysPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w042\DATA_EPHYS\';
P.AnalysisPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w042\ANALYSIS\';
P.PlotPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w042\PLOTS\';
P.SongPath = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\';
P.OriginalSongPath = 'X:\EEG-LFP-songLearning\songs\w042\Data\';

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

%% To check file differences

dir1 = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025\Data\2021-07-19-Last100Songs\'; % allSongs
dir2 = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025\Data\2021-07-19-Last100Songs-Motifs\'; % all motifs

data_OBJ = checkFileDiffs(data_OBJ, dir1 , dir2 );

%% Override
%thisDirToLoad = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025\Data\2021-07-16-First100Songs-Motifs\';
%MotifPlotDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w025\Motifs\';
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

% Make sure to move the entropy files into a First and Last folder!
firstOrLastSwitch = 1; % 1 = First, 2 = Last, 0 = both
data_OBJ = meta_make_plot_of_entropy_with_times_first_last(data_OBJ, firstOrLastSwitch);

data_OBJ = metaAnalysis_make_plot_of_entropy_across_days_with_times(data_OBJ);

%%

% Make sure that the motif dirs and the time info dirs match!
data_OBJ =  combineEntropyFiles_FirstLast(data_OBJ);

data_OBJ = metaAnalysis_make_plot_of_MEAN_ENTROPY_across_days(data_OBJ);
data_OBJ = metaAnalysis_make_plot_of_MEAN_ENTROPY_VARIANCE_across_days(data_OBJ);



%%  all birds combined, requires X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\entropyStats_AllBirds dirs

data_OBJ = analyze_EV_acrossBirds(data_OBJ);
           
%% identify large dEVs


 data_OBJ = analyze_dEV_night_and_day(data_OBJ)






%data_OBJ = metaAnalysis_make_plot_of_entropy_means_across_days_all_data(data_OBJ);


%% Song / motif preparation

%% Preprocessing song files

% Run in matlab2013b
%initVars(1, ), fl, fb, %sort the .wav files

wav_browser % to make the motifs



remove_first_syl_from_motifs_w025


%% Ephys data

   %% Load EEG
   
   % Loop over all days and all channels
   EEG_L_Ant = data_OBJ.EPHYS.EEG_L_Ant;
   EEG_R_Ant = data_OBJ.EPHYS.EEG_R_Ant;
   EEG_L_Post = data_OBJ.EPHYS.EEG_L_Post;
   EEG_R_Post = data_OBJ.EPHYS.EEG_R_Post;
   
   LFP_l = data_OBJ.EPHYS.LFP_l;
   LFP_m = data_OBJ.EPHYS.LFP_m;
   
   for k = 1:6
       switch k
           case 1
               data = EEG_L_Ant;
               dataType = 'EEG_L_Ant';
           case 2
               data = EEG_R_Ant;
               dataType = 'EEG_R_Ant';
           case 3
               data = EEG_L_Post;
               dataType = 'EEG_L_Post';
           case 4
               data = EEG_R_Post;
               dataType = 'EEG_R_Post';
           case 5
               data = LFP_l;
               dataType = 'LFP_l';
           case 6
               data = LFP_m;
               dataType = 'LFP_m';
               
       end
       
       for j = 1:nEntries
           
           thisChan  = num2str(data(j));
           
           if thisChan  == '0'
              
           else
               
               
               
               pathToData = [data_OBJ.PATH.EphysPath data_OBJ.EPHYS.EphysRecName{j} data_OBJ.PATH.dirD];
               
               chanNames = dir(fullfile(pathToData, '*.continuous'));
               index = strfind({chanNames.name}, thisChan);
               idx = find(~cellfun(@isempty,index));
               chanPath = [pathToData chanNames(idx).name ];
               
               [data_OBJ, dataInfo] = load_ephys_data(data_OBJ, chanPath);
               
               dataInfo.thisChan = thisChan;
               dataInfo.dataType = dataType;
               
               data_OBJ   = calc_delta_gamma(data_OBJ, dataInfo, j);
               
               
           end
       end
   end
       
   


%% To check data with Time Series Viewer, requires that NeuralElectrophysilogyTools is on path
%% w025 w027
dataDir = 'X:\EEG-LFP-songLearning\w025andw027\w0025\chronic_2021-07-14_20-24-58';
dataDir = 'X:\EEG-LFP-songLearning\w025andw027\w0025-w0027-justephys\chronic_2021-07-24_22-37-34';
dataDir = 'X:\EEG-LFP-songLearning\w025andw027\w0025-w0027-justephys\chronic_2021-08-05_22-06-10';

%% 
dataDir = 'X:\EEG-LFP-songLearning\w038andw037\chronic_2021-09-01_21-54-15';
dataDir = 'X:\EEG-LFP-songLearning\w038andw037\chronic_2021-09-21_21-50-18';

%%

%% w044 and w042
dataDir = 'X:\EEG-LFP-songLearning\w042andw044\w044 and w042\chronic_2021-12-30_20-56-35'
dataDir = 'X:\EEG-LFP-songLearning\w042andw044\w044 and w042\chronic_2022-01-01_20-26-41'
dataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w042\DATA_EPHYS\chronic_2021-12-29_20-44-37'
dataDir = 'X:\EEG-LFP-songLearning\w042andw044\w044 and w042\chronic_2022-01-04_20-47-15'
dataDir = 'X:\EEG-LFP-songLearning\w042andw044\w044 and w042\chronic_2022-01-10_21-39-26'


dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels


