function [] = preProcessAudioSpikeResults()

dirToProcess = 'C:\Janie\Data\OT\Results\_data_20171204\';
dirD = '\';

LoadRawEpoch = 0;

%%
allDirsList = dir([dirToProcess]);
dirsInds = 3:numel(allDirsList);
allDirsNames = [];
nDirs = numel(dirsInds);

cnt = 1;
for j = dirsInds
    allDirsNames{cnt} = allDirsList(j).name;
    cnt = cnt+1;
end

for k = 1: nDirs
    thisDir = [dirToProcess allDirsNames{k} dirD];
    
    resultFiles = dir([thisDir '*spk*' '*xml*']);
    nResultFiles  = numel(resultFiles);
    
    for q = 1:nResultFiles
        
        thisResultFile = [thisDir resultFiles(q).name];
        results = audiospike_loadresult(thisResultFile, LoadRawEpoch);
        
        %%
        Settings = results.Settings;
        %Parameters = results.Parameters;
        Spikes = results.Spikes;
        %NonSelectedSpikes = results.NonSelectedSpikes;
        Stimuli = results.Stimuli;
        StimulusSequence = results.StimulusSequence;
        %Epochs = results.Epoches;
        
        INFO.sampleRate = Settings.SampleRate;
        INFO.epochLength = Settings.EpocheLength;
        INFO.stimReps = Settings.StimulusRepetition;
        INFO.ResultFile = thisResultFile;
        
        %% Organize Stims Responses Into Blocks
        
        nStims = numel(Stimuli);
        nSpks = numel(Spikes);
        %uniqueEpochs = unique(allEpochsWSpks);
        %uniqueStims = unique(allStimsWSpks);
        
        allEpochsWSpks = []; allStimsWSpks = [];
        for ep = 1:nSpks
            allEpochsWSpks(ep) = Spikes(ep).EpocheIndex;
            allStimsWSpks(ep) = Spikes(ep).StimIndex ;
        end
        
        stimEpochs = []; stimName = [];
        for s = 1:nStims
            correspondEpochsInds = find(StimulusSequence == s);
            stimEpochs{s} = correspondEpochsInds;
            stimName{s} = Stimuli(s).Name;
        end
        
        Stims.stimName = stimName;
        Stims.stimEpochs = stimEpochs;
        
        %%
        AllStimResponses_Spk_samp = [];
        AllStimResponses_Spk_s = [];
        for s = 1:nStims
            
            theseEpochs = stimEpochs{s};
            spkResponses_samp = cell(1, numel(theseEpochs));
            spkResponses_s = cell(1, numel(theseEpochs));
            
            match = ismember(theseEpochs, allEpochsWSpks);
            
            if sum(match) == 0 % no spiking responses
                AllStimResponses_Spk_samp{s}  = spkResponses_samp;
                AllStimResponses_Spk_s{s} = spkResponses_s;
                
            else
                matchInds_Epoch = theseEpochs(match);
                matchInds_ThisStim = find(match ==1);
                nMatchInds = numel(matchInds_ThisStim);
                
                for e = 1:nMatchInds
                    thisEpochInd = matchInds_Epoch(e);
                    thisStimInd = matchInds_ThisStim(e);
                    
                    spkInds = find(allEpochsWSpks == thisEpochInd);
                    nSpkInds = numel(spkInds);
                    
                    thisSpk_samp = []; thisSpk_s = [];
                    
                    for spk = 1:nSpkInds
                        thisSpkInd = spkInds(spk);
                        thisSpk_samp(spk) = Spikes(thisSpkInd).SpikePosition;
                        thisSpk_s(spk) = Spikes(thisSpkInd).SpikeTime;
                    end
                    
                    spkResponses_samp{thisStimInd} = thisSpk_samp;
                    spkResponses_s{thisStimInd} = thisSpk_s;
                end
                
                AllStimResponses_Spk_samp{s} = spkResponses_samp;
                AllStimResponses_Spk_s{s} = spkResponses_s;
            end
        end
        
        Spks.AllStimResponses_Spk_samp = AllStimResponses_Spk_samp;
        Spks.AllStimResponses_Spk_s = AllStimResponses_Spk_s;
        
        saveName = [resultFiles(q).name(1:end-4) '-Sorted.mat'];
        savePath = [thisDir saveName];
        
        save(savePath, 'INFO', 'Stims', 'Spks')
        disp(['Saved: ' savePath])
        
        clear('INFO', 'Stims', 'Spks')
        disp('')
    end
end
end



