
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
        
        
        allStimSpikesA(cnnt,:) = StimSpkCntsA;
        allStimSpikesB(cnnt,:) = StimSpkCntsB;
        
     %   ALLStimA{cnnt} = StimA;
      %  ALLStimB{cnnt} = StimB;
        
        ALLStimNameA{cnnt} = StimNameA;
        ALLStimNameB{cnnt} = StimNameB;
        
        cnnt = cnnt+1;
    end
    
end

    [R, P] = corrcoef(allStimSpikesA(:), allStimSpikesB(:));
    [p, h] = ranksum(allStimSpikesA(:), allStimSpikesB(:));


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
