function [WnCCs] = EnvCalc_for_WN_Stims_V2(experiment, recSession, NeuronName, oo, totalReps, WnCCs)
dbstop if error
if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'WhiteNoise'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);


%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/EnvAnalysis-WN/Corrs/';
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

SignalDir = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/Signals/';

sigFormat = '*.wav';


sigNames = dir(fullfile(SignalDir,sigFormat));
%imageNames(1) = [];
%imageNames(1) = [];
sigNames = {sigNames.name}';

nSigs = numel(sigNames);

%% Settings

SamplingRate = C_OBJ.SETTINGS.SampleRate;
PreStimStartTime_s = 0; % 0-100  ms
StimStartTime_s = 0.1; % 100  - 200 ms
PostStimStartTime_s = 0.2; % 200 - 300 ms

PreStimStartTime_samp = PreStimStartTime_s* SamplingRate;
StimStartTime_samp = StimStartTime_s* SamplingRate;
PostStimStartTime_samp = PostStimStartTime_s* SamplingRate;

%%

stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
SpkResponses = C_OBJ.S_SPKS.SORT.allSpksMatrix;

nRows = size(stimNames, 1);
nCols = size(stimNames, 2);

smoothWin_ms = 1;

cnnt = 1;

figure(406); clf
thisUniqStimFR  = zeros(1,StimStartTime_samp); % we define a vector for integrated FR
for j = 1:nRows
    for k = 1:nCols
        
        thisSigName = stimNames{j, k};
        
        [thisSigData,Fs] = audioread([SignalDir thisSigName '.wav']); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
        
        cutSigData = thisSigData(1: StimStartTime_samp,:);
        
        smoothWin_samps = round(smoothWin_ms/1000*Fs);
        
        thisSigData_L = cutSigData(:, 1);
        [yupperL,~] = envelope(thisSigData_L);
        smooth_yupperL = smooth(yupperL, smoothWin_samps);
        
        %%
        
        thisSpkResp = SpkResponses{j,k};
        
        nReps = numel(thisSpkResp);
        
        
        
        %allSpksFR = zeros(StimStartTime_samp,1);
        
        for ss = 1:nReps
            
            these_spks_on_Chan = thisSpkResp{ss};
            
            validSpksInds = find(these_spks_on_Chan >= StimStartTime_samp & these_spks_on_Chan <= PostStimStartTime_samp); % need to add a buffer at the start
            validSpks = these_spks_on_Chan(validSpksInds);
            
            relValidSpks = validSpks - StimStartTime_samp; % relative to the onset of the stim
            
            nbr_spks = size(relValidSpks, 2);
            
            % add a 1 to the FR vector for every spike
            for ind = 1 : nbr_spks
                
                if relValidSpks(ind) == 0
                    continue
                else
                    
                    thisUniqStimFR(relValidSpks(ind)) = thisUniqStimFR(relValidSpks(ind)) +1;
                    % allSpksFR(relValidSpks(ind)) = allSpksFR(relValidSpks(ind)) +1;
                end
            end
            
        end
        
        
    end
    
end
smooth_thisUniqStimFR = smooth(thisUniqStimFR, smoothWin_samps);

[r_L, p_L] = corrcoef(smooth_yupperL, smooth_thisUniqStimFR);
[r_L, p_L] = corr(smooth_yupperL, smooth_thisUniqStimFR); % spearmann
xtimepoints =1:1:size(cutSigData, 1);
xtimepoints_ms = xtimepoints/Fs*1000;

%WnCCs.allRs(oo) = r_L(1, 2);
%WnCCs.allps(oo) = p_L(1, 2);

WnCCs.allRs(oo) = r_L;
WnCCs.allps(oo) = p_L;

%%
%titletext = [NeuronName ' CC = ' num2str(r_L(1, 2)) ' p= ' num2str(p_L(1, 2))];
titletext = [NeuronName ' CC = ' num2str(r_L) ' p= ' num2str(p_L)];
figure (103);  clf
subplot(2, 1, 2)
plot(xtimepoints_ms, smooth_thisUniqStimFR, 'k')
axis tight
ylim([0 4])
title(titletext)
subplot(2, 1, 1)
plot(xtimepoints_ms, smooth_yupperL, 'k')
axis tight
ylim([0 .4])

saveName = [FigSaveDir NeuronName '-EnvAnalysis-Corr' Stim];
plotpos = [0 0 15 12];

%print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

if oo == totalReps
    Allps = WnCCs.allps;
    AllRs = WnCCs.allRs;
    
    sigPs = find(Allps <0.05);
    sigRs = AllRs(sigPs);
    
    negR = find(sigRs <0);
    posR = find(sigRs >0);
    
    WnCCs.sigPs  = sigPs;
    WnCCs.sigRs  = sigRs;
    
    jitterAmount = 0.1;
    jitterValuesX = 2*(rand(size(sigRs))-0.5)*jitterAmount;   % +
    
    cols = cell2mat({[0 0 0]; [.5 .5 .5]});
    %cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
    figure(102); clf
    h = scatterhist(sigRs, jitterValuesX, 'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', cols);
    
    boxplot(h(2),sigRs,'orientation','horizontal',...
        'label',{''},'color', 'k', 'plotstyle', 'compact', 'Whisker', 10);
    
    axis(h(1),'auto');  % Sync axes
    
    
    yss = ylim;
    
    hold on
    line([0 0], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    
    saveName = [FigSaveDir '-EnvAnalysis-CorrAll' Stim];
    plotpos = [0 0 10 8];
    
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    WNSavename = [FigSaveDir 'WN-CCS.mat'];
    save(WNSavename, 'WnCCs')
    
end


end

