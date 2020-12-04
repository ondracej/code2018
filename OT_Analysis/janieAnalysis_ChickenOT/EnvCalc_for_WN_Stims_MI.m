function [WnCCs] = EnvCalc_for_WN_Stims_MI(experiment, recSession, NeuronName, oo, totalReps, WnCCs)
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
switch gethostname
    
    case 'PLUTO'
        FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/EnvAnalysis-WN/Corrs/';
        addpath '/home/dlc/Documents/MATLAB/Examples/R2019b/wavelet/TimeFrequencyAnalysisWithTheCWTExample'
        SignalDir = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/Signals/'; 
    case 'SALAMANDER'
        
        SignalDir = '/home/janie/Data/OTProject/AllSignals/Signals/';
        addpath '/home/janie/Matlab/MatlabR2019b/examples/wavelet/'
        FigSaveDir = '/home/janie/Data/OTProject/MLD/Figs/EnvAnalysis-WN/Corrs/';
        
end


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


%%
%%
    %%
    
 
    %%
    lf = 100;
    hf = 1000;
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
    
    
    lf = 1000;
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
    
    [yupperL,~] = envelope(thisSigData);
      


%% MI


phi = unwrap(angle(thisSigData_L));
phaseShiftedSignal = real(thisSigData_L.*exp(pi*1i));

figure
plot(smooth(thisSigData_L, smoothWin_samps), 'k')
hold on
plot(smooth(phaseShiftedSignal, smoothWin_samps), 'r')

figure; 
plot(smooth(envelope(thisSigData_L), smoothWin_samps), 'k');
hold on
plot(smooth(envelope(phaseShiftedSignal), smoothWin_samps), 'r');

%%
 
smoothiStim = smooth(thisUniqStimFR, smoothWin_samps);
smoothEnvRaw = smooth(envelope(thisSigData_L), smoothWin_samps);
smoothEnvPhaseShift = smooth(envelope(phaseShiftedSignal), smoothWin_samps);



raw_MI = mutualinfo(yupperL,thisUniqStimFR);
Hi_MI = mutualinfo(filNoise_hi,thisUniqStimFR);
Lo_MI = mutualinfo(filNoise_lo,thisUniqStimFR);

[r_raw, p_raw] = corr(yupperL, thisUniqStimFR'); % spearmann
[r_low, p_low] = corr(filNoise_hi, thisUniqStimFR'); % spearmann
[r_hi, p_hi] = corr(filNoise_lo, thisUniqStimFR'); % spearmann

%%

WnCCs.raw_MI(oo) = raw_MI;
WnCCs.Hi_MI(oo) = Hi_MI;
WnCCs.Lo_MI(oo) = Lo_MI;

WnCCs.raw_MI(oo) = raw_MI;
WnCCs.Hi_MI(oo) = Hi_MI;
WnCCs.Lo_MI(oo) = Lo_MI;

%%
if oo == totalReps
    
    all_raw_MI = WnCCs.raw_MI;
    all_Hi_MI = WnCCs.Hi_MI;
    all_Lo_MI = WnCCs.Lo_MI;
    
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

