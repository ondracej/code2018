function [] = STA_for_HRTF_Stims_FreqTime_V2(experiment, recSession, NeuronName)
dbstop if error

if nargin < 3
    
    NeuronName = 'N-28';
    experiment = 10; %efc
    recSession = 1; %sFigSaveNamec
    
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'HRTF'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!



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

switch gethostname
    case 'SALAMANDER'
        SignalDir = '/home/janie/Data/OTProject/AllSignals/Signals/';
        addpath '/home/janie/Matlab/MatlabR2019b/examples/wavelet/TimeFrequencyAnalysisWithTheCWTExample'
        FigSaveDir = '/home/janie/Data/OTProject/MLD/Figs/STA-HRTF/FreqTime/';
    case 'PLUTO'
        SignalDir = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/Signals/';
        addpath '/home/dlc/Documents/MATLAB/Examples/R2019b/wavelet/TimeFrequencyAnalysisWithTheCWTExample'
        FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/STA-HRTF/FreqTime/';
end

sigFormat = '*.wav';


sigNames = dir(fullfile(SignalDir,sigFormat));
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


pre = zeros(1, StimStartTime_samp);
post = zeros(1, StimStartTime_samp);


TimeWindow_ms = 20;
TimeWindow_samp =TimeWindow_ms /1000*SamplingRate;

%%

stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
SpkResponses = C_OBJ.S_SPKS.SORT.allSpksMatrix;

nRows = size(stimNames, 1);
nCols = size(stimNames, 2);
cnnt = 1;
ALL_LStimWins = [];
ALL_RStimWins = [];

smoothWin_ms = 1;
smoothWin_samps = round(smoothWin_ms/1000*SamplingRate);

%%
knt = 1;
allLStims = [];
allRStims = [];
for j = 1:nRows
    for k = 1:nCols
        
        thisSigName = stimNames{j, k};
        
        [thisSigData,Fs] = audioread([SignalDir thisSigName '.wav']);
        
        thisSigData_L = thisSigData(:, 1);
        thisSigData_R = thisSigData(:, 2);
        
        %         thisSigData_L_smooth = smooth(thisSigData_L, smoothWin_samps);
        %         thisSigData_R_smooth = smooth(thisSigData_R, smoothWin_samps);
        
        AllStimsL{j, k} = thisSigData_L;
        AllStimsR{j, k} = thisSigData_R;
        
        allLStims(knt,:) = thisSigData_L;
        allRStims(knt,:) = thisSigData_R;
        
        knt = knt+1;
    end
end


%%

maxL= max(max(allLStims));
minL= min(min(allLStims));

maxR= max(max(allRStims));
minR = min(min(allRStims));

cnt = 1;
AllnormL= [];
AllnormR = [];
allNormsL = [];
allNormsR = [];

for j = 1:nRows
    for k = 1:nCols
        
        thisSigName = stimNames{j, k};
        
        thisSigData_L = AllStimsL{j, k};
        thisSigData_R = AllStimsR{j, k};
        
        normL = (thisSigData_L - minL) / (maxL - minL);
        normR = (thisSigData_R - minR) / (maxR - minR);
        
        AllnormL{j, k} = normL;
        AllnormR{j, k} = normR;
        
        allNormsL(cnt,:) =  normL;
        allNormsR(cnt,:) =  normR;
        
        cnt =cnt +1;
        
    end
end

for j = 1:nRows
    for k = 1:nCols
        
        thisSigData_L_norm = AllnormL{j, k};
        thisSigData_R_norm = AllnormR{j, k};
        
        %figure; plot(thisSigData_L_norm); hold on; plot(thisSigData_R_norm);
        
        thisSigData_L_norm_meanSub = thisSigData_L_norm - mean(thisSigData_L_norm); % here we mean-sbitrack to get rid of offset
        thisSigData_R_norm_meanSub = thisSigData_R_norm - mean(thisSigData_R_norm);
        
        thisStimL  = [pre thisSigData_L_norm_meanSub' post];
        thisStimR  = [pre thisSigData_R_norm_meanSub' post];
        
        %figure; plot(thisSigData_L_norm_meanSub); hold on; plot(thisSigData_R_norm_meanSub);
        %%
        [yupperL,~] = envelope(thisStimL);
        [yupperR,~] = envelope(thisStimR);
        
        %figure; plot(yupperL); hold on; plot(yupperR);
        
        xtimepoints =1:1:size(yupperL, 1);
        xtimepoints_s = xtimepoints/Fs;
        
        thisSpkResp = SpkResponses{j,k};
        
        nReps = numel(thisSpkResp);
        
        cnt = 1;
        
        for o = 1:nReps
            thisRep = thisSpkResp{1, o};
            validSpksInds = find(thisRep >= StimStartTime_samp & thisRep <= PostStimStartTime_samp); % need to add a buffer at the start
            validSpks = thisRep(validSpksInds);
            
            nValidSpikes = numel(validSpks );
            
            relValidSpks = validSpks; % relative to the onset of the stim
            
            LStimWins = [];
            RStimWins = [];
            
            for q = 1:nValidSpikes
                
                thisSpk = relValidSpks(q);
                
                roi = thisSpk - TimeWindow_samp : thisSpk; % for time window before spike
                %roi = thisSpk - TimeWindow_samp : thisSpk + TimeWindow_samp; % for time window before and after spike
                if roi(1) <= 0 || roi(end) >= numel(thisStimL)
                    disp('')
                    continue
                else
                    
                    LStimWins(cnt,:) = thisStimL(roi);
                    RStimWins(cnt,:) = thisStimR(roi);
                    
                    LStimWins_Env(cnt,:) = yupperL(roi);
                    RStimWins_Env(cnt,:) = yupperR(roi);
                    
                    cnt = cnt +1;
                    
                    ALL_LStimWins(cnnt,:) = thisStimL(roi);
                    ALL_RStimWins(cnnt,:) = thisStimR(roi);
                    
                    All_LStimWins_Env(cnnt,:) = yupperL(roi);
                    All_RStimWins_Env(cnnt,:) = yupperR(roi);
                    
                    cnnt = cnnt +1;
                end
            end
        end
        
    end
    
end
disp('')

%dB = 20 * log10(amplitude)

if size(ALL_LStimWins, 1) > 2 % must have atleast 20 spikes
    
    %% Envs
    
    %% Raw data
    
    LStimWins_mean = mean(ALL_LStimWins, 1); % this is
    RStimWins_mean = mean(ALL_RStimWins, 1);
    timepoints_samp = 1:1:numel(LStimWins_mean);
    timepoints_ms = timepoints_samp/Fs*1000;
    
    STA.ALL_LStimWins = ALL_LStimWins;
    STA.ALL_RStimWins = ALL_RStimWins;
    
    STA.LStimWins_mean = LStimWins_mean;
    STA.RStimWins_mean = RStimWins_mean;
 
    STA.All_LStimWins_Env = All_LStimWins_Env;
    STA.All_RStimWins_Env = All_RStimWins_Env;
    
    LStimWins_meanEnv = mean(All_LStimWins_Env, 1);
    RStimWins_meanEnv = mean(All_RStimWins_Env, 1);
    
    STA.meanAll_LStimWins_Env = LStimWins_meanEnv;
    STA.meanAll_RStimWins_Env = RStimWins_meanEnv;
    
    xticks = 0:2:20;
    set(gca, 'xtick', xticks)
    xlim([-0 20])
    xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0'};
    set(gca, 'xticklabel', xtickabs )
 
    
    %% Wavelet
 
    Dt = 1/44100;
    t = 0:Dt:(numel(LStimWins_mean)*Dt)-Dt;
    
    [cfs,f] = cwt(LStimWins_mean,'bump',1/Dt,'VoicesPerOctave',48);
    figure(103); clf
    subplot(2, 4, 5)
    helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
    ylim([.5 6])
    %title(titleTxt)
    
    colorbar 'off'
    xlim([0 20])
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xtickabs )
    
    css = get(gca, 'clim');
    caxis(css);
    
    %% Frequency LAll_RStimWins_Env
    
    meanf = mean(abs(cfs).^2, 2);
    stdf = std(abs(cfs').^2, 1)';
    semF = stdf/sqrt(883);
    
    posF = meanf + semF;
    negF = meanf - semF;
    
    STA.Lmeanf = meanf;
    STA.LsemF = semF;
    
    subplot(2, 4, 6)
    
    plot(posF, f./1e3, 'color', [0.5 0.5 0.5])
    hold on
    plot(negF, f./1e3, 'color', [0.5 0.5 0.5])
    plot(meanf, f./1e3, 'k', 'linewidth', 1)
    axis tight
    
    sortedMeanF = sort(meanf);
    scaleEstimator=sortedMeanF(round(95/100*numel(sortedMeanF)));
    
    STA.LscaleEstimatorF = scaleEstimator;
    
    yss = ylim;
    line([scaleEstimator scaleEstimator], [yss(1) yss(2)], 'color', 'r', 'linestyle', ':')
    
    [pks,locs,w,p] = findpeaks(meanf, 'MinPeakHeight',scaleEstimator);
    
    STA.L_FDetections_kHz = f(locs)./1e3;
    
    ylim([.5 6])
    xlabel('Power')
    
    %% Time
    subplot(2, 4, 1);
    
    meant = mean(abs(cfs).^2, 1);
    stdt = std(abs(cfs).^2, 1);
    semt = stdt/sqrt(261);
    
    posT = meant + semt;
    negT = meant - semt;
    
    plot(t*1e3, posT, 'color', [0.5 0.5 0.5])
    hold on
    plot(t*1e3, negT, 'color', [0.5 0.5 0.5])
    plot(t*1e3, meant, 'k', 'linewidth', 1)
    axis tight
    
    STA.Lmeant = meant;
    STA.Lsemt = semt;
    
    sortedMeanT = sort(meant);
    scaleEstimator=sortedMeanT(round(95/100*numel(sortedMeanT)));
    
    STA.LscaleEstimatorT = scaleEstimator;
    
    [pks,locs,w,p] = findpeaks(meant, 'MinPeakHeight',scaleEstimator);
    
    STA.L_TDetections_ms = t(locs)*1e3;
    
    xss = xlim;
    line([xss(1) xss(2)], [scaleEstimator scaleEstimator] , 'color', 'r', 'linestyle', ':')
    
    ylabel('Power')
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xtickabs )
    
    %% Right Wavelet
    subplot(2, 4, 7);
    [cfs,f] = cwt(RStimWins_mean,'bump',1/Dt,'VoicesPerOctave',48);
    
    helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
    colorbar 'off'
    ylim([.5 6])
    caxis(css);
    
    meanf = mean(abs(cfs).^2, 2);
    %medianf = median(abs(cfs).^2, 2);
    stdf = std(abs(cfs').^2, 1)';
    semF = stdf/sqrt(883);
    
    posF = meanf + semF;
    negF = meanf - semF;
    
    STA.Rmeanf = meanf;
    STA.RsemF = semF;
    
    subplot(2, 4,8)
    plot(posF, f./1e3, 'color', [0.5 0.5 0.5])
    hold on
    plot(negF, f./1e3, 'color', [0.5 0.5 0.5])
    plot(meanf, f./1e3, 'k', 'linewidth', 1)
    axis tight
    
    sortedMeanF = sort(meanf);
    scaleEstimator=sortedMeanF(round(95/100*numel(sortedMeanF)));
    
    STA.RscaleEstimatorF = scaleEstimator;
    
    yss = ylim;
    line([scaleEstimator scaleEstimator], [yss(1) yss(2)], 'color', 'r', 'linestyle', ':')
    
    [pks,locs,w,p] = findpeaks(meanf, 'MinPeakHeight',scaleEstimator);
    
    STA.R_FDetections_kHz = f(locs)./1e3;
    
    ylim([.5 6])
    xlabel('Power')
    
    %% Time
    subplot(2, 4, 3);
    
    meant = mean(abs(cfs).^2, 1);
    %mediant = median(abs(cfs).^2, 1);
    stdt = std(abs(cfs).^2, 1);
    semt = stdt/sqrt(261);
    
    posT = meant + semt;
    negT = meant - semt;
    
    plot(t*1e3, posT, 'color', [0.5 0.5 0.5])
    hold on
    plot(t*1e3, negT, 'color', [0.5 0.5 0.5])
    plot(t*1e3, meant, 'k', 'linewidth', 1)
    axis tight
    
    STA.Rmeant = meant;
    STA.Rsemt = semt;
    
    %sortedMtest=sort(Mtest);
    %scaleEstimator=sortedMtest(round(percentile4ScaleEstimation/100*numel(sortedMtest)));
    
    sortedMeanT = sort(meant);
    scaleEstimator=sortedMeanT(round(95/100*numel(sortedMeanT)));
    
    STA.RscaleEstimatorT = scaleEstimator;
    
    [pks,locs,w,p] = findpeaks(meant, 'MinPeakHeight',scaleEstimator);
    
    STA.R_TDetections_ms = t(locs)*1e3;
    
    xss = xlim;
    line([xss(1) xss(2)], [scaleEstimator scaleEstimator] , 'color', 'r', 'linestyle', ':')
    
    ylabel('Power')
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xtickabs )
    
    %%
    figure(103)
    saveName = [FigSaveDir NeuronName '-STA-HRTF' Stim];
    plotpos = [0 0 25 12];
    
    %print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    
    %% Diff Calculation
    
    TDiff_RL_F =   STA.Rmeanf - STA.Lmeanf;
    
    TDiff_RL_T =   STA.Rmeant - STA.Lmeant;
    
    %%
    figure (242);clf;
    subplot(1, 2, 1)
    plot(TDiff_RL_F, f./1e3, 'k', 'linewidth', 1)
    hold on
    sortedMeanF = sort(TDiff_RL_F);
    scaleEstimator=sortedMeanF(round(95/100*numel(sortedMeanF)));
    
    STA.diffscaleEstimatorF = scaleEstimator;
    
    [pks,locs,w,p] = findpeaks(TDiff_RL_F, 'MinPeakHeight',scaleEstimator);
    
    STA.diff_FDetections_kHz = f(locs)./1e3;
    yss = ylim;
    line([scaleEstimator scaleEstimator], [yss(1) yss(2)], 'color', 'r', 'linestyle', ':')
    ylim([.5 6])
    
    %%
    subplot(1, 2, 2)
      plot(t*1e3, TDiff_RL_T, 'k', 'linewidth', 1)
    
       sortedMeanT = sort(TDiff_RL_T);
    scaleEstimator=sortedMeanT(round(95/100*numel(sortedMeanT)));
    
    STA.diffscaleEstimatorT = scaleEstimator;
    
    [pks,locs,w,p] = findpeaks(meant, 'MinPeakHeight',scaleEstimator);
    
    STA.diff_TDetections_ms = t(locs)*1e3;
    
    xss = xlim;
    line([xss(1) xss(2)], [scaleEstimator scaleEstimator] , 'color', 'r', 'linestyle', ':')
    
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xtickabs )
      
    %%
     saveName = [FigSaveDir NeuronName '-STA-HRTF-Diff' Stim];
    plotpos = [0 0 12 5];
    
    %print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    
    %%
  
    saveName = [FigSaveDir NeuronName '-STA-Data' Stim '.mat'];
    
    save(saveName, 'STA', '-v7.3')
end

%%

end

