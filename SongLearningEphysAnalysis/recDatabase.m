
function [rec_DB] = recDatabase()
 
rec = 1;

%% w038, 2021-08-31 EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-08-31_21-59-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_31_08_21_00217-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-08-31_21-59-35';
rec_DB(rec).ephys_On_s = [21 59 35]; %start of recording

rec_DB(rec).lightOff_s = [22 06 00]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 10 25]; % on the next day
rec_DB(rec).framesOffOn = [4 486]; % 

%https://www.calculator.net/time-duration-calculator.html
%rec_DB(rec).CalcOffset_s = 385 ; 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;

%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

rec = rec+1;

%% w038, 2021-09-01, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-01_21-54-15\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_01_09_21_00219-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-01_21-54-15';
rec_DB(rec).ephys_On_s = [21 54 15]; %start of recording

rec_DB(rec).lightOff_s = [22 06 16]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 10 22]; % on the next day
rec_DB(rec).framesOffOn = [10 492]; % 
%rec_DB(rec).CalcOffset_s = 721 ; 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 0; % very few songs

rec = rec+1;

%% w038, 2021-09-02, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-02_21-57-58\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_02_09_21_00220-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-02_21-57-58';
rec_DB(rec).ephys_On_s = [21 57 58]; %start of recording

rec_DB(rec).lightOff_s = [22 05 36]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 11 37]; % on the next day
rec_DB(rec).framesOffOn = [7 490]; % 
%rec_DB(rec).CalcOffset_s = 458 ; 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 0; % very few songs

rec = rec+1;

%% w038, 2021-09-03, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-03_21-51-46\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_03_09_21_00223-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-03_21-51-46';
rec_DB(rec).ephys_On_s = [21 51 46]; %start of recording

rec_DB(rec).lightOff_s = [21 56 23]; % on same day as start of recording
rec_DB(rec).lightOn_s = [9 57 55]; % on the next day
rec_DB(rec).framesOffOn = [5 485]; % 
%rec_DB(rec).CalcOffset_s = 277 ; 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 0; % very few songs

rec = rec+1;

%% w038, 2021-09-04, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-04_22-18-08\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_04_09_21_00224-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-04_22-18-08';
rec_DB(rec).ephys_On_s = [22 18 08]; %start of recording

rec_DB(rec).lightOff_s = [22 43 46]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 48 18]; % on the next day
rec_DB(rec).framesOffOn = [19 501]; % 
%rec_DB(rec).CalcOffset_s = 1538; 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-05, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-05_21-13-37\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_05_09_21_00224-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-05_21-13-37';
rec_DB(rec).ephys_On_s = [21 13 37]; %start of recording

rec_DB(rec).lightOff_s = [22 43 46]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 46 53]; % on the next day
rec_DB(rec).framesOffOn = [62 544]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)
%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% No Data, 2021-09-06, Song data is present

%% w038, 2021-09-07, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-07_21-59-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_07_09_21_00226-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-07_21-59-35';
rec_DB(rec).ephys_On_s = [21 59 35]; %start of recording

rec_DB(rec).lightOff_s = [22 14 47]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 19 19]; % on the next day
rec_DB(rec).framesOffOn = [12 494]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-08, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-08_21-26-20\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_08_09_21_00227-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-08_21-26-20';
rec_DB(rec).ephys_On_s = [21 26 20]; %start of recording

rec_DB(rec).lightOff_s = [22 14 25]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 18 57]; % on the next day
rec_DB(rec).framesOffOn = [34 516]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-09, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-09_21-20-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_08_09_21_00227-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-09_21-20-35';
rec_DB(rec).ephys_On_s = [21 20 35]; %start of recording

rec_DB(rec).lightOff_s = [21 58 18]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 01 20]; % on the next day
rec_DB(rec).framesOffOn = [27 508]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-10, EEG Ch 21, LFP Ch 24 - No Video (time from w037)
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-10_22-12-57\';
rec_DB(rec).VideoDir = '';
rec_DB(rec).RecName_save = 'w038__2021-09-10_22-12-57';
rec_DB(rec).ephys_On_s = [22 12 57]; %start of recording

rec_DB(rec).lightOff_s = [22 44 45]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 49 17]; % on the next day
rec_DB(rec).framesOffOn = [23 505]; % 
rec_DB(rec).framesOffOn = []; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-11, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-11_21-22-25\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_11_09_21_00232-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-11_21-22-25';
rec_DB(rec).ephys_On_s = [21 22 25]; %start of recording

rec_DB(rec).lightOff_s = [22 13 31]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 19 33]; % on the next day
rec_DB(rec).framesOffOn = [37 519]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-12, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-12_20-26-52\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_12_09_21_00235-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-12_20-26-52';
rec_DB(rec).ephys_On_s = [20 26 52]; %start of recording

rec_DB(rec).lightOff_s = [21 40 19]; % on same day as start of recording
rec_DB(rec).lightOn_s = [09 44 51]; % on the next day
rec_DB(rec).framesOffOn = [51 533]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-13, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-13_22-18-08\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_13_09_21_00236-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-13_22-18-08';
rec_DB(rec).ephys_On_s = [22 18 08]; %start of recording

rec_DB(rec).lightOff_s = [22 40 47]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 45 19]; % on the next day
rec_DB(rec).framesOffOn = [17 499]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-14 - No Data, Song data is present


%% w038, 2021-09-15, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-15_22-08-48\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_15_09_21_00238-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-15_22-08-48';
rec_DB(rec).ephys_On_s = [22 08 48]; %start of recording

rec_DB(rec).lightOff_s = [22 26 43]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 37 15]; % on the next day
rec_DB(rec).framesOffOn = [14 500]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-16, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-16_21-28-13\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_16_09_21_00239-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-16_21-28-13';
rec_DB(rec).ephys_On_s = [21 28 13]; %start of recording

rec_DB(rec).lightOff_s = [22 20 44]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 16]; % on the next day
rec_DB(rec).framesOffOn = [37 519]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% w038, 2021-09-17, No Data, song data is present


%% w038, 2021-09-18, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-18_21-59-46\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_18_09_21_00240-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-18_21-59-46';
rec_DB(rec).ephys_On_s = [21 59 46]; %start of recording

rec_DB(rec).lightOff_s = [22 20 57]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 29]; % on the next day
rec_DB(rec).framesOffOn = [16 498]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;


%% w038, 2021-09-19, EEG Ch 21, LFP Ch 24
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_EPHYS\chronic_2021-09-19_22-10-06\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_19_09_21_00242-converted_img\';
rec_DB(rec).RecName_save = 'w038__2021-09-19_22-10-06';
rec_DB(rec).ephys_On_s = [22 10 06]; %start of recording

rec_DB(rec).lightOff_s = [22 20 44]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 16]; % on the next day
rec_DB(rec).framesOffOn = [9 491]; % 

rec_DB(rec).eegChans = [nan nan; 28 21]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH21.continuous'; % w038, R posterior EEG (no anterior eeg available)
%rec_DB(rec).lfpChan = '150_CH24.continuous'; % w038, R most lateral LFP (right hyperpallium)

%rec_DB(rec).songData = 1; % song analysis complete

rec = rec+1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% w027, 2021-07-23, EEG Ch 52, LFP Ch 49, data is corrupt, do Not USE
% rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-23_22-43-29\';
% rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-23-07-2021_00178-converted_img\';
% rec_DB(rec).RecName_save = 'w027__2021-07-23_22-43-29';
% rec_DB(rec).ephys_On_s = [22 43 29]; %start of recording
% 
% rec_DB(rec).lightOff_s = [23 06 44]; % on same day as start of recording
% rec_DB(rec).lightOn_s = [11 11 16]; % on the next day
% rec_DB(rec).framesOffOn = [17 499]; % 
% 
% rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
% %rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
% %rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium
% 
% rec = rec+1;

%% w027, 2021-07-24, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-24_22-37-34\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-24-07-2021_00179-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-07-24_22-37-34';
rec_DB(rec).ephys_On_s = [22 37 34]; %start of recording

rec_DB(rec).lightOff_s = [23 02 28]; % on same day as start of recording
rec_DB(rec).lightOn_s = [11 05 29]; % on the next day
rec_DB(rec).framesOffOn = [18 499]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w027, 2021-07-25, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-25_23-03-55\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-25-07-2021_00181-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-07-25_23-03-55';
rec_DB(rec).ephys_On_s = [23 03 55]; %start of recording

rec_DB(rec).lightOff_s = [23 04 00]; % on same day as start of recording
rec_DB(rec).lightOn_s = [11 05 22]; % on the next day
rec_DB(rec).framesOffOn = [1 482]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w027, 2021-07-26, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-26_21-35-23\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-26-07-2021_00182-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-07-26_21-35-23';
rec_DB(rec).ephys_On_s = [21 35 23]; %start of recording

rec_DB(rec).lightOff_s = [22 01 03]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 05 35]; % on the next day
rec_DB(rec).framesOffOn = [19 501]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w027, 2021-07-27, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-27_21-49-20\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-27-07-2021_00184-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-07-27_21-49-20';
rec_DB(rec).ephys_On_s = [21 49 20]; %start of recording

rec_DB(rec).lightOff_s = [22 01 28]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 04 29]; % on the next day
rec_DB(rec).framesOffOn = [10 491]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-07-28, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-28_21-51-11\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-28-07-2021_00186-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-07-28_21-51-11';
rec_DB(rec).ephys_On_s = [21 51 11]; %start of recording

rec_DB(rec).lightOff_s = [22 00 19]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 04 50]; % on the next day
rec_DB(rec).framesOffOn = [8 490]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-07-29, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-29_21-47-09\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-29-07-2021_00187-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-07-29_21-47-09';
rec_DB(rec).ephys_On_s = [21 47 09]; %start of recording

rec_DB(rec).lightOff_s = [22 02 17]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 05 19]; % on the next day
rec_DB(rec).framesOffOn = [12 493]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-07-30, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-30_20-54-58\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-30-07-2021_00188-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-07-30_20-54-58';
rec_DB(rec).ephys_On_s = [20 54 58]; %start of recording

rec_DB(rec).lightOff_s = [22 00 55]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 03 56]; % on the next day
rec_DB(rec).framesOffOn = [46 527]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-07-31, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-07-31_21-50-14\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-31-07-2021_00190-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-07-31_21-50-14';
rec_DB(rec).ephys_On_s = [21 50 14]; %start of recording

rec_DB(rec).lightOff_s = [22 00 43]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 05 15]; % on the next day
rec_DB(rec).framesOffOn = [9 491]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-08-01, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-01_22-20-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-01-08-2021_00192-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-01_22-20-35';
rec_DB(rec).ephys_On_s = [22 20 35]; %start of recording

rec_DB(rec).lightOff_s = [22 40 23]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 43 24]; % on the next day
rec_DB(rec).framesOffOn = [15 496]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-08-02, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-02_21-26-05\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-02-08-2021_00194-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-02_21-26-05';
rec_DB(rec).ephys_On_s = [21 26 05]; %start of recording

rec_DB(rec).lightOff_s = [22 08 12]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 50 13]; % on the next day
rec_DB(rec).framesOffOn = [30 537]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-08-03,  - No Data

%% w027, 2021-08-04, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-04_22-02-26\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-04-08-2021_00196-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-04_22-02-26';
rec_DB(rec).ephys_On_s = [22 02 26]; %start of recording

rec_DB(rec).lightOff_s = [22 20 20]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 24 52]; % on the next day
rec_DB(rec).framesOffOn = [14 496]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-08-05, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-05_22-06-10\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-05-08-2021_00198-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-05_22-06-10';
rec_DB(rec).ephys_On_s = [22 06 10]; %start of recording

rec_DB(rec).lightOff_s = [22 21 13]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 44]; % on the next day
rec_DB(rec).framesOffOn = [12 494]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-08-06, EEG Ch 52, LFP Ch 49, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-06_20-57-20\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-06-08-2021__00200-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-06_20-57-20';
rec_DB(rec).ephys_On_s = [20 57 20]; %start of recording

rec_DB(rec).lightOff_s = [22 19 54]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 24 25]; % on the next day
rec_DB(rec).framesOffOn = [57 539]; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-08-07, incomplete recording

%% w027, 2021-08-08, EEG Ch 52, LFP Ch 49, - no Video, from w025
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-08_21-11-29\';
rec_DB(rec).VideoDir = [];
rec_DB(rec).RecName_save = 'w027__2021-08-08_21-11-29';
rec_DB(rec).ephys_On_s = [21 11 29]; %start of recording

rec_DB(rec).lightOff_s = [22 9 24]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 13 55]; % on the next day
rec_DB(rec).framesOffOn = []; % 

rec_DB(rec).eegChans = [45 52; 44 53]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w027, 2021-08-09, EEG Ch 28, LFP Ch 25, - Channels change
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-09_21-51-42-trigok\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-09-08-2021_00206-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-09_21-51-42';
rec_DB(rec).ephys_On_s = [21 51 42]; %start of recording

rec_DB(rec).lightOff_s = [22 09 41]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 14 12]; % on the next day
rec_DB(rec).framesOffOn = [14 496]; % 

rec_DB(rec).eegChans = [21 28; 20 29]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w027, 2021-08-10, EEG Ch 28, LFP Ch 25,
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-10_21-59-22\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-10-08-2021_00207-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-10_21-59-22';
rec_DB(rec).ephys_On_s = [21 59 22]; %start of recording

rec_DB(rec).lightOff_s = [22 09 50]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 14 21]; % on the next day
rec_DB(rec).framesOffOn = [9 491]; % 

rec_DB(rec).eegChans = [21 28; 20 29]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sur

rec = rec+1;

%% w027, 2021-08-11, EEG Ch 28, LFP Ch 25,
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-11_20-48-49\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-11-08-2021_00208-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-11_20-48-49';
rec_DB(rec).ephys_On_s = [20 48 49]; %start of recording

rec_DB(rec).lightOff_s = [22 09 46]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 14 18]; % on the next day
rec_DB(rec).framesOffOn = [56 538]; % 

rec_DB(rec).eegChans = [21 28; 20 29]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sur

rec = rec+1;


%% w027, 2021-08-12, EEG Ch 28, LFP Ch 25, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-12_21-55-12\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-12-08-2021_00210-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-12_21-55-12';
rec_DB(rec).ephys_On_s = [21 55 12]; %start of recording

rec_DB(rec).lightOff_s = [22 08 49]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 13 21]; % on the next day
rec_DB(rec).framesOffOn = [11 493]; % 

rec_DB(rec).eegChans = [21 28; 20 29]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sur

rec = rec+1;

%% w027, 2021-08-13, NO DATA

%% w027, 2021-08-14, NO DATA

%% w027, 2021-08-15 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-15_21-52-32\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-15-08-2021_00211-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-15_21-52-32';
rec_DB(rec).ephys_On_s = [21 52 32]; %start of recording

rec_DB(rec).lightOff_s = [22 40 26]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 44 58]; % on the next day
rec_DB(rec).framesOffOn = [34 516]; %

rec_DB(rec).eegChans = [21 28; 20 29]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sur

rec = rec+1;

%% w027, 2021-08-16 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-16_22-11-06\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-16-08-2021_00213-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-16_22-11-06';
rec_DB(rec).ephys_On_s = [22 11 06]; %start of recording

rec_DB(rec).lightOff_s = [22 20 12]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 32 14]; % on the next day
rec_DB(rec).framesOffOn = [8 495]; %

rec_DB(rec).eegChans = [21 28; 20 29]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sur

rec = rec+1;

%% w027, 2021-08-17 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-17_21-47-03\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-17-08-2021_00213-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-17_21-47-03';
rec_DB(rec).ephys_On_s = [21 47 03]; %start of recording

rec_DB(rec).lightOff_s = [22 06 40]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 11 11]; % on the next day
rec_DB(rec).framesOffOn = [15 497]; %

rec_DB(rec).eegChans = [21 28; 20 29]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sur

rec = rec+1;

%% w027, 2021-08-18 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_EPHYS\chronic_2021-08-18_21-57-57\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\DATA_VIDEO\1fperMinute\w27-18-08-2021_00215-converted_img\';
rec_DB(rec).RecName_save = 'w027__2021-08-18_21-57-57';
rec_DB(rec).ephys_On_s = [21 57 57]; %start of recording

rec_DB(rec).lightOff_s = [22 06 55]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 11 27]; % on the next day
rec_DB(rec).framesOffOn = [8 490]; %

rec_DB(rec).eegChans = [21 28; 20 29]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sur

rec = rec+1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% w025

%% w025, 2021-07-14, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-14_20-24-58\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-14-07-2021_00170_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-14_20-24-58';
rec_DB(rec).ephys_On_s = [20 24 58]; %start of recording

rec_DB(rec).lightOff_s = [20 47 36]; % on same day as start of recording
rec_DB(rec).lightOn_s = [8 50 38]; % on the next day
rec_DB(rec).framesOffOn = [17 498]; % all night frames

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium


rec = rec+1;

%% w025, 2021-07-15, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-15_20-28-44\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-15-07-2021_00171_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-15_20-28-44';
rec_DB(rec).ephys_On_s = [20 28 44]; %start of recording

rec_DB(rec).lightOff_s = [20 48 17]; % on same day as start of recording
rec_DB(rec).lightOn_s = [8 49 48]; % on the next day
rec_DB(rec).framesOffOn = [15 495]; % all night frames

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-16, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-16_19-14-55\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-16-07-2021_00172_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-16_19-14-55';
rec_DB(rec).ephys_On_s = [19 14 55]; %start of recording

rec_DB(rec).lightOff_s = [20 46 38]; % on same day as start of recording
rec_DB(rec).lightOn_s = [8 49 39]; % on the next day
rec_DB(rec).framesOffOn = [63 544]; % all night frames

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-17, %This night the birds head is tangled up
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-17_21-27-58\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-17-07-2021_00173_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-17_21-27-58';
rec_DB(rec).ephys_On_s = [21 27 58]; %start of recording

rec_DB(rec).lightOff_s = [22 49 7]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 52 8]; % on the next day
rec_DB(rec).framesOffOn = [56 537]; % all night frames

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-18, EEG = 12 (R Ant) LFP = 10 PROBLEM W VIDEO
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-18_21-43-38\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-18-07-2021_00174_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-18_21-43-38';
rec_DB(rec).ephys_On_s = [21 43 38]; %start of recording

rec_DB(rec).lightOff_s = [22 48 18]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 36 42]; % This is still darek, end of video is missing
rec_DB(rec).framesOffOn = [45 517]; % End of video missing

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-19, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-19_21-38-34\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-19-07-2021_00175_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-19_21-38-34';
rec_DB(rec).ephys_On_s = [21 38 34]; %start of recording

rec_DB(rec).lightOff_s = [22 49 2]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 53 34]; % on the next day
rec_DB(rec).framesOffOn = [45 531]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-20, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-20_21-35-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-20-07-2021_00176_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-20_21-35-35';
rec_DB(rec).ephys_On_s = [21 35 35]; %start of recording

rec_DB(rec).lightOff_s = [22 49 13]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 52 14]; % on the next day
rec_DB(rec).framesOffOn = [51 532]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-21, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-21_21-56-25\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-21-07-2021_00177_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-21_21-56-25';
rec_DB(rec).ephys_On_s = [21 21 56]; %start of recording

rec_DB(rec).lightOff_s = [22 17 32]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 23 34]; % on the next day
rec_DB(rec).framesOffOn = [16 499]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-22, NO DATA

%% w025, 2021-07-23, NO Video, Data is corrupted
% 
% rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-23_22-43-29\';
% rec_DB(rec).VideoDir = '';
% rec_DB(rec).RecName_save = 'w025__2021-07-23_22-43-29';
% rec_DB(rec).ephys_On_s = [22 43 29]; %start of recording
% 
% rec_DB(rec).lightOff_s = [23 06 44]; % on same day as start of recording
% rec_DB(rec).lightOn_s = [11 11 16]; % on the next day
% rec_DB(rec).framesOffOn = []; % 
% 
% rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
% %rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
% %rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium
% 
% rec = rec+1;

%% w025, 2021-07-24, EEG Ch 12, LFP Ch 10, data is corrupt
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-24_22-37-34-corruptTrigStarts\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-24-07-2021_00180_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-24_22-37-34';
rec_DB(rec).ephys_On_s = [22 37 34]; %start of recording

rec_DB(rec).lightOff_s = [23 02 28]; % on same day as start of recording
rec_DB(rec).lightOn_s = [11 05 29]; % on the next day
rec_DB(rec).framesOffOn = [18 499]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w025, 2021-07-25, EEG = 12 (R Ant) LFP = 10 % Video starts in dark
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-25_23-03-55\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-25-07-2021_00180_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-25_23-03-55';
rec_DB(rec).ephys_On_s = [23 03 55]; %start of recording

rec_DB(rec).lightOff_s = [23 04 00]; % on same day as start of recording
rec_DB(rec).lightOn_s = [11 05 22]; % on the next day
rec_DB(rec).framesOffOn = [1 482]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w025, 2021-07-26, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-26_21-35-23\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-26-07-2021_00182_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-26_21-35-23';
rec_DB(rec).ephys_On_s = [21 35 23]; %start of recording

rec_DB(rec).lightOff_s = [22 01 03]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 05 35]; % on the next day
rec_DB(rec).framesOffOn = [19 501]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w025, 2021-07-27, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-27_21-49-20\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-27-07-2021_00183_converted_img';
rec_DB(rec).RecName_save = 'w025__2021-07-27_21-49-20';
rec_DB(rec).ephys_On_s = [21 49 20]; %start of recording

rec_DB(rec).lightOff_s = [22 01 28]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 04 29]; % on the next day
rec_DB(rec).framesOffOn = [10 491]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-28, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-28_21-51-11\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-28-07-2021_00185-converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-28_21-51-11';
rec_DB(rec).ephys_On_s = [21 51 11]; %start of recording

rec_DB(rec).lightOff_s = [22 00 19]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 04 50]; % on the next day
rec_DB(rec).framesOffOn = [8 490]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-29, EEG = 12 (R Ant) LFP = 10 - BIRD TANGLED UP NOT SLEEPING
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-29_21-47-09\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-29-07-2021_00186_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-29_21-47-09';
rec_DB(rec).ephys_On_s = [21 47 09]; %start of recording

rec_DB(rec).lightOff_s = [22 02 17]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 05 19]; % on the next day
rec_DB(rec).framesOffOn = [12 493]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH52.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH49.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-30, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-30_20-54-58\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-30-07-2021_00187_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-30_20-54-58';
rec_DB(rec).ephys_On_s = [20 54 58]; %start of recording

rec_DB(rec).lightOff_s = [22 00 55]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 03 56]; % on the next day
rec_DB(rec).framesOffOn = [46 527]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-07-31, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-07-31_21-50-14\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-31-07-2021_00189_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-07-31_21-50-14';
rec_DB(rec).ephys_On_s = [21 50 14]; %start of recording

rec_DB(rec).lightOff_s = [22 00 43]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 05 15]; % on the next day
rec_DB(rec).framesOffOn = [9 491]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-01, EEG = 12 (R Ant) LFP = 10 -  BIRD TANGLED UP NOT SLEEPING
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-01_22-20-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-01-08-2021_00191_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-08-01_22-20-35';
rec_DB(rec).ephys_On_s = [22 20 35]; %start of recording

rec_DB(rec).lightOff_s = [22 40 23]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 43 24]; % on the next day
rec_DB(rec).framesOffOn = [15 496]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-02, EEG = 12 (R Ant) LFP = 10  - BIRD TANGLED UP NOT SLEEPING
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-02_21-26-05\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-02-08-2021_00193_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-08-02_21-26-05';
rec_DB(rec).ephys_On_s = [21 26 05]; %start of recording

rec_DB(rec).lightOff_s = [22 08 12]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 50 13]; % on the next day
rec_DB(rec).framesOffOn = [30 537]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-03,  - No Data

%% w025, 2021-08-04, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-04_22-02-26\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-04-08-2021_00195_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-08-04_22-02-26';
rec_DB(rec).ephys_On_s = [22 02 26]; %start of recording

rec_DB(rec).lightOff_s = [22 20 20]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 24 52]; % on the next day
rec_DB(rec).framesOffOn = [14 496]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-05, EEG = 12 (R Ant) LFP = 10
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-05_22-06-10\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-05-08-2021_00197_converted_img';
rec_DB(rec).RecName_save = 'w025__2021-08-05_22-06-10';
rec_DB(rec).ephys_On_s = [22 06 10]; %start of recording

rec_DB(rec).lightOff_s = [22 21 13]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 44]; % on the next day
rec_DB(rec).framesOffOn = [12 494]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-06, EEG = 12 (R Ant) LFP = 10 - BIRD TANGLED UP NOT SLEEPING
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-06_20-57-20\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-06-08-2021__00200-converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-08-06_20-57-20';
rec_DB(rec).ephys_On_s = [20 57 20]; %start of recording

rec_DB(rec).lightOff_s = [22 19 54]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 24 25]; % on the next day
rec_DB(rec).framesOffOn = [57 539]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-07, incomplete recording

%% w025, 2021-08-08, EEG = 12 (R Ant) LFP = 10 -  BIRD TANGLED UP NOT SLEEPING
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-08_21-11-29\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-08-08-2021_00203-converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-08-08_21-11-29';
rec_DB(rec).ephys_On_s = [21 11 29]; %start of recording

rec_DB(rec).lightOff_s = [22 9 24]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 13 55]; % on the next day
rec_DB(rec).framesOffOn = [38 520]; % 

rec_DB(rec).eegChans = [21 12; 20 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH12.continuous'; % w025, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH10.continuous'; % w025, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-09, EEG Ch 12, LFP Ch 9, NO VIDEO, from w027
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-09_21-51-42-trigok\';
rec_DB(rec).VideoDir = '';
rec_DB(rec).RecName_save = 'w025__2021-08-09_21-51-42';
rec_DB(rec).ephys_On_s = [21 51 42]; %start of recording

rec_DB(rec).lightOff_s = [22 09 41]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 14 12]; % on the next day
rec_DB(rec).framesOffOn = []; % 

rec_DB(rec).eegChans = [nan 12; nan 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w025, 2021-08-10, EEG Ch 12, LFP Ch 9, NO VIDEO, from w027
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-10_21-59-22\';
rec_DB(rec).VideoDir = '';
rec_DB(rec).RecName_save = 'w025__2021-08-10_21-59-22';
rec_DB(rec).ephys_On_s = [21 59 22]; %start of recording

rec_DB(rec).lightOff_s = [22 09 50]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 14 21]; % on the next day
rec_DB(rec).framesOffOn = []; % 

rec_DB(rec).eegChans = [nan 12; nan 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-11, EEG Ch 12, LFP Ch 9, NO VIDEO
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-11_20-48-49\';
rec_DB(rec).VideoDir = '';
rec_DB(rec).RecName_save = 'w025__2021-08-11_20-48-49';
rec_DB(rec).ephys_On_s = [20 48 49]; %start of recording

rec_DB(rec).lightOff_s = [22 09 46]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 14 18]; % on the next day
rec_DB(rec).framesOffOn = []; % 

rec_DB(rec).eegChans = [nan 12; nan 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;


%% w025, 2021-08-12, EEG Ch 12, LFP Ch 9, NO VIDEO
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-12_21-55-12\';
rec_DB(rec).VideoDir = '';
rec_DB(rec).RecName_save = 'w025__2021-08-12_21-55-12';
rec_DB(rec).ephys_On_s = [21 55 12]; %start of recording

rec_DB(rec).lightOff_s = [22 08 49]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 13 21]; % on the next day
rec_DB(rec).framesOffOn = []; % 

rec_DB(rec).eegChans = [nan 12; nan 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-13, NO DATA

%% w025, 2021-08-14, NO DATA

%% w025, 2021-08-15  BIRD TANGLED UP NOT SLEEPING
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-15_21-52-32\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-15-08-2021_00211_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-08-15_21-52-32';
rec_DB(rec).ephys_On_s = [21 52 32]; %start of recording

rec_DB(rec).lightOff_s = [22 40 26]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 44 58]; % on the next day
rec_DB(rec).framesOffOn = [34 516]; %

rec_DB(rec).eegChans = [nan 12; nan 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-16 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-16_22-11-06\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-16-08-2021_00212_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-08-16_22-11-06';
rec_DB(rec).ephys_On_s = [22 11 06]; %start of recording

rec_DB(rec).lightOff_s = [22 20 12]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 32 14]; % on the next day
rec_DB(rec).framesOffOn = [8 495]; %

rec_DB(rec).eegChans = [nan 12; nan 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-17  
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-17_21-47-03\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_VIDEO\w25-17-08-2021_00214_converted_img\';
rec_DB(rec).RecName_save = 'w025__2021-08-17_21-47-03';
rec_DB(rec).ephys_On_s = [21 47 03]; %start of recording

rec_DB(rec).lightOff_s = [22 06 40]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 11 11]; % on the next day
rec_DB(rec).framesOffOn = [15 497]; %

rec_DB(rec).eegChans = [nan 12; nan 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% w025, 2021-08-18 - No VIDEO
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w025\DATA_EPHYS\chronic_2021-08-18_21-57-57\';
rec_DB(rec).VideoDir = '';
rec_DB(rec).RecName_save = 'w025__2021-08-18_21-57-57';
rec_DB(rec).ephys_On_s = [21 57 57]; %start of recording

rec_DB(rec).lightOff_s = [22 06 55]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 11 27]; % on the next day
rec_DB(rec).framesOffOn = []; %

rec_DB(rec).eegChans = [nan 12; nan 13]; %L_ant %R_ant;  L_post R_post;
%rec_DB(rec).eegChan = '150_CH28.continuous'; % w027, R anterior EEG
%rec_DB(rec).lfpChan = '150_CH25.continuous'; % w027, R LFP, not sure which one, best signal, in nidopallium

rec = rec+1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% W037

%% w037, 2021-08-31 EEG Ch 13, 12, LFP Ch 16
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-08-31_21-59-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_31_08_21_00218_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-08-31_21-59-35';
rec_DB(rec).ephys_On_s = [21 59 35]; %start of recording

rec_DB(rec).lightOff_s = [22 06 00]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 10 25]; % on the next day
rec_DB(rec).framesOffOn = [4 486]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-01, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-01_21-54-15\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_01_09_21_00218_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-01_21-54-15';
rec_DB(rec).ephys_On_s = [21 54 15]; %start of recording

rec_DB(rec).lightOff_s = [22 06 16]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 10 22]; % on the next day
rec_DB(rec).framesOffOn = [10 492]; % 
%rec_DB(rec).CalcOffset_s = 721 ; 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-02, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-02_21-57-58\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_02_09_21_00221_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-02_21-57-58';
rec_DB(rec).ephys_On_s = [21 57 58]; %start of recording

rec_DB(rec).lightOff_s = [22 05 36]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 11 37]; % on the next day
rec_DB(rec).framesOffOn = [7 490]; % 
%rec_DB(rec).CalcOffset_s = 458 ; 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-03, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-03_21-51-46\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_03_09_21_00222_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-03_21-51-46';
rec_DB(rec).ephys_On_s = [21 51 46]; %start of recording

rec_DB(rec).lightOff_s = [21 56 23]; % on same day as start of recording
rec_DB(rec).lightOn_s = [9 57 55]; % on the next day
rec_DB(rec).framesOffOn = [5 485]; % 
%rec_DB(rec).CalcOffset_s = 277 ; 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-04, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-04_22-18-08\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_04_09_21_00223-converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-04_22-18-08';
rec_DB(rec).ephys_On_s = [22 18 08]; %start of recording

rec_DB(rec).lightOff_s = [22 43 46]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 48 18]; % on the next day
rec_DB(rec).framesOffOn = [19 501]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-05, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-05_21-13-37\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_05_09_21_00224_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-05_21-13-37';
rec_DB(rec).ephys_On_s = [21 13 37]; %start of recording

rec_DB(rec).lightOff_s = [22 43 46]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 46 53]; % on the next day
rec_DB(rec).framesOffOn = [62 544]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% No Data, 2021-09-06, Song data is present

%% w037, 2021-09-07, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-07_21-59-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_07_09_21_00225_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-07_21-59-35';
rec_DB(rec).ephys_On_s = [21 59 35]; %start of recording

rec_DB(rec).lightOff_s = [22 14 47]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 19 19]; % on the next day
rec_DB(rec).framesOffOn = [12 494]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-08, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-08_21-26-20\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_08_09_21_00228_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-08_21-26-20';
rec_DB(rec).ephys_On_s = [21 26 20]; %start of recording

rec_DB(rec).lightOff_s = [22 14 25]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 18 57]; % on the next day
rec_DB(rec).framesOffOn = [34 516]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-09, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-09_21-20-35\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_09_09_21_00229_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-09_21-20-35';
rec_DB(rec).ephys_On_s = [21 20 35]; %start of recording

rec_DB(rec).lightOff_s = [21 58 18]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 01 20]; % on the next day
rec_DB(rec).framesOffOn = [27 508]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-10,  
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-10_22-12-57\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_10_09_21_00231_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-10_22-12-57';
rec_DB(rec).ephys_On_s = [22 12 57]; %start of recording

rec_DB(rec).lightOff_s = [22 44 45]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 49 17]; % on the next day
rec_DB(rec).framesOffOn = [23 505]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-11, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-11_21-22-25\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_11_09_21_00233_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-11_21-22-25';
rec_DB(rec).ephys_On_s = [21 22 25]; %start of recording

rec_DB(rec).lightOff_s = [22 13 31]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 19 33]; % on the next day
rec_DB(rec).framesOffOn = [37 519]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-12, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-12_20-26-52\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_12_09_21_00234_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-12_20-26-52';
rec_DB(rec).ephys_On_s = [20 26 52]; %start of recording

rec_DB(rec).lightOff_s = [21 40 19]; % on same day as start of recording
rec_DB(rec).lightOn_s = [09 44 51]; % on the next day
rec_DB(rec).framesOffOn = [51 533]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-13, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-13_22-18-08\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_13_09_21_00237_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-13_22-18-08';
rec_DB(rec).ephys_On_s = [22 18 08]; %start of recording

rec_DB(rec).lightOff_s = [22 40 47]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 45 19]; % on the next day
rec_DB(rec).framesOffOn = [17 499]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-14 - No Data, Song data is present


%% w037, 2021-09-15,
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-15_22-08-48\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_15_09_21_00237_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-15_22-08-48';
rec_DB(rec).ephys_On_s = [22 08 48]; %start of recording

rec_DB(rec).lightOff_s = [22 26 43]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 37 15]; % on the next day
rec_DB(rec).framesOffOn = [14 500]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-16, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-16_21-28-13\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_16_09_21_00238_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-16_21-28-13';
rec_DB(rec).ephys_On_s = [21 28 13]; %start of recording

rec_DB(rec).lightOff_s = [22 20 44]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 16]; % on the next day
rec_DB(rec).framesOffOn = [37 519]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-17, No Data, song data is present


%% w037, 2021-09-18, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-18_21-59-46\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_18_09_21_00239_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-18_21-59-46';
rec_DB(rec).ephys_On_s = [21 59 46]; %start of recording

rec_DB(rec).lightOff_s = [22 20 57]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 29]; % on the next day
rec_DB(rec).framesOffOn = [16 498]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;


%% w037, 2021-09-19, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-19_22-10-06\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_19_09_21_00241_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-19_22-10-06';
rec_DB(rec).ephys_On_s = [22 10 06]; %start of recording

rec_DB(rec).lightOff_s = [22 20 44]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 16]; % on the next day
rec_DB(rec).framesOffOn = [9 491]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-20, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-20_22-02-53\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_20_09_21_00242_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-20_22-02-53';
rec_DB(rec).ephys_On_s = [22 02 53]; %start of recording

rec_DB(rec).lightOff_s = [22 21 13]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 45]; % on the next day
rec_DB(rec).framesOffOn = [14 496]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-21, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-21_21-50-18\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_21_09_21_00243_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-21_21-50-18';
rec_DB(rec).ephys_On_s = [21 21 50]; %start of recording

rec_DB(rec).lightOff_s = [22 20 29]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 1]; % on the next day
rec_DB(rec).framesOffOn = [22 504]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-22, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-22_22-16-19\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_22_09_21_00245_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-22_22-16-19';
rec_DB(rec).ephys_On_s = [22 16 19]; %start of recording

rec_DB(rec).lightOff_s = [22 20 50]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 25 22]; % on the next day
rec_DB(rec).framesOffOn = [5 487]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;


%% w037, 2021-09-23, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-23_21-14-20\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_23_09_21_00246_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-23_21-14-20';
rec_DB(rec).ephys_On_s = [21 14 20]; %start of recording

rec_DB(rec).lightOff_s = [22 5 38]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 10 10]; % on the next day
rec_DB(rec).framesOffOn = [36 518]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-24, - NO DATA

%% w037, 2021-09-25, - NO DATA

%% w037, 2021-09-26, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-26_22-26-22\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_26_09_21_00247_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-26_22-26-22';
rec_DB(rec).ephys_On_s = [22 26 22]; %start of recording

rec_DB(rec).lightOff_s = [22 28 9]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 37 10]; % on the next day
rec_DB(rec).framesOffOn = [3 488]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;

%% w037, 2021-09-27, 
rec_DB(rec).AnalysisDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_EPHYS\chronic_2021-09-27_22-28-22\';
rec_DB(rec).VideoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w037\DATA_VIDEO\1frpm\w037_27_09_21_00248_converted_img\';
rec_DB(rec).RecName_save = 'w037__2021-09-27_22-28-22';
rec_DB(rec).ephys_On_s = [22 28 22]; %start of recording

rec_DB(rec).lightOff_s = [22 31 28]; % on same day as start of recording
rec_DB(rec).lightOn_s = [10 41 59]; % on the next day
rec_DB(rec).framesOffOn = [4 490]; % 

rec_DB(rec).eegChans = [13 nan; 12 nan]; %L_ant %R_ant;  L_post R_post;

rec = rec+1;
