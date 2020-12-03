function [] = calcCharFreqTuning()


ObjDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/allTuningObjs/';

saveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/TuningCurves/';
trialSeach = ['*.mat*'];

trialNamesStruct = dir(fullfile(ObjDir, trialSeach));
nTrials = numel(trialNamesStruct);
for j = 1:nTrials
    trialNames{j} = trialNamesStruct(j).name;
end

%%



for s = 13:nTrials
    s
    d = load([ObjDir trialNames{s}]);
    
    C_OBJ = d.C_OBJ;
    
    SamplingRate = C_OBJ.SETTINGS.SampleRate;
    PreStimStartTime_s = 0; % 0-100  ms
    StimStartTime_s = 0.1; % 100  - 200 ms
    PostStimStartTime_s = 0.2; % 200 - 300 ms
    EndTime = 0.3;
    
    PreStimStartTime_samp = PreStimStartTime_s* SamplingRate;
    StimStartTime_samp = StimStartTime_s* SamplingRate;
    PostStimStartTime_samp = PostStimStartTime_s* SamplingRate;
    EndTime_samp = EndTime* SamplingRate;

    
    %bla = C_OBJ.STIMS;
    
    allSpksMatrix = C_OBJ.S_SPKS.SORT.allSpksMatrix;
    epochLength_samps = C_OBJ.S_SPKS.INFO.epochLength_samps;
    thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
    
    
    stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
    
    nStimTypes = numel(allSpksMatrix);
    lounessappend = [50 55 60 65 70 75 80 85 90 95 100 105 110];
    freqstxt = stimNames(1,:);
    
    for o = 1:numel(freqstxt)-1
        kchar = 'k';
        
        bla = find(freqstxt{o}==kchar);
        allfreq(o) = str2num(freqstxt{o}(1:bla-1));
    end
        
        
    
    
    conCatAll = [];
    allnames = [];
    cnnt =1;
  
    
nRows = size(stimNames, 1); %Loudness
nCols = size(stimNames, 2); % Freq

hOverFeq =[];
alLDbs = [];
for k = 1:nCols-1 % frequ, last one is silent
    for j = 1:nRows % loudness
        thisSpkResp = allSpksMatrix{j,k};
        nReps = size(thisSpkResp, 2);
        for o = 1:nReps
            
            thisRep = thisSpkResp{1, o};
            
            PreStimSpkCnts(o) = numel(find(thisRep > PreStimStartTime_samp & thisRep <= StimStartTime_samp));
            StimSpkCnts(o) = numel(find(thisRep > StimStartTime_samp & thisRep <= PostStimStartTime_samp));
            PostStimSpkCnts(o) = numel(find(thisRep > PostStimStartTime_samp & thisRep <= EndTime_samp));
            
            
            all_PreStimSpkCnts(cnnt) =  PreStimSpkCnts(o);
            all_StimSpkCnts(cnnt) =   StimSpkCnts(o);
            all_PostStimSpkCnts(cnnt) = PostStimSpkCnts(o);
            
            cnnt = cnnt+1;
        end
        
        [p h] = ranksum(PreStimSpkCnts, StimSpkCnts);
        [pp hh] = ttest(PreStimSpkCnts, StimSpkCnts);
        
        allH(j) = h;
        
    end
    hOverFeq(k,:) = allH;
    alLDbs{k} = lounessappend(allH);
end

cnt = 1;
allDbThresh = [];
thisFreqThresh = [];
for w = 1:size(alLDbs, 2) -1
        
thisDv = alLDbs{w};
thisfreq = allfreq(w);
if ~isempty(thisDv)
    allDbThresh(cnt) = thisDv(1);
    thisFreqThresh(cnt) = thisfreq;
    cnt = cnt+1;
end
end


figure(104);  clf
plot(thisFreqThresh, allDbThresh, 'ko', 'linestyle', '-');
hold on
plot(thisFreqThresh, smooth(allDbThresh), 'r-');
ylim([lounessappend(1) lounessappend(end)])
xlim([allfreq(1) allfreq(end)])
xlabel('Frequency (kHz)')
ylabel('Threshold (dB)')
title([trialNames{s}(1:3)])

   
saveName = [saveDir  trialNames{s}(1:4)  'TuningCurve'];

plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 1, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 1, plotpos);


    
end




end


