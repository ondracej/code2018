
%%

close all
clear all

[rec_DB] = recDatabase();

%RecSet = [1:17]; %w038
%RecSet = [18:39]; %w027
%RecSet = [40:69]; %w025
%RecSet = [70:92]; %w037

RecSet  = 59:92;
RecSet  = 26;

dbstop if error

for rec = RecSet
    
    disp(['Recording: ' num2str(rec)])
    
    AnalysisDir = rec_DB(rec).AnalysisDir;
    VideoDir  = rec_DB(rec).VideoDir;
    
    RecName_save = rec_DB(rec).RecName_save;
    
    ephys_On_s = rec_DB(rec).ephys_On_s;
    lightOff_s = rec_DB(rec).lightOff_s;
    lightOn_s = rec_DB(rec).lightOn_s;
    
    underscore = '_';
    
    bla = find(RecName_save == underscore);
    RecName_Title = RecName_save;
    RecName_Title(bla) = ' ';
    
    % CalcOffset_s = rec_DB(rec).CalcOffset_s;
    
    eegChans = rec_DB(rec).eegChans;
    %lfpChan = rec_DB(rec).lfpChan;
    
    framesOffOn = rec_DB(rec).framesOffOn;
    %% Check data
    
    %{
dataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-23_22-43-29\Ephys';
dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels
    %}
    %%
    %cd(AnalysisDir)
    
    clear('data_OBJ')
    
    data_OBJ = songLearningEphysAnalysis_OBJ(AnalysisDir, eegChans);
    
    data_OBJ.DATA.RecName = RecName_Title;
    data_OBJ.DATA.RecName_save = RecName_save;
    % data_OBJ.ANALYSIS.CalcOffset_s  = CalcOffset_s ;
    %%
    
    %% Analyze Videos
    if ~isempty(framesOffOn)
        
        data_OBJ.PATH.vid_path = [VideoDir];
        data_OBJ = analyze_mvmt_in_video_frames(data_OBJ, framesOffOn);
    end
    
    %% Load EEG
    allEEGChans = reshape(eegChans', [1,4]);
    allValidChans = ~isnan(reshape(eegChans', [1,4])); % order is be L_ant, R-ant, L-post, R-post
    nValidChans_inds = find(allValidChans == 1);
    for j = 1:numel(nValidChans_inds)
        
        thisChan = num2str(allEEGChans(nValidChans_inds(j)));
        chanNames = dir(fullfile(data_OBJ.PATH.ephys_path, '*.continuous'));
        index = strfind({chanNames.name}, thisChan);
        idx = find(~cellfun(@isempty,index));
        chanPath = [data_OBJ.PATH.ephys_path chanNames(idx).name ];
        
        data_OBJ = load_ephys_data(data_OBJ, chanPath);
        %data_OBJ = load_and_downsample_ephys_data(data_OBJ, ChanToLoad_path);
        
        %% Calculated alignment points
        
        AnalysisHrs = 11; % analyzing 12 hours after the lights go off
        
        Alignment_LightOff_s = calc_offset_alignment_time(data_OBJ, ephys_On_s, lightOff_s);
        Alignment_LightOn_s = calc_offset_alignment_time(data_OBJ, ephys_On_s, lightOn_s);
        
        data_OBJ.ANALYSIS.Alignment_LightOff_s = Alignment_LightOff_s;
        data_OBJ.ANALYSIS.Alignment_LightOn_s = Alignment_LightOn_s;
        
        % data_OBJ.ANALYSIS.Alignment_1hrAfterLightsOff_s = Alignment_LightOff_s + 3600;
        data_OBJ.ANALYSIS.Alignment_1hrAfterLightsOff_s = Alignment_LightOff_s +1800;
        %data_OBJ.ANALYSIS.Alignment_1hrbeforeLightsOn_s = Alignment_LightOn_s - 3600;
        data_OBJ.ANALYSIS.Alignment_1hrbeforeLightsOn_s = data_OBJ.ANALYSIS.Alignment_1hrAfterLightsOff_s + AnalysisHrs*3600; % Change this to 10 hours exactly
         
        data_OBJ .DATA.data_cut_to_alignment = [];
        
        data_OBJ = cut_data_to_alignment_points(data_OBJ);
        
        %%
        %% Run Sleep Analysis
        
        plotDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\';
        [data_OBJ]  = calc_delta_gamma_EEG(data_OBJ, plotDir, thisChan, AnalysisHrs); % from this we get the movement artifacts
    end
    %% Load LFP
    %  ChanToLoad_path = [data_OBJ.PATH.eeg_path data_OBJ.PATH.lfp_name];
    %  data_OBJ = load_ephys_data(data_OBJ, ChanToLoad_path);
    
    %  data_OBJ = cut_data_to_alignment_points(data_OBJ);
    
    % [data_OBJ]  = calc_delta_gamma_LFP(data_OBJ); % from this we get the movement artifacts
    
    
end
%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Meta analysis songs
%%

AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-08-31_21-59-35\';
eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
data_OBJ = songLearningEphysAnalysis_OBJ(AnalysisDir, eegChans);



%% w038
% 
%  SongDataDir = 'X:\EEG-LFP-songLearning\Artemis\w038_Analysis\Data\';
%  plotDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w038\Motifs\';
%  AllEntropyDataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w038\Entropy\';

%% w037
% SongDataDir = 'X:\EEG-LFP-songLearning\Artemis\w037_Analysis\Data\';
% plotDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w037\Motifs\';
% AllEntropyDataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w037\Entropy\';

%% w027
% SongDataDir = 'X:\EEG-LFP-songLearning\Artemis\w027_Analysis\Data\';
% plotDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w027\Motifs\';
% AllEntropyDataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w027\Entropy\';
% 
%% w025
SongDataDir = 'X:\EEG-LFP-songLearning\Artemis\w025_Analysis\Data\';
plotDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w025\Motifs\';
AllEntropyDataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w025\Entropy\';

%% Load wave files and make motif plots and calc entropy on every motif

d = dir(SongDataDir);
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]);

dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
for j = 1:numel(dfolders)
    thisName = dfolders(j).name;
    %SylInds(j) = sum(strfind(thisName, 'Syllables'));
    SylInds(j) = sum(strfind(thisName, 'Motifs'));
end

dirsToLoad_inds = find(SylInds ~=0);

for k = 1:numel(dirsToLoad_inds)
    
    thisDirInd = dirsToLoad_inds(k);
    thisDirToLoad = [SongDataDir dfolders(thisDirInd).name '\'];
    
    disp(['Loading files: ' thisDirToLoad])
    
    
   % data_OBJ = plotMotifExamples(data_OBJ, thisDirToLoad, plotDir );
    
    data_OBJ = calc_wienerEntropy_on_syllables(data_OBJ, thisDirToLoad, AllEntropyDataDir);
    
end

%% Do meta analysis on wiener entropy files

%entropyFilesDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w038\Entropy\';
%birdName = 'w038';

entropyFilesDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w027\Entropy\';
birdName = 'w027';

%entropyFilesDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w025\Entropy\';
%birdName = 'w025';

% entropyFilesDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w037\Entropy\';
% birdName = 'w037';


data_OBJ = metaAnalysis_make_plot_of_entropy_means_across_days_all_data(data_OBJ, entropyFilesDir, birdName);


allEntropyDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w025\Entropy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w027\Entropy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w037\Entropy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w038\Entropy\'};

birdNames = {'w025', 'w027', 'w037', 'w038'};


data_OBJ = metaAnalysis_make_plot_of_entropy_means_versus_age(data_OBJ, allEntropyDirs, birdNames);



%% Meta Analysis Sleep EEG

% w025 = [21 12; 
         %20 13]; %L_ant %R_ant;  L_post R_post;
% w025 = [nan 12; 
         %nan 13]; %L_ant %R_ant;  L_post R_post;
    
% w027 = [45 52;
         %44 53]; %L_ant %R_ant;  L_post R_post;
% w027 = [21 28;
         %20 29]; %L_ant %R_ant;  L_post R_post;
   
% w038 = [nan nan; 
        % 28 21]; %L_ant %R_ant;  L_post R_post;
 
% w037 = [13 nan; 
         %12 nan]; %L_ant %R_ant;  L_post R_post; %LH

%% Left Anterior EEG

dyDirs = {'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w025\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w037\'};

TextStr = 'L-Anterior_EEG__dy';
Chs = [21 nan; 45 21; 13 nan];

data_OBJ = metaAnalysis_make_plot_of_dy_means_across_nights(data_OBJ, dyDirs, Chs, TextStr  );


%% Right Anterior EEG

dyDirs = {'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w025\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\'};

TextStr = 'R-Anterior_EEG__dy';
Chs = [12 nan; 52 28];

data_OBJ = metaAnalysis_make_plot_of_dy_means_across_nights(data_OBJ, dyDirs, Chs, TextStr  );


%% Left Posterior EEG

dyDirs = {'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w025\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w038\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w037\'};

TextStr = 'L-Posterior_EEG__dy';
Chs = [20 nan; 44 20; 28 nan; 12 nan]; %ChanSet-1 (anterior)

data_OBJ = metaAnalysis_make_plot_of_dy_means_across_nights(data_OBJ, dyDirs, Chs, TextStr  );

%% Right Posterior EEG

dyDirs = {'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w025\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w038\'};

TextStr = 'R-Posterior_EEG__dy';
Chs = [13 nan; 53 29; 21 nan]; %ChanSet-1 (anterior)

data_OBJ = metaAnalysis_make_plot_of_dy_means_across_nights(data_OBJ, dyDirs, Chs, TextStr  );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% dy correlations across nights

%% Left AP Comparisons
% Here we add w027 twice to make sure we calc all the chans
dyDirs = {'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w025\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\', ...   
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\', ...   
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w037\'};
   
TextStr = 'Corrs_Left-AP_R';
Chs = [21 20; 45 44; 21 20; 13 12]; %ChanSet-1 (anterior)

[data_OBJ] = metaAnalysis_make_plot_of_dy_correlations_across_nights(data_OBJ, dyDirs, Chs, TextStr );

%% % Right AP Comparisons

dbstop if error
dyDirs = {'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w025\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\', ...   
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\'};

TextStr = 'Corrs_Right-AP_R';
Chs = [12 13; 52 53; 28 29]; %ChanSet-1 (anterior)

[data_OBJ] = metaAnalysis_make_plot_of_dy_correlations_across_nights(data_OBJ, dyDirs, Chs, TextStr );


%% % Anterior LR Comparisons

dbstop if error
dyDirs = {'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w025\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\', ...   
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\'};

TextStr = 'Corrs_Anterior-LR_R';
Chs = [21 12; 45 52; 21 28]; %ChanSet-1 (anterior)

[data_OBJ] = metaAnalysis_make_plot_of_dy_correlations_across_nights(data_OBJ, dyDirs, Chs, TextStr );


%% % Posterior LR Comparisons

dbstop if error
dyDirs = {'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w025\', ...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\', ...   
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w027\',...
    'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\w037\'};

TextStr = 'Corrs_Posterior-LR_R';
Chs = [20 13; 44 53; 20 29; 28 21]; %ChanSet-1 (anterior)

[data_OBJ] = metaAnalysis_make_plot_of_dy_correlations_across_nights(data_OBJ, dyDirs, Chs, TextStr );


%% Do comparisons of EEG stats and Song Entropy - Sleep and next morning comparison

%% R Posterior EEG
dyDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\sleep_next_morning\w025-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\sleep_next_morning\w027-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\sleep_next_morning\w038-dy\'};

songDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\sleep_next_morning\w025-FirstSongs\',...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\sleep_next_morning\w027-FirstSongs\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\sleep_next_morning\w038-FirstSongs\'};


TextStr = 'R-Posterior-EEG';
[data_OBJ] = metaAnalysis_plot_of_dy_stats_and_song_entropy_across_nights(data_OBJ, dyDirs, songDirs, TextStr );


[data_OBJ] = metaAnalysis_plot_dy_stats_and_age_across_nights(data_OBJ, dyDirs, TextStr );


%[data_OBJ] = metaAnalysis_plot_song_stats_and_age_across_nights(data_OBJ, songDirs, TextStr );

%% L Posterior EEG Sleep and next First songs

dyDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\sleep_next_morning\w025-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\sleep_next_morning\w027-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\sleep_next_morning\w037-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\sleep_next_morning\w038-dy\'};

songDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\sleep_next_morning\w025-FirstSongs\',...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\sleep_next_morning\w027-FirstSongs\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\sleep_next_morning\w037-FirstSongs\',...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\sleep_next_morning\w038-FirstSongs\'};


TextStr = 'L-Posterior-EEG';

[data_OBJ] = metaAnalysis_plot_of_dy_stats_and_song_entropy_across_nights(data_OBJ, dyDirs, songDirs, TextStr );

[data_OBJ] = metaAnalysis_plot_dy_stats_and_age_across_nights(data_OBJ, dyDirs, TextStr );

%[data_OBJ] = metaAnalysis_plot_song_stats_and_age_across_nights(data_OBJ, songDirs, TextStr );


%% Last Songs and L Posterior EEG Sleep

dyDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\LastSongSameDaySleep\w025-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\LastSongSameDaySleep\w027-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\LastSongSameDaySleep\w037-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\LastSongSameDaySleep\w038-dy\'};

songDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\LastSongSameDaySleep\w025-LastSongs\',...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\LastSongSameDaySleep\w027-LastSongs\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\LastSongSameDaySleep\w037-LastSongs\',...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_L_Posterior_EEG\LastSongSameDaySleep\w038-LastSongs\'};


TextStr = 'L-Posterior-EEG__LastSongsSleep';

[data_OBJ] = metaAnalysis_plot_of_dy_stats_and_song_entropy_across_nights(data_OBJ, dyDirs, songDirs, TextStr );

[data_OBJ] = metaAnalysis_plot_dy_stats_and_age_across_nights(data_OBJ, dyDirs, TextStr );

%[data_OBJ] = metaAnalysis_plot_song_stats_and_age_across_nights(data_OBJ, songDirs, TextStr );


%% Last Songs and R Posterior EEG Sleep

dyDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\LastSongSameDaySleep\w025-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\LastSongSameDaySleep\w027-dy\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\LastSongSameDaySleep\w038-dy\'};

songDirs = {'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\LastSongSameDaySleep\w025-LastSongs\',...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\LastSongSameDaySleep\w027-LastSongs\', ...
    'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\all_eeg_all_birds\Meta_All_R_Posterior_EEG\LastSongSameDaySleep\w038-LastSongs\'};


TextStr = 'R-Posterior-EEG__LastSongsSleep';

[data_OBJ] = metaAnalysis_plot_of_dy_stats_and_song_entropy_across_nights(data_OBJ, dyDirs, songDirs, TextStr );





%%
data_OBJ = metaAnalysis_make_plot_of_entropy_pooled_days_all_data(data_OBJ, entropyFilesDir, birdName);

data_OBJ = metaAnalysis_analyze_wEntropy_acrossDays(data_OBJ, entropyFilesDir);



%%
songDataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\ANALYSIS\SongAnalysis\First\';
data_OBJ = metaAnalysis_import_song_analysis_data_from_xls(data_OBJ, songDataDir);

dyDataDir  = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\ANALYSIS\dy\';
data_OBJ = metaAnalysis_analyze_dy_values_across_nights(data_OBJ, dyDataDir);

meta_dyDataFile  = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\ANALYSIS\dy\MetaAnalysis_dyData.mat';
meta_songDataFile = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\ANALYSIS\SongAnalysis\First\MetaAnalysis_SongData.mat';

data_OBJ = combined_metaAnalysis_analyze_dy_values_across_nights(data_OBJ, meta_dyDataFile, meta_songDataFile);





[data_OBJ]  = plot_delta_gamma_across_nights(data_OBJ);


songDataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\w038_SongDevelopment\';
searchTerm = 'dph51';
data_OBJ = import_song_analysis_data_from_xls(data_OBJ, songDataDir, searchTerm);

%% Clustering

%data_OBJ = preprocessData_find_30Hz_artifacts(data_OBJ);
%data_OBJ = sleep_feature_extract_obj(data_OBJ);

%arte_factor = 7;
%data_OBJ = cluster_sleep_obj(data_OBJ, arte_factor);
%data_OBJ = plot_cluster_results(data_OBJ);
%data_OBJ = check_staging_in_eeg(data_OBJ);
%%



%%



%{










%avianSWRAnalysis_SCRIPTS

close all
clear all
dbstop if error

% Code dependencies
pathToCodeRepository = 'C:\Users\Administrator\Documents\code\GitHub\code2018\';
pathToOpenEphysAnalysisTools = 'C:\Users\NeuroPix-DAQ\Documents\GitHub\analysis-tools\';
%pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\code2018\NSKToolBox\';
pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\NET\';

addpath(genpath(pathToCodeRepository))
addpath(genpath(pathToOpenEphysAnalysisTools))
addpath(genpath(pathToNSKToolbox))
%% Define Session

dataDir = 'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\chronic_2021-07-24_22-37-34\Ephys\';
TriggerChan = 'recons';
BestChan = '49';

extSearch = ['*' BestChan '*'];
BestChanExactName =dir(fullfile(dataDir,extSearch));
tic
[data, timestamps, info] = load_open_ephys_data([dataDir BestChanExactName.name]);
toc

%extSearch = ['*' TriggerChan '*'];
%TriggerChanExactName =dir(fullfile(dataDir,extSearch));
%[Trigdata, timestamps, info] = load_open_ephys_data([dataDir TriggerChanExactName.name]);

Fs = info.header.sampleRate;

%%

timeOfRecording = '22:37:34';
LightsOff = '23:01:48';

sInMin = 60;
minInHr = 60;
hoursInDay = 24;

colon = ':';
bla = find(timeOfRecording == colon);
Rec_initClockHr = str2double(timeOfRecording(1: bla(1)-1));
Rec_initClockMin = str2double(timeOfRecording(bla(1)+1: bla(2)-1));
Rec_initClockS = str2double(timeOfRecording(bla(2)+1:end));

bla = find(LightsOff == colon);
LightsOff_initClockHr = str2double(LightsOff(1: bla(1)-1));
LightsOff_initClockMin = str2double(LightsOff(bla(1)+1: bla(2)-1));
LightsOff_initClockS = str2double(LightsOff(bla(2)+1:end));

DiffHrs = LightsOff_initClockHr - Rec_initClockHr;
DiffMins = LightsOff_initClockMin - Rec_initClockMin;
DiffS = LightsOff_initClockS - Rec_initClockS;

TotalDiff_S = DiffHrs*3600+DiffMins*60+DiffS;
LightOff_samples = TotalDiff_S*Fs;

%% 2 hours after lights off, 8 hour recording samples

X_HourWin = 8*3600*Fs;

ROI = [LightOff_samples LightOff_samples+X_HourWin];

figure; plot(data(ROI(1): ROI(1)+10000000))
figure; plot(ROIData(1:10000000))

ROIData = data(ROI(1): ROI(2));
clear('data')

totalSamples = size(ROIData, 1);
            recordingDuration_s  = totalSamples/Fs;
            recordingDuration_hr = recordingDuration_s/3600;
            
            
%% Downsample

batchDuration_s = 60; % 60 s
batchDuration_samp = batchDuration_s*Fs;

tOn_samp = 1:batchDuration_samp:totalSamples;
nBatches = numel(tOn_samp);
            
%% Downsample
fObj = filterData(sampleRate);

fobj.filt.F=filterData(sampleRate);
%fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
fobj.filt.F.downSamplingFactor=100; % original is 128 for 32k
fobj.filt.F=fobj.filt.F.designDownSample;
fobj.filt.F.padding=true;
fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;

%% D/B
reductionFactor = 1; % No reduction

movWin_Var = 10*reductionFactor; % 10 s
movOLWin_Var = 9*reductionFactor; % 9 s

segmentWelch = 1*reductionFactor;
OLWelch = 0.5*reductionFactor;

dftPointsWelch =  2^10;

segmentWelchSamples = round(segmentWelch*fobj.filt.FFs);
samplesOLWelch = round(segmentWelchSamples*OLWelch);

movWinSamples=round(movWin_Var*fobj.filt.FFs);%obj.filt.FFs in Hz, movWin in samples
movOLWinSamples=round(movOLWin_Var*fobj.filt.FFs);

[~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);

deltaBandLowCutoff = 1;
deltaBandHighCutoff = 4;

gammaBandLowCutoff = 25;
gammaBandHighCutoff = 140;

pfDeltaBand=find(f>=deltaBandLowCutoff & f<deltaBandHighCutoff);
pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);

 for i = 1:nBatches-1
                
                if i == nBatches
                    thisData = ROIData(tOn_samp(i):samples);
                else
                    thisData = ROIData(tOn_samp(i):tOn_samp(i)+batchDuration_samp);
                end
                

 tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
                pValid=all(~isnan(tmp_V_DS));
                
                [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                


%% Open Trigger File
extSearch = ['*' TriggerChan '*'];
TrigFileExactName =dir(fullfile(dataDir,extSearch));
%
%
            tic
            fix_open_ephys_data([dataDir TrigFileExactName.name])
            
            [data, timestamps, info] = load_open_ephys_data([dataDir TrigFileExactName.name]);
            [data, timestamps, info] = load_open_ephys_data([dataDir '150_CH44.continuous']);
            
            %thisSegData_s = timestamps(1:end) - timestamps(1);
            toc
            disp('Finished loading data')
            
            disp('Finding peaks...')
            [pks,locs,w,p] = findpeaks(data, 'MinPeakHeight', 1);
            
            nTrigs = numel(locs);
%% Vieo Analysis

VidPath = 'Z:\hameddata2\EEG-LFP-song learning\w025 and w027\w0027 -just vid\w27_18_08_2021_00215-converted.avi';

[filepath,name,ext] = fileparts(VidPath );

nFrames = 944491;
frameRate = 20;
frameCut_s = 1800;
frameCut_frames = frameCut_s*frameRate;

nMovies = ceil(nFrames/frameCut_frames);
tic
VidObj = VideoReader(VidPath);
toc
            vidHeight = VidObj.Height;
            vidWidth = VidObj.Width;
            %totalFrames = VidObj.NumberOfFrames;
           
            for j = 1:nMovies
                
                if j == nMovies
                    mov(1:frameCut_frames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);
                else
                    mov(1:frameCut_frames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);
                    
                    cnt = 1;
                    while hasFrame(VidObj)
                        %mov(cnt).cdata = read(VidObj, k);
                        mov(cnt).cdata = readFrame(VidObj);
                        
                        if cnt == frameCut_frames
                            
                            saveName = [filepath '\' name '_part-' num2str(j) ];
                            %V = VideoWriter(saveName, 'Uncompressed AVI'); % creates huge files ~20 GB, 'quality' is not an option
                            V = VideoWriter(saveName, 'Motion JPEG AVI');
                            V.Quality = 95;
                            V.FrameRate = frameRate;
                            
                            mov = mov(1:end);
                            tic
                            open(V)
                            writeVideo(V, mov)
                            close(V)
                            toc
                            continue
                        else
                            fprintf('%d/%d\n', cnt, frameCut_frames);
                            cnt = cnt+1;
                            
                            
                        end
                        
                    end
                
                
                
                vidFrame = readFrame(VidObj);
                image(vidFrame, 'Parent', currAxes);
                currAxes.Visible = 'off';
                pause(1/v.FrameRate);
            end
            
            
            
            
            allDiffs = nan(1, nFrames-1);
            cnt = 1;
            for k =1:nFrames-1
                
                img1 = read(VidObj, k);
                grayImage1 = rgb2gray(img1);
                
                %imshow(grayImage1)
                img2 = read(VidObj, k+1);
                grayImage2 = rgb2gray(img2);
                  
                diffImg = grayImage2-grayImage1;
                %imshow(diffImg)
                
                difVal = sum(sum(diffImg));
                allDiffs(cnt) = difVal;
                
                cnt = cnt+1;
            end
            
    currAxes = axes;

            
            
            
            
 timeScale_frames = 1:1:nFrames-1;
 timeScale_s = timeScale_frames/frameRate;
 timeScale_hr = timeScale_s/3600;
 figure
plot(timeScale_hr, allDiffs)
plot(timeScale_hr,allDiffs)

%recSession = 54; % (54) Chick-10  | 27.04.2019 - 19-33-33
%recSession = 76; %(76) ZF-72-81 | 16.05.2019 - 19-18-21
recSession = 81; %(81) ZF-72-81 | 16.05.2019 - 21-26-59 - Overnight

D_OBJ = avianSWRAnalysis_OBJ(recSession);
disp([D_OBJ.INFO.birdName ': ' D_OBJ.Session.time])
%%
dataDir = D_OBJ.Session.SessionDir;
dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multi-channel Plot

%doPlot = 1; % Make and print plots
%seg_s = 50; % segment to plot (in s)

%D_OBJ = batchPlotDataForOpenEphys_multiChannel(D_OBJ, doPlot, seg_s);
D_OBJ = batchPlotDataForOpenEphys_multiChannel(D_OBJ); % default is doPlot, 40s
disp('Finished plotting')
%% Single Channel Plot

%D_OBJ = batchPlotDataForOpenEphys_singleChannel(D_OBJ, doPlot, seg_s); % default is doPlot, 40s
D_OBJ = batchPlotDataForOpenEphys_singleChannel(D_OBJ); % default is doPlot, 40s
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing for Sebastian's ShWR detections
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FullFile - creates a "_py_fullFile"

%chanOverride = 7;
%D_OBJ = prepareDataForShWRDetection_FullFile_Python(D_OBJ, chanOverride);
[D_OBJ] = prepareDataForShWRDetection_FullFile_Python(D_OBJ);
%% Do NOT USE - use fullfile option for now

%chanOverride = [];
%durOverride = [];

%D_OBJ  = prepareDataForShWRDetection_Python(D_OBJ, chanOverride, durOverride);
%D_OBJ  = prepareDataForShWRDetection_Python(D_OBJ);
%% Confirm Detections - not actually using this for now....

% This should be in the code/SWR/Data directory % export_ripples, copy back into directory
%confirmSWR_PythonDetections(D_OBJ) % I cannot figure out how to include this in the analysis object...
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SWR Plotting
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mean shape, saves the snippets for the detections "SWR_data.mat"
%% Remember to change the data name to x_data

useNotch =0;

[D_OBJ] = SWR_PythonDetections_shapeStatistics(D_OBJ, useNotch );

pathToChronuxToolbox = 'C:\Users\Administrator\Documents\code\GitHub\chronux\';
addpath(genpath(pathToChronuxToolbox))
%% Wavelet

waveletInd = 5;
useNotch = 1;
[D_OBJ] = SWR_wavelet(D_OBJ, waveletInd, useNotch );
%% Frequency raster

binSize_s = 15;
[D_OBJ] = SWR_raster(D_OBJ, binSize_s);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Spikesorting with KiloSort
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make sure the Phy is closed before running!!!
% pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort\';
% pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';
%
% addpath(genpath(pathToKiloSort)) addpath(genpath(pathToNumpy))
%
% pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\';
%
% % Config Files - check that the channel map is set correctly there! %nameOfConfigFile
% = 'StandardConfig_avian16Chan_ZF_6088.m'; nameOfConfigFile = 'StandardConfig_avian16Chan_ZF_5915.m';
% %nameOfConfigFile = 'StandardConfig_avian16Chan_ZF_7281.m'; %nameOfConfigFile
% = 'StandardConfig_avian16Chan_Chick10'; runKilosortFromConfigFile(D_OBJ, pathToYourConfigFile,
% nameOfConfigFile)
%
% disp(['Finished Processing ' D_OBJ.Session.SessionDir])

%pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort2\';
pathToKiloSort = 'C:\Users\Janie\Documents\GitHub\Kilosort-2.5\';
pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';

addpath(genpath(pathToKiloSort))
addpath(genpath(pathToNumpy))
            
pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles';

% Config Files - check that the channel map is set correctly there!
%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915.m';
nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915_K2.m';

%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_6088.m';
%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_6088_K2.m';

%nameOfConfigFile =  'StandardConfig_avian16Chan_Chick10.m';
%nameOfConfigFile =  'StandardConfig_avian16Chan_Chick10_K2.m';

%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_7281.m';
%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_7281_K2.m';


%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_21-05-36';
%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_18-07-21';
%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_18-48-02';

%chanMap = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\chanMap16ChanSilicon.mat';

runKilosort2fromConfigFile(D_OBJ, pathToYourConfigFile, nameOfConfigFile)
disp(['Finished Processing ' D_OBJ.Session.SessionDir])
%% Running Phy
% navigate to the data directory in cmd window (the location of the .dat file)

%> activate phy
%> phy template-gui params.py
% pip install git+https://github.com/kwikteam/phy git+https://github.com/kwikteam/phy-contrib --upgrade
%% Make sure to save which channels have which clusters on them!!

D_OBJ = avianSWRAnalysis_OBJ(recSession);
%% Make plots of spikes aligned to SWRs

addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\npy-matlab'))
addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\spikes'))

ClustType = 2;
% - 0 = noise
% - 1 = mua
% - 2 = good
% - 3 = unsorted

[D_OBJ] = importPhyClusterSpikeTimes(D_OBJ, ClustType);
%% Make plots of the spikes

ClustType = 1;
if ~isfield(D_OBJ.REC, 'GoodClust_2') || ~isfield(D_OBJ.REC, 'MUAClust_1')
    disp('***Make sure to set the cluster information in the database before running!***')
else
    [D_OBJ]  = loadClustTypesAndMakeSpikePlots(D_OBJ, ClustType);
end
disp('Finished plotting...')
%%
chanSelectionOverride = [];

ClustType = 1;

%[D_OBJ]  = loadClustTypesAndAlignToSWR_Raster(D_OBJ, chanSelectionOverride);
[D_OBJ]  = loadClustTypesAndAlignToSWR_Raster_ClustType(D_OBJ, ClustType);
%% Analysis using the Sleep code

[D_OBJ] = getFreqBandDetection(D_OBJ);

[D_OBJ] = plotDBRatio(D_OBJ);
 
%}