%function [] = loadAudSpikeEpochsToSpikeSort()

%% Add paths
clear all
dbstop if error

%%
switch gethostname
    
    case 'turtle'
    
    
        dirD = '/';
        addpath(genpath('/home/janie/Dropbox/codetocopy/AudioSpike/'));
        addpath(genpath('/home/janie/Dropbox/codetocopy/janieAnalysis_ChickenOT/'));
        addpath(genpath('/home/janie/Dropbox/codetocopy/UMS2K-master/'));
        
        OT_Data_Path = '/home/janie/Data/TUM/OT/Data/OT/Results/';
    
    case 'deadpool'

        
        dirD = '/';
        addpath(genpath('/home/janie/Dropbox/codetocopy/AudioSpike/'));
        addpath(genpath('/home/janie/Dropbox/codetocopy/janieAnalysis_ChickenOT/'));
        addpath(genpath('/home/janie/Dropbox/codetocopy/UMS2K-master/'));
        
    otherwise
    
dirD = '\';
end

disp('added paths...')
%%
dirToLoad = '/home/janie/Data/TUM/Data/OT/Results/_data_20171214/01-HRTF_20171214_163624_0001/';
fileToLoad = [dirToLoad 'result_0001.xml'];
results = audiospike_loadresult(fileToLoad, 1);
disp('loaded results')
%%
[pathstr,name,ext] = fileparts(fileToLoad) ;


bla = find(pathstr == dirD);


%spkSavePath = '/home/janie/Data/TUM/Data/OT/Results/_data_20171204/__SortedSpikes/';
spkSavePath = [pathstr dirD '__SortedSpikes/'];

if exist(spkSavePath , 'dir') == 0
    mkdir(spkSavePath );
end


saveName = [pathstr(bla(end)+1:end) '_SortedSpks'];
savePath = [spkSavePath saveName];

disp(savePath);
%%
Settings = results.Settings;
Stimuli = results.Stimuli;
StimulusSequence = results.StimulusSequence;
Epochs = results.Epoches;

nStims = numel(Stimuli);
nEpochs = numel(Epochs);
Fs = Settings.SampleRate;

stimEpochs = []; stimName = [];
for s = 1:nStims
    correspondEpochsInds = find(StimulusSequence == s); % Finds for each stim 1:x; which epochs that stim was played during
    stimEpochs{s} = correspondEpochsInds; % for each stim, which epochs that stim is on
    stimName{s} = Stimuli(s).Name;
end


allEpochStimInds = []; allEpochData = [];
for j = 1 :nEpochs
    allEpochStimInds(j) = Epochs(j).StimIndex; % Which stim was played during this epoch, in order of the epochs
    allEpochData{j} = Epochs(j).Data;
end

disp(['n stims = ' num2str(nStims)])

%% Organize Stims

allFields = fieldnames(Stimuli);
stimCnt = 1; allStims = []; allStimType = [];

% Azimuth(HRTF)
match = sum(strcmpi(allFields, 'Azimuth'));
if match ==1
    allAz = [];
    for s = 1:nStims
        allAz(s) = Stimuli(s).Azimuth;
    end
    
    uniqueStims = unique(allAz);
    if numel(uniqueStims) > 1
        allStims{stimCnt} = allAz;
        allStimType{stimCnt} = 'Azimuth';
        stimCnt = stimCnt +1;
    end
    
end

% Elevation (HRTF)
match = sum(strcmpi(allFields, 'Elevation'));
if match ==1
    allEl = [];
    for s = 1:nStims
        allEl(s) = Stimuli(s).Elevation;
    end
    uniqueStims = unique(allEl);
    if numel(uniqueStims) > 1
        allStims{stimCnt} = allEl;
        allStimType{stimCnt} = 'Elevation';
        stimCnt = stimCnt +1;
    end
    
end

match = sum(strcmpi(allFields, 'Level_1'));
if match ==1
    allL1 = [];
    for s = 1:nStims
        allL1(s) = Stimuli(s).Level_1;
    end
    
    uniqueStims = unique(allL1);
    
    if numel(uniqueStims) > 1
        allStims{stimCnt} = allL1;
        allStimType{stimCnt} = 'Level_1';
        stimCnt = stimCnt +1;
    end
end

match = sum(strcmpi(allFields, 'Level_2'));
if match ==1
    allL2 = [];
    for s = 1:nStims
        allL2(s) = Stimuli(s).Level_2;
    end
    uniqueStims = unique(allL2);
    
    if numel(uniqueStims) > 1
        allStims{stimCnt} = allL2;
        allStimType{stimCnt} = 'Level_2';
        stimCnt = stimCnt +1;
    end
    
end


match = sum(strcmpi(allFields, 'ITD'));
if match ==1
    allITD = [];
    for s = 1:nStims
        allITD(s) = Stimuli(s).ITD;
    end
    uniqueStims = unique(allITD);
    
    if numel(uniqueStims) >= 1
        allStims{stimCnt} = allITD;
        allStimType{stimCnt} = 'ITD';
        stimCnt = stimCnt +1;
    end
    
end



% WN

wnMatch = sum(strcmpi(Stimuli(1).Name , 'WN-1'));
    
if wnMatch ==1
   
    allWN_Name = [];
    allWN_Num = [];
    for s = 1:nStims
        allWN_Name{s} = Stimuli(s).Name;
        allWN_Num(s) = str2double(Stimuli(s).Name(end));
    end
    
    uniqueStims = unique(allWN_Num);
    
    if numel(uniqueStims) > 1
        allStims{stimCnt} = allWN_Num;
        allStimType{stimCnt} = 'WN';
        stimCnt = stimCnt +1;
    end
    
end

Stims.stimName = stimName;
Stims.stimEpochs = stimEpochs;
Stims.AllStims = allStims;
Stims.allStimType = allStimType;

disp(stimName)
disp(allStimType)
%%
preStim_samps = Settings.PreStimulus*Fs;
stimEnd_samps = 0.2 *Fs;

nStimCat = numel(Stims.AllStims);
epochLength_samps = Settings.EpocheLengthSamples;

if nStimCat ==2
    stimC1 = Stims.AllStims{1};
    stimC2 = Stims.AllStims{2};

elseif nStimCat ==1 
    stimC1 = Stims.AllStims{1};
    stimC2 = 1;
    
end

nUniqueStimC1 = numel(unique(stimC1));
nUniqueStimC2 = numel(unique(stimC2));

disp(nUniqueStimC1);
disp(nUniqueStimC2);

% % I dont know if we need this stuff
% uniqueStims = unique(allEpochStimInds);
% nUniqueStims = numel(uniqueStims);
% 
% allEpochStimIndsIDs= [];
% for j = 1:nUniqueStims
%     allEpochStimIndsIDs{j} = find(allEpochStimInds == j);
% end

%% Plot Epochs

timepoints_samp = (1:Settings.EpocheLengthSamples);
timepoints_s = timepoints_samp / Settings.SampleRate;

figH1 = figure(100); clf
for j = 1 :nEpochs
    plot(timepoints_s, allEpochData{j})
    hold on
    axis tight
    %ylim([-.8 .8])
    %ylim([-1 1])
    %ylim([-.3 .3])
    xlabel('Time [s]')
    grid on
    grid minor
    pause
    
end

%%

thresh0 = 0.1;
%thresh0 = 0.8; C14

figure(figH1)
hold on
line([0 timepoints_s(end)], [thresh0 thresh0], 'color', 'k')


figure(figH1)

disp('Printing Plot')
set(0, 'CurrentFigure', figH1)

FigSaveName = [savePath '_threshold'];

plotpos = [0 0 15 10];
%print_in_A4(0, FigSaveName, export_to, 0, plotpos);
print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);


%% Run Spike Sort

clear('spikes')
spikes = ss_default_params(Fs, 'thresh', thresh0);
spikes = ss_detect(allEpochData,spikes);
%spikes = ss_align(spikes);
spikes = ss_kmeans(spikes);
spikes = ss_energy(spikes);
spikes = ss_aggregate(spikes);

%%

splitmerge_tool(spikes)

%%
outlier_tool(spikes)
%%
clustOfInterest = 1;
FinalSavePath = [savePath '_C' num2str(clustOfInterest)];

disp(['Cluster of interest: ' num2str(clustOfInterest)])

figH2 = figure(102);
plot_waveforms(spikes, clustOfInterest );


figure(figH2)

disp('Printing Plot')
set(0, 'CurrentFigure', figH2)

FigSaveName = [FinalSavePath '_ClustWaveforms-' num2str(clustOfInterest)];

plotpos = [0 0 15 10];
%print_in_A4(0, FigSaveName, export_to, 0, plotpos);
print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);


%%
split_tool(spikes, clustOfInterest )

%% Sort Spikes


stimInfo.Fs = Fs;
stimInfo.nUniqueStimC2 = nUniqueStimC2;
stimInfo.nUniqueStimC1 = nUniqueStimC1;
stimInfo.epochLength_samps = epochLength_samps;
stimInfo.preStim_samps = preStim_samps;
stimInfo.stimEnd_samps = stimEnd_samps;
stimInfo.nStims = nStims;
stimInfo.stimEpochs = stimEpochs;



%%
sortSpikesAndMakeRasters(spikes, clustOfInterest, stimInfo, Stims, FinalSavePath)



