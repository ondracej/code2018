%% Make a dat file

pathToCodeRepository = 'C:\Users\Janie\Documents\GitHub\code2018\';
addpath(genpath(pathToCodeRepository)) 
%% Check files with timeseries viewer

pathToNSKToolbox = 'C:\Users\Janie\Documents\GitHub\NeuralElectrophysilogyTools\';
addpath(genpath(pathToNSKToolbox)) 

dataDir = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Ephys';


dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

%dataRecordingObj = binaryRecording(dataDir);

timeSeriesViewer(dataRecordingObj); % loads all the channels
%7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9 %chonic - 71-76
%14 13 1 16 5 12 6 11 8 9 %chonic - o3b7
%5, 4, 6, 3, 9, 16, 8, 1, 11, 14, 12, 13, 10, 15, 7, 2
%8 10 2 12 16 6 14 5 4 Hamed -  70-86
% 9 13 2 6 - 72-81
%10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2 % tetrode shanks, by columns,medial to lateral
% 10 9 3 13 12 6 16 15 7 8 4 14 11 5 1 2 % by rows, top to bottom ***


%LFP scale = 500 (chicken)
%LFP scale = 400 (ZF)
%Spike scale = 150 (chicken)
%Spike scale = 100 (ZF)
%timeWin = 20000

%% Make a .dat file
dataDir = 'D:\TUM\SWR-Project\ZF-o3-b7\Ephys\20200207\12-34-10\Ephys'; % leave away last slash

%chanMap = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5]; % deepes first, acute
chanMap = [9 8 11 6 12 5 16 1 13 4 14 3 15 2 10 7]; %chonic

%chanMap = [1 13]; %chonic
%chanMap = [11 5 1 2 7 8 4 14 12 6 16 15 10 9 3 13]; %tetrode, by rows, deepest first
%chanMap = [2 1 5 11 14 4 8 7 15 16 6 12 13 3 9 10]; %tetrode, by rows, deepest first
convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys
disp(['Finished: ' dataDir])
    
%% Bin File
preFilterOpehEphyDataForDatFile



%% Use Kilosort2 GUI (need a dat file) - Do not add path to other code repositories!!
% sosme reason cant find the UIextras gui info

kilsort2Path = 'C:\Users\Janie\Documents\GitHub\Kilosort2\';
addpath(genpath(kilsort2Path))
pathToNumpy = 'C:\Users\Janie\Documents\GitHub\npy-matlab\';
addpath(genpath(pathToNumpy))

kilosort

% Thesh = 10,4
%ops.nt0 = 25; % number of time samples for the templates (has to be <=81 due to GPU shared memory) %JO

%Code changed in 
%getKernels
%preprocessDataSub
%computeWhitening



%%
% Make sure to enter
ks = get(gcf, 'UserData');
ks.ops.Th = [5 3];  
ks.ops.minFR = 0;  
% on the GUI
ks.ops.minFR = 1/100; 
%ks.rez.temp.Nbatch = 6400;;
ks.rez.temp.Nbatch = 12800; %% THis works!!! 


ks.ops.minFR = 1/100; 
ks.ops.ntbuff              = 32; %64
%ks.ops.NT                  = 5*1024+ ks.ops.ntbuff; %64 must be multiple of 32 + ntbuff.
ks.ops.NT                  = 12800; %64 must be multiple of 32 + ntbuff.
%ks.ops.whiteningRange      = 16; 

    
%% Classic method

master_kilosort_JO

master_kilosort_JO_acute




%% JRCLust Kilosort Import
%https://github.com/JaneliaSciComp/JRCLUST/issues/18

pathToJRCLUST = 'C:\Users\Janie\Documents\GitHub\JRCLUST';
%pathToJRCLUST = 'C:\Users\Janie\Documents\code\JRCLUST-patch4.0';
addpath(genpath(pathToJRCLUST)) 

pathToNumpy = 'C:\Users\Janie\Documents\GitHub\npy-matlab\';
addpath(genpath(pathToNumpy))

%% Import Kilosort
%jrc import-ksort /path/to/your/rez.mat sessionName
jrc import-ksort 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\dat\KImportJRClust\'  '2019-04-28_19-34-00.dat'

%% Manual clustering
cnfg = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\dat\KImportJRClust\2019-04-28_19-34-00.prm';
%eval(['jrc preview ' cnfg]);
%
eval(['jrc manual ' cnfg]); % manual checking of clusters

%% Ironclust

%irc2 [path_to_my_recording.bin] [myprobe.prb] (output_dir) # specify the probe file, output to `myprobe` the recording directory
irc2 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\dat\2019-04-28_19-34-00.dat'

irc2 [path_to_my_recording.dat] [myprobe.prb] (output_dir)

%% Jrclust from scratch


pathToJRCLUST = 'C:\Users\Janie\Documents\GitHub\JRCLUST';
%pathToJRCLUST = 'C:\Users\Janie\Documents\code\JRCLUST-patch4.0';
addpath(genpath(pathToJRCLUST)) 

pathToNumpy = 'C:\Users\Janie\Documents\GitHub\npy-matlab\';
addpath(genpath(pathToNumpy))
%%

pathToDat = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\dat\JRCLust\2019-04-28_19-34-00.dat';

jrc bootstrap
% use probe silico120_1col_1 - will give 2 peakFeature
%nPeaksFeatures = 2; % (formerly nFet_use) Number of potential peaks to use when computing features
% change nchanels to 16
probePad = [23, 23]; % (formerly vrSiteHW) Recording contact pad size (in m) (Height x width)
shankMap = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; % (formerly viShank_site) Shank ID of each site
siteLoc = [0, 0; 0, 100; 0, 200; 0, 300; 0, 400; 0, 500; 0, 600; 0, 700; 0, 800; 0, 900; 0, 1000; 0, 1100; 0, 1200; 0, 1300; 0, 1400; 0, 1500]; % (formerly mrSiteXY) Site locations (in m) (x values in the first column, y values in the second column)
siteMap = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]; % (formerly viSite2Chan) Map of channel index to site ID (The mapping siteMap(i) = j corresponds to the statement 'site i is stored as channel j in the recording')

cnfg = [pathToDat(1:end-3) 'prm'];
%%

%cnfg = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\dat\2019-04-28_19-34-00.prm';

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

