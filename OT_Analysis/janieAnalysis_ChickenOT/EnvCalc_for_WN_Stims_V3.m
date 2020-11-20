function [WnCCs] = EnvCalc_for_WN_Stims_V3(experiment, recSession, NeuronName, oo, totalReps, WnCCs)
dbstop if error
if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
end

doBigPlot = 0;
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
        doBigPlotsmooth_yupperL = smooth(yupperL, smoothWin_samps);
        
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


%%
%%
if doBigPlot == 1
    thisSigDataToUse = thisSigData;
    
    figure(105); clf
    subplot(3, 2, 1)
    
    xtimepoints =1:1:size(thisSigDataToUse, 1);
    xtimepoints_ms = xtimepoints/Fs*1000;
    
    subplot(3, 2, 1)
    plot(xtimepoints_ms, thisSigDataToUse, 'k')
    axis tight
    title('Raw WN')
    
    
    T = 1/Fs;                     % Sample time
    L = numel(thisSigDataToUse);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(squeeze(thisSigDataToUse),NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    
    % Plot single-sided amplitude spectrum.
    subplot(3, 2, 2)
    plot(f/1000,2*abs(Y(1:NFFT/2+1)))
    hold on
    smoothY = smooth(2*abs(Y(1:NFFT/2+1)));
    plot(f/1000,smoothY, 'k')
    
    xlim([0 7.5])
    title('FFT WN')
    xlabel('Frequency (kHz)')
    
    
    [yupperL,~] = envelope(thisSigDataToUse);
    smooth_yupperL = smooth(yupperL, smoothWin_samps);
    
    subplot(3, 2, [3 4])
    plot(xtimepoints_ms, yupperL)
    axis tight
    title('WN envelope')
    hold on
    plot(xtimepoints_ms, smooth_yupperL, 'k')
    
    %
    
    RawData = yupperL;
    
    Dt = 1/44100;
    t = 0:Dt:(numel(RawData)*Dt)-Dt;
    
    [cfs,f] = cwt(RawData,'bump',1/Dt,'VoicesPerOctave',48);
    subplot(3, 2, 5)
    helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
    ylim([.5 8])
    %title(titleTxt)
    colorbar('off')
    
    %
    meanf = mean(abs(cfs).^2, 2);
    %medianf = median(abs(cfs).^2, 2);
    stdf = std(abs(cfs').^2, 1)';
    semF = stdf/sqrt(883);
    
    posF = meanf + semF;
    negF = meanf - semF;
    subplot(3, 2, 6)
    plot(posF, f./1e3, 'color', [0.5 0.5 0.5])
    hold on
    plot(negF, f./1e3, 'color', [0.5 0.5 0.5])
    plot(meanf, f./1e3, 'k', 'linewidth', 1)
    axis tight
    ylim([.5 7.5])
    title('Freq. in WN Envelope')
    
    
    %%
    saveName = [FigSaveDir NeuronName 'Wn-SpectralEnvContent'];
    plotpos = [0 0 10 9];
    
    %print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    %print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
end   
    %%
    
 
    %%
    lf = 100;
    hf = 3000;
    stimDur_s = 0.1;
    
    nf = Fs / 2; % nyquist frequency
    
    n = round(Fs * stimDur_s);  % number of samples
    nh = n / 2;  % half number of samples
    
    % =========================================================================
    % set variables for filter
    lp = lf * stimDur_s; % ls point in frequency domain
    hp = hf * stimDur_s; % hf point in frequency domain
    
    % design filter
    a = ['BANDPASS'];
    filter = zeros(1, n);           % initializaiton by 0
    filter(1, lp : hp) = 1;         % filter design in real number
    filter(1, n - hp : n - lp) = 1; % filter design in imaginary number
    
    % =========================================================================
    % make noise
    %rand('state',sum(100 * clock));  % initialize random seed
    %rng('default')
    %rng(1) % for consistency?
    %noise = randn(1, n);             % Gausian noise
    %noise = noise / max(abs(noise)); % -1 to 1 normalization
    
    % do filter
    filNoise = fft(yupperL');                  % FFT
    filNoise = filNoise .* filter;                 % filtering
    filNoise = ifft(filNoise);                     % inverse FFT
    filNoise_lo = real(filNoise)';
    
    %%
    
    
    lf = 3000;
    hf = 8000;
    stimDur_s = 0.1;
    
    nf = Fs / 2; % nyquist frequency
    
    n = round(Fs * stimDur_s);  % number of samples
    nh = n / 2;  % half number of samples
    
    % =========================================================================
    % set variables for filter
    lp = lf * stimDur_s; % ls point in frequency domain
    hp = hf * stimDur_s; % hf point in frequency domain
    
    % design filter
    a = ['BANDPASS'];
    filter = zeros(1, n);           % initializaiton by 0
    filter(1, lp : hp) = 1;         % filter design in real number
    filter(1, n - hp : n - lp) = 1; % filter design in imaginary number
    
    % =========================================================================
    % make noise
    %rand('state',sum(100 * clock));  % initialize random seed
    %rng('default')
    %rng(1) % for consistency?
    %noise = randn(1, n);             % Gausian noise
    %noise = noise / max(abs(noise)); % -1 to 1 normalization
    
    % do filter
    filNoise = fft(yupperL');                  % FFT
    filNoise = filNoise .* filter;                 % filtering
    filNoise = ifft(filNoise);                     % inverse FFT
    filNoise_hi = real(filNoise)';
    
    %%
    
    if doBigPlot
    figure(107); clf
    subplot(4, 2, 1)
    
    xtimepoints =1:1:size(filNoise_lo, 1);
    xtimepoints_ms = xtimepoints/Fs*1000;
    
    subplot(4, 2, 1)
    plot(xtimepoints_ms, filNoise_lo, 'k')
    axis tight
    ylim([-.3 .3])
    title('Low Freq. WN Envelope')
    
    
    T = 1/Fs;                     % Sample time
    L = numel(filNoise_lo);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(squeeze(filNoise_lo),NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    
    % Plot single-sided amplitude spectrum.
    subplot(4, 2, 2)
    plot(f/1000,2*abs(Y(1:NFFT/2+1)))
    hold on
    smoothY = smooth(2*abs(Y(1:NFFT/2+1)));
    plot(f/1000,smoothY, 'k')
    
    xlim([0 7.5])
    title('FFT Low Freq Envelope')
    xlabel('Frequency (kHz)')
    
    %%
    subplot(4, 2, 1)
    
    xtimepoints =1:1:size(filNoise_hi, 1);
    xtimepoints_ms = xtimepoints/Fs*1000;
    
    subplot(4, 2, 3)
    plot(xtimepoints_ms, filNoise_hi, 'k')
    axis tight
    title('High WN Envelope')
    ylim([-.3 .3])
    
    T = 1/Fs;                     % Sample time
    L = numel(filNoise_hi);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(squeeze(filNoise_hi),NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    
    % Plot single-sided amplitude spectrum.
    subplot(4, 2, 4)
    plot(f/1000,2*abs(Y(1:NFFT/2+1)))
    hold on
    smoothY = smooth(2*abs(Y(1:NFFT/2+1)));
    plot(f/1000,smoothY, 'k')
    
    xlim([0 7.5])
    title('FFT High Freq Envelope')
    xlabel('Frequency (kHz)')
    
    
    %%
    
    
    Dt = 1/44100;
    t = 0:Dt:(numel(filNoise_lo)*Dt)-Dt;
    
    [cfs,f] = cwt(filNoise_lo,'bump',1/Dt,'VoicesPerOctave',48);
    subplot(4, 2, 5)
    helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
    ylim([.5 8])
    %title(titleTxt)
    colorbar('off')
    
    %
    meanf = mean(abs(cfs).^2, 2);
    %medianf = median(abs(cfs).^2, 2);
    stdf = std(abs(cfs').^2, 1)';
    semF = stdf/sqrt(373);
    
    posF = meanf + semF;
    negF = meanf - semF;
    subplot(4, 2, 6)
    plot(posF, f./1e3, 'color', [0.5 0.5 0.5])
    hold on
    plot(negF, f./1e3, 'color', [0.5 0.5 0.5])
    plot(meanf, f./1e3, 'k', 'linewidth', 1)
    axis tight
    ylim([.5 7.5])
    title('Freq. in Lo WN Envelope')
    
    %%
    
    
    
    Dt = 1/44100;
    t = 0:Dt:(numel(filNoise_hi)*Dt)-Dt;
    
    [cfs,f] = cwt(filNoise_hi,'bump',1/Dt,'VoicesPerOctave',48);
    subplot(4, 2, 7)
    helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
    ylim([.5 8])
    %title(titleTxt)
    colorbar('off')
    
    %
    meanf = mean(abs(cfs).^2, 2);
    %medianf = median(abs(cfs).^2, 2);
    stdf = std(abs(cfs').^2, 1)';
    semF = stdf/sqrt(373);
    
    posF = meanf + semF;
    negF = meanf - semF;
    subplot(4, 2, 8)
    plot(posF, f./1e3, 'color', [0.5 0.5 0.5])
    hold on
    plot(negF, f./1e3, 'color', [0.5 0.5 0.5])
    plot(meanf, f./1e3, 'k', 'linewidth', 1)
    axis tight
    ylim([.5 7.5])
    title('Freq. in Hi WN Envelope')
    
    %%
    
    saveName = [FigSaveDir NeuronName 'Wn-FilterEnvContent'];
    plotpos = [0 0 20 18];
    
    print_in_A4(0, saveName, '-djpeg', 1, plotpos);
    print_in_A4(0, saveName, '-depsc', 1, plotpos);
end



%%
smoothWin_samps = smoothWin_samps*2;

  [yupperL,~] = envelope(thisSigData);
  smooth_yupperL = smooth(yupperL, smoothWin_samps);
      
smooth_thisUniqStimFR = smooth(thisUniqStimFR, smoothWin_samps);

hiFreqEnvSmooth = smooth(filNoise_hi, smoothWin_samps);
lowFreqEnvSmooth = smooth(filNoise_lo, smoothWin_samps);

%%

[r_L, p_L] = corr(smooth_yupperL, smooth_thisUniqStimFR); % spearmann
[rlo_L, plo_L] = corr(lowFreqEnvSmooth, smooth_thisUniqStimFR); % spearmann
[rhi_L, phi_L] = corr(hiFreqEnvSmooth, smooth_thisUniqStimFR); % spearmann

% [r_L, p_L] = corr(yupperL, smooth_thisUniqStimFR); % spearmann
% [rlo_L, plo_L] = corr(filNoise_lo, smooth_thisUniqStimFR); % spearmann
% [rhi_L, phi_L] = corr(filNoise_hi, smooth_thisUniqStimFR); % spearmann

%%


xtimepoints =1:1:size(cutSigData, 1);
xtimepoints_ms = xtimepoints/Fs*1000;

%WnCCs.allRs(oo) = r_L(1, 2);
%WnCCs.allps(oo) = p_L(1, 2);

WnCCs.allRs(oo) = r_L;
WnCCs.allps(oo) = p_L;

%%
%titletext = [NeuronName ' CC = ' num2str(r_L(1, 2)) ' p= ' num2str(p_L(1, 2))];
 xtimepoints =1:1:size(smooth_thisUniqStimFR, 1);
    xtimepoints_ms = xtimepoints/Fs*1000;
    
figure (104);  clf
subplot(4, 1, 1)
plot(xtimepoints_ms, thisUniqStimFR)
hold on
plot(xtimepoints_ms, smooth_thisUniqStimFR, 'k')
axis tight
%ylim([0 4])
%title(titletext)

subplot(4, 1, 2)
plot(xtimepoints_ms, yupperL)
hold on
plot(xtimepoints_ms, smooth_yupperL, 'k')
titletext = [NeuronName ' Raw CC = ' num2str(r_L) ' p= ' num2str(p_L)];
axis tight
title(titletext)
ylim([0 .65])


subplot(4, 1, 3)
plot(xtimepoints_ms, filNoise_lo)
hold on
plot(xtimepoints_ms, lowFreqEnvSmooth, 'k')

titletext = [NeuronName ' Low CC = ' num2str(rlo_L) ' p= ' num2str(plo_L)];
axis tight
title(titletext)
ylim([-.3 .3])

subplot(4, 1, 4)
plot(xtimepoints_ms, filNoise_hi)
hold on
plot(xtimepoints_ms, hiFreqEnvSmooth, 'k')
titletext = [NeuronName ' High CC = ' num2str(rhi_L) ' p= ' num2str(phi_L)];
axis tight
title(titletext)
ylim([-.3 .3])

%%

saveName = [FigSaveDir NeuronName '-EnvAnalysis-Corr_LoHi' Stim];
plotpos = [0 0 15 12];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
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

