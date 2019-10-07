

%dataDir = 'D:\ExVivo\BullFrog1_InVitro_2019-08-26_14-35-42'; % MAYBE FOR lfp, BUT really all noise
%dataDir = 'D:\ExVivo\BullFrog1_InVitro_2019-08-26_14-57-46'; % MAYBE FOR lfp, BUT really all noise
%dataDir = 'D:\ExVivo\BullFrog1_InVitro_2019-08-26_15-00-20'; % MAYBE FOR lfp, BUT really all noise
%dataDir = 'D:\ExVivo\BullFrog1_InVitro_2019-08-26_15-33-04'; % OK
dataDir = 'D:\ExVivo\BullFrog1_InVitro_2019-08-26_15-34-39'; % OK
%5, 11, 17, 18, 19, 23, 25, 27,

dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject
%%
timeSeriesViewer(dataRecordingObj); % loads all the channels

%%
dataDir = 'C:\Users\Janie\Documents\Data\BullFrog1_InVitro_2019-08-26_15-34-39'; % OK
chanMap = [17 18 19 21 22 23 32 31 30 28 27 26 25 28 24 32 13 9 4 8 7 6 5 3 2 1 10 11 12 14 15 16]; % deepes first
convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys
 
 %%
  
pathToDat = 'C:\Users\Janie\Documents\Data\BullFrog1_InVitro_2019-08-26_15-34-39\dat\BullFrog1_InVitro_2019-08-26_15-34-39.dat';

jrc bootstrap
% use probe silico120_1col_1 - will give 2 peakFeature
%nPeaksFeatures = 2; % (formerly nFet_use) Number of potential peaks to use when computing features
% change nchanels to 16
probePad = [23, 23]; % (formerly vrSiteHW) Recording contact pad size (in m) (Height x width)
shankMap = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; % (formerly viShank_site) Shank ID of each site
siteLoc = [0, 0; 0, 100; 0, 200; 0, 300; 0, 400; 0, 500; 0, 600; 0, 700; 0, 800; 0, 900; 0, 1000; 0, 1100; 0, 1200; 0, 1300; 0, 1400; 0, 1500;
    0, 1600; 0, 1700; 0, 1800; 0, 1900; 0, 2000; 0, 2100; 0, 2200; 0, 2300; 0, 2400; 0, 2500; 0, 2600; 0, 2700; 0, 2800; 0, 2900; 0, 3000]; % (formerly mrSiteXY) Site locations (in m) (x values in the first column, y values in the second column)
siteMap = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]; % (formerly viSite2Chan) Map of channel index to site ID (The mapping siteMap(i) = j corresponds to the statement 'site i is stored as channel j in the recording')

cnfg = [pathToDat(1:end-3) 'prm'];

%%
eval(['jrc probe ' cnfg]);

% Plot Traces
eval(['jrc traces ' cnfg]);
eval(['jrc preview ' cnfg]);

% Detect Spikes
eval(['jrc detect ' cnfg]);
eval(['jrc sort ' cnfg]); % if this crahses it is because nPeaksFeatures needs to be set to 2;

eval(['jrc detect-sort ' cnfg]); % and sort directly

eval(['jrc manual ' cnfg]); % manual checking of clusters

