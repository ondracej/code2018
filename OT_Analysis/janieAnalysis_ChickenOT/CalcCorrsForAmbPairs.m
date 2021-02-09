function [] = CalcCorrsForAmbPairs(experiment, recSession, NeuronName)
dbstop if error

if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

load('/media/dlc/Data8TB/TUM/OT/OTProject/MLD/AmbPairs/PairsToTest.mat');

azPairs = s.azimuthpairs;
elPairs = s.elevationpairs;
neighPairs = s.neighbors;
mixPairs = s.mixpairs;

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'HRTF'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/EnvAnalysis-HRTF/newMLD/';

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)

%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%


disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
load(objPath);
disp(['Loaded: ' objPath])

%bla = C_OBJ.STIMS;

SignalDir = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/Signals/';

sigFormat = '*.wav';


sigNames = dir(fullfile(SignalDir,sigFormat));
%imageNames(1) = [];
%imageNames(1) = [];
sigNames = {sigNames.name}';


%% Settings


%%


AZPairs = calcStimStats(azPairs, C_OBJ, sigNames, SignalDir);

figure(102)
title([NeuronName ' | Az Pairs'])
saveName = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/AmbPairs/PairStats-owl/' NeuronName '-AzDprimes' ];
plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%print_in_A4(0, saveName, '-depsc', 0, plotpos);

figure(104); clf
subplot(2, 2, 1)
scatter(AZPairs.allStimSpikesA(:), AZPairs.allStimSpikesB(:), 'k.')
ylim([0 20])
xlim([0 20])
title([NeuronName ' |Az R = ' num2str(AZPairs.CorrRs)])

ElPairs = calcStimStats(elPairs, C_OBJ, sigNames, SignalDir);

figure(102)
title([NeuronName ' | El Pairs'])
saveName = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/AmbPairs/PairStats/' NeuronName '-ElDprimes' ];
plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%print_in_A4(0, saveName, '-depsc', 0, plotpos);

figure(104); 
subplot(2, 2, 2)
scatter(ElPairs.allStimSpikesA(:), ElPairs.allStimSpikesB(:), 'k.')
ylim([0 20])
xlim([0 20])
title(['El R = ' num2str(ElPairs.CorrRs)])

NeighborPairs = calcStimStats(neighPairs, C_OBJ, sigNames, SignalDir);
figure(102)
title([NeuronName ' | Neighbor Pairs'])
saveName = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/AmbPairs/PairStats/' NeuronName '-NeighDprimes' ];
plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%print_in_A4(0, saveName, '-depsc', 0, plotpos);

figure(104); 
subplot(2, 2, 3)
scatter(NeighborPairs.allStimSpikesA(:), NeighborPairs.allStimSpikesB(:), 'k.')
ylim([0 20])
xlim([0 20])
title(['Neigh R = ' num2str(NeighborPairs.CorrRs)])

MixedPairs = calcStimStats(mixPairs, C_OBJ, sigNames, SignalDir);
figure(102)
title([NeuronName ' | Mixed Pairs'])
saveName = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/AmbPairs/PairStats/' NeuronName '-MixedDprimes' ];
plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%print_in_A4(0, saveName, '-depsc', 0, plotpos);

figure(104); 
subplot(2, 2, 4)
scatter(MixedPairs.allStimSpikesA(:), MixedPairs.allStimSpikesB(:), 'k.')
ylim([0 20])
xlim([0 20])
title(['Mixed R = ' num2str(MixedPairs.CorrRs)])

allPairs.AZPairs = AZPairs;
allPairs.ElPairs = ElPairs;
allPairs.NeighborPairs = NeighborPairs;
allPairs.MixedPairs = MixedPairs;

saveName = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/AmbPairs/PairStats/' NeuronName '-PairCorrs' ];

plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%print_in_A4(0, saveName, '-depsc', 0, plotpos);



saveName = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/AmbPairs/PairStats/' NeuronName '-PairStats.mat' ];
save(saveName, 'allPairs', '-v7.3')





end

function [PAIR] = calcStimStats(PairInfo, C_OBJ, sigNames, SignalDir)


AzimuthNames = C_OBJ.O_STIMS.stimC1;
ElevationNames = C_OBJ.O_STIMS.stimC2;
SpikeReps_samp = C_OBJ.S_SPKS.SORT.AllStimResponses_Spk_samp;

SamplingRate = C_OBJ.SETTINGS.SampleRate;

PreStimStartTime_s = 0; % 0-100  ms
StimStartTime_s = 0.1; % 100  - 200 ms
PostStimStartTime_s = 0.2; % 200 - 300 ms

PreStimStartTime_samp = PreStimStartTime_s* SamplingRate;
StimStartTime_samp = StimStartTime_s* SamplingRate;
PostStimStartTime_samp = PostStimStartTime_s* SamplingRate;


%% First Pass, collapse all the stim reps
% 
% allAz = []; allEl = [];
% for o = 1: numel(PairInfo)
% 
%     thisPair = PairInfo{o};
% 
% allAz = [allAz; thisPair(:,1)];
% allEl = [allEl; thisPair(:,2)];
% 
% end
% 




cnnt = 1;
for o = 1:numel(PairInfo)
    %for o = 1:numel(elPairs)
    
    thesePairs = PairInfo{o};
    %thesePairs = elPairs{o};
    
    cnt = 1;
    MatchingSpikeReps_samp = [];
    for k = 1:size(thesePairs, 1)
        
        thisPair = thesePairs(k,:);
        thisAz = thisPair(1);
        thisEl = thisPair(2);
        
        azMatchesInds = find(AzimuthNames == thisAz);
        elMatchesInds = find(ElevationNames == thisEl);
        
        if isempty(azMatchesInds) || isempty(elMatchesInds)
            continue
        else
            disp('')
            
            stimMatch = ismember(azMatchesInds, elMatchesInds);
            
            matchInd = azMatchesInds(stimMatch);
            
            MatchingSpikeReps_samp{cnt} = SpikeReps_samp{matchInd};
            thisAz_all{cnt} = thisAz;
            thisEl_all{cnt} = thisEl;
            
            stimName = ['az_' num2str(thisAz) '__el_' num2str(thisEl)];
            
         %   [SigData,Fs] = audioread([SignalDir stimName '.wav']);
                
         %   allSigData{cnt} = SigData;
            allSigNames{cnt} = stimName;
            
            cnt = cnt+1;
            
        end
    end
    
    
    if size(MatchingSpikeReps_samp, 2) >1
        disp('')
        
        SpikeReps{cnnt} = MatchingSpikeReps_samp;
        ThisAz{cnnt} = thisAz_all;
        ThisEL{cnnt} = thisEl_all;
     %   Signal{cnnt} = allSigData;
        SignalName{cnnt} = allSigNames;
        
        cnnt  = cnnt+1;
        
    end
    
end
%% We need to compress all the pairs for easier computing next


for j = 1:numel(SpikeReps)
    
    ThisSpikeReps  = SpikeReps{j};
 %   ThisSignal = Signal{j};
    ThisSignalName = SignalName{j};
    
    nSpikReps = numel(ThisSpikeReps);
    
    cnt = 1;
    allComparisonsA = []; allSignalsA = []; SignalNameA = [];
    allComparisonsB = []; allSignalsB = []; SignalNameB = [];
    
    for k = 1:nSpikReps
        
        for kk = 1:nSpikReps
            if k<kk
                allComparisonsA{cnt} = ThisSpikeReps{k};
                allComparisonsB{cnt} = ThisSpikeReps{kk};
                
              %  allSignalsA{cnt} = ThisSignal{k};
               % allSignalsB{cnt} = ThisSignal{kk};
                
                SignalNameA{cnt} = ThisSignalName{k};
                SignalNameB{cnt} = ThisSignalName{kk};
                
                cnt =cnt+1;
            end
            
        end
    end
    
    allCompsA{j} = allComparisonsA;
    allCompsB{j} = allComparisonsB;
    
  %  allCompsSigA{j} = allSignalsA;
  %  allCompsSigB{j} = allSignalsB;

    allCompsSigNameA{j} = SignalNameA;
    allCompsSigNameB{j} = SignalNameB;
end

%%
cnnt = 1;
allStimSpikesA = []; allStimSpikesB = [];
for j = 1:numel(allCompsA)
    
    numPairs = size(allCompsA{j}, 2);
    
    for o = 1:numPairs
        
        PairRepsA = allCompsA{j}{o};
        PairRepsB = allCompsB{j}{o};
        
       % StimA = allCompsSigA{j}{o};
      %  StimB = allCompsSigB{j}{o};
        
        StimNameA = allCompsSigNameA{j}{o};
        StimNameB = allCompsSigNameB{j}{o};
        
        nReps = numel(PairRepsA);
        StimSpkCntsA = []; StimSpkCntsB = [];
        
        for k = 1:nReps
            thisRepA = PairRepsA{k};
            thisRepB = PairRepsB{k};
            
            %PreStimSpkCnts(o) = numel(find(thisRep > PreStimStartTime_samp & thisRep <= StimStartTime_samp));
            StimSpkCntsA(k) = numel(find(thisRepA > StimStartTime_samp & thisRepA <= PostStimStartTime_samp));
            StimSpkCntsB(k) = numel(find(thisRepB > StimStartTime_samp & thisRepB <= PostStimStartTime_samp));
            
         %   StimSpkCntsA_times(k) = thisRepA(thisRepA > StimStartTime_samp & thisRepA <= PostStimStartTime_samp);
         %   StimSpkCntsB_times(k) = thisRepB(thisRepB > StimStartTime_samp & thisRepB <= PostStimStartTime_samp);
            
            %PostStimSpkCnts(o) = numel(find(thisRep > PostStimStartTime_samp & thisRep <= EndTime_samp));
        end
        
        
        %     [p, h] = ranksum(StimSpkCntsA, StimSpkCntsB);
        %     [R, P] = corrcoef(StimSpkCntsA, StimSpkCntsB);
        %
        %     allCorrRs(j) = R(1, 2);
        %     allCorrPs(j) = P(1, 2);
        %
        %     allPs(j) = p;
        %     allHs(j) = h;
        %
        %     allStimSpikesA{j} = StimSpkCntsA;
        %     allStimSpikesB{j} = StimSpkCntsB;
        
        allStimSpikesA(cnnt,:) = StimSpkCntsA;
        allStimSpikesB(cnnt,:) = StimSpkCntsB;
        
     %   ALLStimA{cnnt} = StimA;
      %  ALLStimB{cnnt} = StimB;
        
        ALLStimNameA{cnnt} = StimNameA;
        ALLStimNameB{cnnt} = StimNameB;
        
        cnnt = cnnt+1;
    end
    
end

for q = 1:size(allStimSpikesA, 1)

    repsA =allStimSpikesA(q,:); 
    repsB =allStimSpikesB(q,:); 
    
    meanA = mean(repsA);
    meanB = mean(repsB);
    
    stdA = std(repsA);
    stdB = std(repsB);
    %D_Az_Stim = 2* (AZ_Stim_inds_contra_mean - AZ_Stim_inds_ispi_mean) / sqrt(AZ_Stim_inds_contra_std^2 + AZ_Stim_inds_ispi_std^2);
    
    dAmb(q) = 2* (meanA - meanB) / sqrt(stdA^2 + stdB^2);
    
end

jitterAmount = 0.1;
    jitterValuesX = 2*(rand(size(dAmb))-0.5)*jitterAmount;   % +
    
    cols = cell2mat({[0 0 0]; [.5 .5 .5]});
    %cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
    figure(102); clf
    h = scatterhist(dAmb,jitterValuesX, 'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', cols);
    
    boxplot(h(2),dAmb,'orientation','horizontal',...
        'label',{''},'color', 'k', 'plotstyle', 'compact', 'Whisker', 10);
    
    axis(h(1),'auto');  % Sync axes
%%


    [R, P] = corrcoef(allStimSpikesA(:), allStimSpikesB(:));
    [p, h] = ranksum(allStimSpikesA(:), allStimSpikesB(:));


% PAIR.SpikeReps = SpikeReps;
% PAIR.ThisAz = ThisAz;
% PAIR.ThisEL = ThisEL;
PAIR.dPrimes = dAmb;

PAIR.allStimSpikesA = allStimSpikesA;
PAIR.allStimSpikesB = allStimSpikesB;
%PAIR.ALLStimA = ALLStimA;
%PAIR.ALLStimB = ALLStimB;
PAIR.ALLStimNameA = ALLStimNameA;
PAIR.ALLStimNameB = ALLStimNameB;

PAIR.CorrRs = R(1,2);
PAIR.CorrPs = P(1,2);
PAIR.SigHs = h;
PAIR.SigPs = p;
end

