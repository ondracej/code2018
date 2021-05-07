%avianSWRAnalysis_SCRIPTS

close all
clear all
dbstop if error

% Code dependencies
pathToCodeRepository = 'C:\Users\Janie\Documents\GitHub\code2018\';
pathToOpenEphysAnalysisTools = 'C:\Users\Janie\Documents\GitHub\analysis-tools\';
pathToNSKToolbox = 'C:\Users\Janie\Documents\GitHub\NeuralElectrophysilogyTools\';
pathToJRCLUST = 'C:\Users\Janie\Documents\GitHub\JRCLUST';

addpath(genpath(pathToCodeRepository)) 
addpath(genpath(pathToOpenEphysAnalysisTools)) 
addpath(genpath(pathToNSKToolbox)) 
addpath(genpath(pathToJRCLUST)) 

%pathToKiloSort = 'C:\Users\Janie\Documents\GitHub\Kilosort2\';
%pathToNumpy = 'C:\Users\Janie\Documents\GitHub\npy-matlab\';
%addpath(genpath(pathToKiloSort))
%addpath(genpath(pathToNumpy))
            

%% Define Session

%% Metal Electrode

%% Chick-09 | 1 MOhm Electrode in DVR, EKG, Temp noted down
%% 33 - 53

%% 16 Ch Silicon Probes

%% Chick-10 | 16-ch silicone probe in DVR (54-58)

% 54 coords_DV  = 2000;
% 55 coords_DV  = 3000;
% 56 coords_DV  = 4000;
% 57 coords_DV  = 4000;
% 58 coords_DV  = 4000;

%% ZF-59-15 | 16-ch silicone probe in DVR (59 - 63)

% 59 coords_DV  = 2000;
% 60 coords_DV  = 2500;
% 61 coords_DV  = 3000; %19-34-00
% 62 coords_DV  = 3500;
% 63 coords_DV  = 1500; % largest = ch 2

%% ZF-60-88 |  16-ch silicone probe in DVR (64 - 75)
% 64 coords_DV  = 1000; % 7 best chan, 5, 4, 6, 3, 9, 16 out of brain?
% 65 coords_DV  = 1000; % 2 best chan, 5:1 are inverted
% 66 coords_DV  = 2000; % spikes: 3, 16, 13, best LFP; 9, 16, 8, 1
% 67 coords_DV  = 2500;
% 68 coords_DV  = 3000;
% 69 coords_DV  = 3500;
% 70 coords_DV  = 4000;
% 71 coords_DV  = 1000; %% Inversion - very nice
% 72 coords_DV  = 1500;
% 73 coords_DV  = 2000;
% 74 coords_DV  = 3000; Cerebellum
% 75 coords_DV  = 3000; NCNM? bird died

%% 71-76 - 16 ch chronic silicon probe
% (90) ZF-71-76 | 15.09.2019 - 17-48-44 -- Isoflorane
% (91) ZF-71-76 | 15.09.2019 - 18-03-52 -- Isoflorane
% (92) ZF-71-76 | 15.09.2019 - 18-17-37 -- Isoflorane
% (93) ZF-71-76 | 15.09.2019 - 18-21-24 -- Isoflorane
% (94) ZF-71-76 | 15.09.2019 - 18-32-10 -- Isoflorane
% (95) ZF-71-76 | 15.09.2019 - 18-46-58 -- Isoflorane
% (96) ZF-71-76 | 15.09.2019 - 19-50-51 --  short
% (97) ZF-71-76 | 15.09.2019  - 19-55-39 -- short
% (98) ZF-71-76 | 15.09.2019  - 20-01-48 -- Overnight 
% (99) ZF-71-76 | 16.09.2019  - 08-48-23 -- Day recording - 2 hrs
% (100) ZF-71-76 | 16.09.2019  - 18-01-51 - short
% (101) ZF-71-76 | 16.09.2019  - 18-05-58 - Overnight *** good some % problems with data??
% (102) ZF-71-76 | 17.09.2019  - 09-00-29 - Day recording - long 7 hrs
% (103) ZF-71-76 | 17.09.2019  - 16-04-39 - Day recording - short
% (104) ZF-70-86 | 17.09.2019  - 16-05-11 - Overnight *** good
% (105) ZF-70-86 | 18.09.2019  - 18-04-28 - Overnight ***
% (106) ZF-70-86 | 19.09.2019  - 17-39-19 - Short
% (107) ZF-70-86 | 19.09.2019  - 17-51-46 - Overnight *** good
% (108) ZF-70-86 | 20.09.2019  - 12-10-40 - Daytime
% (109) ZF-70-86 | 20.09.2019  - 18-37-00 - Overnight *** good
% (110) ZF-70-86 | 23.09.2019  - 18-21-42 - Overnight ***

%% o3b7 Chronic 16-ch silicone probe in DVR 

% (111) ZF-o3b7 | 01.15.2020  - 12-49-06_acute
% (112) ZF-o3b7 | 01.15.2020  - 13-34-00_acute
% (113) ZF-o3b7 | 01.15.2020  - 18-24-27 Overnight
% (114) ZF-o3b7 | 01.16.2020  - 18-21-31 Overnight
% (115) ZF-o3b7 | 01.17.2020  - 17-56-38 Overnight
% (116) ZF-o3b7 | 01.18.2020  - 19-50-48 Overnight
% (117) ZF-o3b7 | 01.19.2020  - 20-14-53 Overnight
% (118) ZF-o3b7 | 01.21.2020  - 20-02-13 Overnight
% (119) ZF-o3b7 | 01.22.2020  - 10-32-54 Daytime
% (120) ZF-o3b7 | 01.22.2020  - 15-00-47 Daytime
% (121) ZF-o3b7 | 01.22.2020  - 20-15-48 Overnight
% (122) ZF-o3b7 | 01.25.2020  - 18-01-36 Overnight
% (123) ZF-o3b7 | 01.28.2020  - 09-51-01 Morning
% (124) ZF-o3b7 | 01.28.2020  - 10-30-55 Morning - very short
% (125) ZF-o3b7 | 01.28.2020  - 10-34-56 Morning/Afternoon
% (126) ZF-o3b7 | 01.28.2020  - 19-32-36 Evening - short
% (127) ZF-o3b7 | 01.28.2020  - 19-37-53 Ovenright
% (128) ZF-o3b7 | 01.29.2020  - 09-03-33 Morning
% (129) ZF-o3b7 | 01.29.2020  - 14-27-20 Afternoon
% (130) ZF-o3b7 | 02.03.2020  - 18-41-49 Overnight
% (131) ZF-o3b7 | 02.04.2020  - 10-42-31 Morning
% (132) ZF-o3b7 | 02.04.2020  - 14-54-30 Afternoon
% (133) ZF-o3b7 | 02.04.2020  - 15-09-36 Afternoon - v short
% (134) ZF-o3b7 | 02.04.2020  - 15-11-58 Afternoon short
% (135) ZF-o3b7 | 02.07.2020  - 09-39-35 Morning
% (136) ZF-o3b7 | 02.07.2020  - 12-34-10 Noon
% (137) ZF-o3b7 | 02.07.2020  - 16-25-09 Afternoon
% (138) ZF-o3b7 | 02.08.2020  - 20-02-19 Overnight
% (139) ZF-o3b7 | 02.09.2020  - 11-10-19 Morning
% (140) ZF-o3b7 | 02.09.2020  - 19-18-42 Overnight
% (141) ZF-o3b7 | 02.10.2020  - 11-45-32 Morning
% (142) ZF-o3b7 | 02.10.2020  - 19-10-58 Overnight

%% 70-01 16-ch silicone probe in DVR - no SWRs
% (143) ZF-70-01  | 01.09.2020 - 17-27-44 - no SWRs
% (144) ZF-70-01  | 01.09.2020 - 17-33-32 - no SWRs
% (144) ZF-70-01  | 01.09.2020 - 17-47-43 - no SWRs
%% 71-56 4x4 AP 16-ch silicone probe in DVR

% (148) ZF-71-56  | 11.27.2019 - 13-20-00 - DV 1000
% (149) ZF-71-56  | 11.27.2019 - 13-56-42  - DV 1500
% (150) ZF-71-56  | 11.27.2019 - 14-02-19  - DV 1500
% (151) ZF-71-56  | 11.27.2019 - 14-38-38  - DV 2000
% (152) ZF-71-56  | 11.27.2019 - 15-13-25  - DV 2500
% (153) ZF-71-56  | 11.27.2019 - 16-06-52  - DV 1700
% (154) ZF-71-56  | 11.27.2019 - 16-43-33  - DV 2300


%% 72-01 4x4 ML 16-ch silicone probe in DVR

% (155) ZF-72-01  | 02.25.2021 - 14-52-03  - P1; DV 2000
% (156) ZF-72-01  | 02.25.2021 - 15-05-52 - P1; DV 2000
% (157) ZF-72-01  | 02.25.2021 - 15-18-05 - P1; DV 2000
% (158) ZF-72-01  | 02.25.2021 - 15-42-52 - P1; DV 3000
% (159) ZF-72-01  | 02.25.2021 - 16-05-47 - P2; DV 2000
% (160) ZF-72-01  | 02.25.2021 - 16-15-23 - P2; DV 2000
% (161) ZF-72-01  | 02.25.2021 - 16-44-46 - P2; DV 3000
% (162) ZF-72-01  | 02.25.2021 - 17-16-39 - P3; DV 2000
% (163) ZF-72-01  | 02.25.2021 - 17-18-52 - P3; DV 2000
% (164) ZF-72-01  | 02.25.2021 - 17-21-11 - P3; DV 2000
% (165) ZF-72-01  | 02.25.2021 - 17-42-17 - P3; DV 2400


%% 72-96 4x4 ML 16-ch silicone probe in DVR
% (166) ZF-72-96  | 01.08.2020 - 13-57-02 - P1; DV 2000
% (167) ZF-72-96  | 01.08.2020 - 14-03-08 - P1; DV 2000
% (168) ZF-72-96  | 01.08.2020 - 15-02-07 - P2; DV 2000 - Broken Probe


%% o3b11 4x4 AP 16-ch silicone probe in DVR
% (169) ZF-o3b11  | 02.23.2021 - 13-57-02 - P1; DV 2000
% (170) ZF-o3b11  | 02.23.2021 - 14-11-12 - P1; DV 2000
% (171) ZF-o3b11  | 02.23.2021 - 14-39-42 - P1; DV 3000
% (172) ZF-o3b11  | 02.23.2021 - 15-00-06 - P1; DV 3000
% (173) ZF-o3b11  | 02.23.2021 - 15-28-53 - P2; DV 2000
% (174) ZF-o3b11  | 02.23.2021 - 15-53-20 - P2; DV 3000
% (175) ZF-o3b11  | 02.23.2021 - 16-18-43 - P3; DV 2000
% (176) ZF-o3b11  | 02.23.2021 - 16-34-06 - P4; DV 2000
% (177) ZF-o3b11  | 02.23.2021 - 16-57-21 - P4; DV 3000
% (178) ZF-o3b11  | 02.23.2021 - 17-04-31 - P4; DV 3000



%% LFP and EEG - Do not Use

%% ZF-72-81 | 2 LFP, 2 EEG (76 - 82)
% 9,10,11 LFP 1;
% 13,14,15,16 LFP2;
% 2,3 EEG1;
% 6,7 EEG2

% 76 coords_DV  = 2000; under isoflorane
% 77 coords_DV  = 2000; under isoflorane
% 78 coords_DV  = 2000;  1.5% under anesthesia';
% 79 coords_DV  = 2000; 'no isoflurane, 0%';
% 80 coords_DV  = 2000; chronic waking up
% 81 coords_DV  = 2000; chronic night
% 82 coords_DV  = 2000; chronic overnight

% 2, 3, 6, 7, 9, 10, 13, 14
%% ZF-70-86 | 2 LFP, 4 EEG (83 - 89)
%8, 10 LFP;
% 2, 12, 16, 6, 14, 5 EEG;
%4 EMG

% 83
% 84 %- too short
% 85 %- too short
% 86 %- too short
% 87
% 88
% 89
%dataDir = 'F:\TUM\SWR-Project\ZF-70-86\eeg-lfpChronic_2019-05-24_19-12-50';

% 4, 2, 14, 12, 16, 6, 5, 10, 8

%% Make Channel Map for Marks code

% saveDir = 'C:\Users\Administrator\Documents\code\GitHub\NET\timeSeriesViewer\electrode layouts\layout_16_A16_5mm_wAdapter.mat';
% 
% En = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2]';
% Ena = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2]';
% Enp = [];
% 
% save(saveDir, 'En', 'Ena', 'Enp')

%% Define Record
%recSession =  98; dat
%recSession =  101; %good / dat - done
%recSession =  104; %good / dat - processing
%recSession =  102; %processing
%recSession =  107; %good 
%recSession =  109; %good
%recSession =  110;

%%
%(81) ZF-72-81 | 16.05.2019 - 21-26-59 - Overnight
%recSession =  81;
recSession =  113;

D_OBJ = avianSWRAnalysis_OBJ(recSession);

%%
recSet = [64:74]; %55
nrecs = numel(recSet);
doPlot = 0;
   chanMap = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2]; %acute
   %chanMap = [7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9]; %chronic
for j = 1:nrecs
    
    recSession = recSet(j);
    disp(['Rec Session:' num2str(recSession)])
    D_OBJ = avianSWRAnalysis_OBJ(recSession);
    
    %detectSWRs_ripple_SW_Band(D_OBJ)
    %validateSWRs(D_OBJ, doPlot)
    %extractSHRs(D_OBJ)
    calcCorrsForChans(D_OBJ, chanMap, doPlot)
    
    
    %calcSWR_CSD(D_OBJ)
end

%%
getTriggers(D_OBJ)
 
%%

plotDBRatioWithData(D_OBJ)

plotDBRatioMatrix(D_OBJ)

plotPowerSpectrum(D_OBJ)

%%

%detectSWR_w_NEO(D_OBJ)

detectSWRs_ripple_SW_Band(D_OBJ)



%%
recSession =  104;

D_OBJ = avianSWRAnalysis_OBJ(recSession);
dataDir = D_OBJ.DIR.ephysDir;

 
dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels
%7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9 %chonic


%% Batch process data

allRecSessions = [95];
%chanMap = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5]; % deepes first
chanMap = [9 8 11 6 12 5 16 1 13 4 14 3 15 2 10 7]; % 9 is deepest
%chanMap = [7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9]; % deepes first
for j = 1:numel(allRecSessions)
    
    recSession = allRecSessions(j);
    disp([num2str(recSession) '/' num2str(allRecSessions(end))])
        
    D_OBJ = avianSWRAnalysis_OBJ(recSession);
    disp([D_OBJ.INFO.Name ': ' D_OBJ.Session.time])
   %
    dataDir = D_OBJ.DIR.ephysDir;
    dataDir = dataDir(1:end-1);
   
    convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys
    
    dbstop if error
    dataRecordingObj = OERecordingMF(dataDir);
    dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject
    %calcCSD(D_OBJ, dataRecordingObj)
end

%%

recSession = 95;

%dataDir = 'D:\ZF-\Ephys\71-76_chronic_2019-09-15_20-01-48';
%dataDir = 'D:\ZF-\Ephys\71-76_chronic_2019-09-16_18-05-58';
%dataDir = 'D:\ZF-\Ephys\YFAcute_2019-09-15_18-32-10';
%dataDir = 'D:\ZF-\Ephys\YFAcute_2019-09-15_18-03-52';

D_OBJ = avianSWRAnalysis_OBJ(recSession);
disp([D_OBJ.INFO.Name ': ' D_OBJ.Session.time])
%
dataDir = D_OBJ.DIR.ephysDir;

dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels
%7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9 %chonic
%5, 4, 6, 3, 9, 16, 8, 1, 11, 14, 12, 13, 10, 15, 7, 2
%LFP scale = 500
%Spike scale = 150
%timeWin = 40000
%%
%dataDir = 'D:\ZF-\Ephys\71-76_chronic_2019-09-16_18-05-58';
%dataDir = 'D:\ZF-\Ephys\71-76_chronic_2019-09-15_20-01-48';
dataDir = 'D:\TUM\SWR-Project\ZF-71-76\71-76_chronic_2019-09-17_16-05-11';
chanMap = [7 10 2 15 3 14 13 1 16 5 12 6 11 8 9]; %4 is broken
convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys

%% Spikesorting with JRCLUST - must run in matlab 2019

pathToDat = 'D:\TUM\SWR-Project\Chick-10\20190427\19-33-33\dat\19-33-33.dat';
%% Chick-10

%pathToDat = 'D:\TUM\SWR-Project\Chick-10\20190427\21-58-36\dat\2019-04-27_21-58-36.dat';
pathToDat = 'D:\TUM\SWR-Project\Chick-10\20190427\20-49-27\dat\2019-04-27_20-49-27.dat';
dataDir = 'D:\TUM\SWR-Project\Chick-10\20190427\20-49-27\Ephys';
%% ZF-59-15

% 18-07-21
pathToDat = 'D:\TUM\SWR-Project\ZF-59-15\Ephys\20190428\18-07-21\Ephys\dat\2019-04-28_18-07-21.dat';

%18-48-02
pathToDat = 'D:\TUM\SWR-Project\ZF-59-15\20190428\18-48-02\dat\2019-04-28_18-48-02.dat';

dataDir = 'D:\TUM\SWR-Project\ZF-59-15\Ephys\20190428\19-34-00\Ephys';
pathToDat = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\dat\2019-04-28_19-34-00.dat';

%% ZF 60-88

pathToDat = 'D:\TUM\SWR-Project\ZF-60-88\20190429\16-26-20\dat\2019-04-29_16-26-20.dat';

%% 71-76
pathToDat = 'D:\TUM\SWR-Project\ZF-71-76\20190915\18-46-58_acute\dat\18-46-58_acute.dat';


%%
dataDir = 'D:\TUM\SWR-Project\ZF-o3-b7\chronic_2020-01-25_18-01-36';

dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels
%5, 4, 6, 3, 9, 16, 8, 1, 11, 14, 12, 13, 10, 15, 7, 2

%% Filtered Bin Files

pathToDat = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\bin\JRClustFil\';

%%
jrc bootstrap
% use probe silico_feb8_1colA.prb - will give 2 peakFeature
%nPeaksFeatures = 2; % (formerly nFet_use) Number of potential peaks to use when computing features
% change nchanels to 16
probePad = [23, 23]; % (formerly vrSiteHW) Recording contact pad size (in m) (Height x width)
shankMap = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; % (formerly viShank_site) Shank ID of each site
siteLoc = [0, 0; 0, 100; 0, 200; 0, 300; 0, 400; 0, 500; 0, 600; 0, 700; 0, 800; 0, 900; 0, 1000; 0, 1100; 0, 1200; 0, 1300; 0, 1400; 0, 1500]; % (formerly mrSiteXY) Site locations (in m) (x values in the first column, y values in the second column)
siteMap = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]; % (formerly viSite2Chan) Map of channel index to site ID (The mapping siteMap(i) = j corresponds to the statement 'site i is stored as channel j in the recording')

cnfg = [pathToDat(1:end-3) 'prm'];
%%

cnfg = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\bin\JRClustFil\20190428.prm';

%Check probe layout
eval(['jrc probe ' cnfg]);

% Plot Traces
eval(['jrc traces ' cnfg]);
eval(['jrc preview ' cnfg]);

% Detect Spikes
eval(['jrc detect ' cnfg]);
eval(['jrc sort ' cnfg]); % if this crahses it is because nPeaksFeatures needs to be set to 2;

eval(['jrc detect-sort ' cnfg]); % and sort directly

eval(['jrc manual ' cnfg]); % manual checking of clusters

%% Sharp Wave Detection
%detectSWRs(D_OBJ, dataRecordingObj)

%ZF
recSession = 67;
chan = 5; % 67

%Chick
recSession = 58;
chan = 2; % 57

D_OBJ = avianSWRAnalysis_OBJ(recSession);
disp([D_OBJ.INFO.birdName ': ' D_OBJ.Session.time])

%% SWR detection
dataDir = D_OBJ.Session.SessionDir;
dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject
chan = 15;
D_OBJ = detectSWRs_SleepAnalysisObj(chan, D_OBJ, dataRecordingObj);

D_OBJ =  detectSWRsOld(D_OBJ, dataRecordingObj);
D_OBJ =  detectSWRsOld_rippleBand(D_OBJ, dataRecordingObj);
%D_OBJ =  detectSWRsOld_LF_first(D_OBJ, dataRecordingObj);
%%
plotConsecutiveSWRs(D_OBJ, dataRecordingObj);

%%
calcCSD(D_OBJ, dataRecordingObj)

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
% 
% pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort\';
% pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';
% 
% addpath(genpath(pathToKiloSort))
% addpath(genpath(pathToNumpy))
%             
% pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\'; 
% 
% % Config Files - check that the channel map is set correctly there!
% %nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_6088.m';
% nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915.m';
% %nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_7281.m';
% %nameOfConfigFile =  'StandardConfig_avian16Chan_Chick10';
% runKilosortFromConfigFile(D_OBJ, pathToYourConfigFile, nameOfConfigFile)
% 
% disp(['Finished Processing ' D_OBJ.Session.SessionDir])

%%



%% Create Dat File

dataDir = 'C:\Users\Janie\Documents\Data\SWR-Project\ZF-60-88\Ephys\2019-04-29_14-43-33'; % leave away last slash
%chanMap = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2];
chanMap = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5]; % deepes first

    convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys
    
    %%
%make sure to move the .dat file to the data directory
    kilosort
    %ops.fshigh = 150;   
    %ks.ops.Th = [10 4];  
    
    ks = get(gcf, 'UserData');
    %ks.ops.fshigh = 300;
    ks.ops.fshigh = 150;
    ks.ops.Th = [5 3];  
    ks.ops.minFR = 0;  
    
    
    %%



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




