
function [] = organizePlexonSpikeTimesIntoStimRepetitions(INFO, Channel01, fileNameBase, StimType)

dbstop if error
saveDir = 'X:\Janie-OT-MLD\Analysis2025\PlexonSpikeSorting\';

Fs = 44100;
%
spikes.times_s = Channel01(:,3);
spikes.times_samp = round(spikes.times_s*Fs);

spikes.pc1 = Channel01(:,4);
spikes.pc2 = Channel01(:,5);
spikes.pc3 = Channel01(:,6);
spikes.ID = Channel01(:,2);
spikes.waveform = Channel01(:,7:78);

stimROIs = INFO.thisStimROI{1,1};
stimInds = INFO.thisStimInds{1,1};

nROIs = size(stimROIs, 1);
nInds = size(stimInds, 2);

if nROIs ~= nInds
    disp('There is a mismatch...')
    keyboard
end

maxInd = max(stimInds);
stimNames = INFO.thisStimNames{1,1};
nStimNames = numel(stimNames);

if maxInd ~= nStimNames
    disp('There is a mismatch...')
    keyboard
end

%% Start Sorting the spikes to the stims. Rel spikes are relative to the onset of the stim, Abs spikes are the abosolut time
%% all spike times are in S
spks_samp_abs = []; spks_samp_rel = [];
for j = 1:nROIs
    
    thisROI_samp = stimROIs(j,:);
    
    spks_samp_abs{j} = spikes.times_samp (find(spikes.times_samp >= thisROI_samp(1) & spikes.times_samp <= thisROI_samp(2)));
    spks_samp_rel{j} = spks_samp_abs{j}-thisROI_samp(1);
    
end

%% Organize into Stim repetitions

I.thisStimC1 = INFO.thisStimC1{1,1}; 
I.thisStimC2 = INFO.thisStimC2{1,1}; 
I.StimInfo = INFO.thisStimAlLStimuli{1,1};
I.StimNames = INFO.thisStimNames{1,1};
I.StimDir = INFO.audStimDir{1,1};
I.stimROIs = stimROIs;
I.stimInds = stimInds;
I.Fs = Fs;

switch StimType
    
    case 1 %HRTF
        
        I.StimType = 'HRTF';
        
    case 5
        I.StimType = 'WN';
end

for k = 1:maxInd
    allInds = find(stimInds == k);
    
    spks_samp_abs_stims{k} = spks_samp_abs(allInds);
    spks_samp_rel_stims{k} = spks_samp_rel(allInds);
end


saveName = [saveDir fileNameBase 'StimSpkSorted_' I.StimType];
save(saveName, 'spks_samp_abs_stims', 'spks_samp_rel_stims', 'I', 'spikes')

disp(['Saved:' saveName])


end