function [] = binSpikeTimesAndAnalyze(experiment, recSession, NeuronName)

if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);
dbstop if error



%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'WhiteNoise'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/ForPaper/';
addpath '/home/dlc/Documents/MATLAB/Examples/R2019b/wavelet/TimeFrequencyAnalysisWithTheCWTExample'
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

%%
SamplingRate = C_OBJ.SETTINGS.SampleRate;

binSize_ms = 2;
binSize_samp = round(binSize_ms*SamplingRate/1000);


%%

allSpksMatrix = C_OBJ.S_SPKS.SORT.allSpksMatrix;
epochLength_samps = C_OBJ.S_SPKS.INFO.epochLength_samps;
thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR

%% Concat all responses

nStimTypes = numel(allSpksMatrix);

conCatAll = [];
cnt =1;
for j = 1:nStimTypes
    %for j = 1
    nTheseReps = numel(allSpksMatrix{j});
    for k = 1: nTheseReps
        %    for k = 1: 15
        conCatAll{cnt} = allSpksMatrix{1,j}{1,k};
        cnt = cnt +1;
    end
end

nAllReps = numel(conCatAll);


binnedSeries = 0:binSize_samp:epochLength_samps;



%%
allISIs = [];
for q = 1 : nAllReps
    
    these_spks_on_chan = conCatAll{q};
    these_spks_on_chan_ms = (these_spks_on_chan/SamplingRate)*1000;
    
    ISI_ms = diff(these_spks_on_chan_ms);
    allISIs = [allISIs ISI_ms];
   
    
    p(q,:) = hist(these_spks_on_chan, binnedSeries);
end


if numel(allISIs) >1
    CV = std(allISIs(allISIs<2000)) / mean(allISIs(allISIs<2000));
else
    CV = nan;
end
bins_ms = 0:2:300;
figure(102);clf
histogram(allISIs, bins_ms)
    
%meanP = mean(p, 1);
%bla = kurtosis(meanP);
%bla = entropy(p);

figure (100);clf; 
imagesc(p)
%title(['kurtosis = ' num2str(bla)])
%title(['entropy = ' num2str(bla)])
title(['CV = ' num2str(CV)])
disp('')

% 
% saveName = [FigSaveDir 'WN-AllRasters_WNSpect'];
% 
% plotpos = [0 0 15 20];
% print_in_A4(0, saveName, '-djpeg', 1, plotpos);
% disp('')
% print_in_A4(0, saveName, '-depsc', 1, plotpos);
   

end

