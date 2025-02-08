function [] = STA_for_WN_Stims_V3(experiment, recSession, NeuronName)
dbstop if error

%NeuronName = 'N-12';
%Stim = 'WN';
% 
% experiment = 1; %efc
% recSession = 12; %

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);
%%
ALL_LStimWins = [];
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'WhiteNoise'));


audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

switch gethostname
    case 'SALAMANDER'
        SignalDir = '/home/janie/Data/OTProject/AllSignals/Signals/';
        addpath '/home/janie/Matlab/MatlabR2019b/examples/wavelet/'
        FigSaveDir = '/home/janie/Data/OTProject/MLD/Figs/STA-WN/RasterSTA/';
    case 'PLUTO'
        SignalDir = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/Signals/';
        addpath '/home/dlc/Documents/MATLAB/Examples/R2019b/wavelet/'
        FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/STA-WN-Spectrogram/';
        
    case 'NEUROPIXELS'
        SignalDir = 'X:\Janie-OT-MLD\OT-MLD\OT_Project_2021-Final\AllSignals\Signals\';
       % addpath '/home/dlc/Documents/MATLAB/Examples/R2019b/wavelet/'
        %FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/STA-WN-Spectrogram/';
        
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


TimeWindow_ms = 100;
TimeWindow_samp =TimeWindow_ms /1000*SamplingRate;
%%

stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
SpkResponses = C_OBJ.S_SPKS.SORT.allSpksMatrix;

    
    pre = zeros(1, StimStartTime_samp);
    post = zeros(1, StimStartTime_samp);
    
    
    
nRows = size(stimNames, 1);
nCols = size(stimNames, 2);
cnnt = 1;
for j = 1:nRows
    for k = 1:nCols
        
        thisSigName = stimNames{j, k};
        
        [thisSigData,Fs] = audioread([SignalDir thisSigName '.wav']);
        
        thisSigData_L = thisSigData(:, 1);
        
        
        thisStim = [pre  thisSigData_L' post];
        xtimepoints =1:1:size(thisSigData, 1);
        
        thisSpkResp = SpkResponses{j,k};
        
        nReps = numel(thisSpkResp);
        
        cnt = 1;
        
        for o = 1:nReps
            thisRep = thisSpkResp{1, o};
         
            
            validSpksInds = find(thisRep >= StimStartTime_samp & thisRep <= PostStimStartTime_samp); % need to add a buffer at the start
            validSpks = thisRep(validSpksInds);
            
            nValidSpikes = numel(validSpks );
            
            relValidSpks = validSpks ; % relative to the onset of the stim
            
            LStimWins = [];
            RStimWins = [];
            
            for q = 1:nValidSpikes
                
                thisSpk = relValidSpks(q);
                
                roi = thisSpk - TimeWindow_samp : thisSpk;  % for time window before spike
                %roi = thisSpk - TimeWindow_samp : thisSpk + TimeWindow_samp; % for time window before and after spike
                if roi(1) <= 0 || roi(end) >= numel(thisStim)
                    disp('')
                    continue
                else
                    LStimWins(cnt,:) = thisStim(roi);
                    %RStimWins(cnt,:) = thisSigData_R(roi);
                    
                    cnt = cnt +1;
                    
                    ALL_LStimWins(cnnt,:) = thisStim(roi);
                    %ALL_RStimWins(cnnt,:) = thisSigData_R(roi);
                    
                    cnnt = cnnt +1;
                end
            end
            
        end
        allWins_L{j, k} = LStimWins;
        
    end
    
    
    
end
disp('')

%% STA
if size(ALL_LStimWins, 1) > 6 % must have atleast 6 spikes
    
    
    DT = 1/Fs;
    all_cfs = []; all_f = [];
    for j = 1:size(ALL_LStimWins, 1)
        
        thisData = ALL_LStimWins(j,:);
        t = 0:DT:(numel(thisData)*DT)-DT;
        [cfs,f] = cwt(thisData,'bump',1/DT,'VoicesPerOctave',32);
        
        all_cfs{j} = cfs;
        all_f{j} = f;
        
%         figure(105);clf
%         pcolor(t,f,abs(cfs));shading flat
%         pause
        
        %figure
        %helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
    end
    
    allRows = [];
    for k = 1:87
        for j = 1:size(ALL_LStimWins, 1)
       
        allRows(j,:) = all_cfs{1,j}(k,:);
        
        end
        
        %test = abs(allRows);
        
        meanRow(k,:) = mean(allRows, 1);
    end
    
    
    [minf,maxf] = cwtfreqbounds(4411, Fs, 'wavelet', 'bump');
        
          figure(105);clf
        pcolor( t*1e3,f./1e3,abs(cfs));shading flat 
    ylim([.5 8]);
      %pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
    
      nfreqs = 60;
                min_freq = 200;
                max_freq = 8000;
            
                min_scale = 1/max_freq*Fs;
                max_scale = 1/min_freq*Fs;
                wavetype = 'cmor1-1';
                scales = logspace(log10(min_scale),log10(max_scale),nfreqs);
                wfreqs = scal2frq(scales,wavetype,1/Fs);
                
       V_wave = cwt(thisData,scales,wavetype);
    
    
    
    
LStimWins_mean = mean(ALL_LStimWins);
timepoints_samp = 1:1:numel(LStimWins_mean);
timepoints_ms = timepoints_samp/Fs*1000;

STA.allStims = ALL_LStimWins;
STA.meanSTA = LStimWins_mean;

%%
figure (103); clf
subplot(3, 1, 1)
plot(timepoints_ms, LStimWins_mean); axis tight
ylim([-.2 .2])
title([NeuronName ': ' Stim ' STA'])

xticks = 0:2:20;
set(gca, 'xtick', xticks)
xlim([0 20])

line([20 20], [-.2 .2], 'Color' , 'k')
xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0'};
set(gca, 'xticklabel', xtickabs )


%% Wavelet

load batsignal
t = 0:DT:(numel(batsignal)*DT)-DT;
[cfs,f] = cwt(batsignal,'bump',1/DT,'VoicesPerOctave',32);
helperCWTTimeFreqPlot(cfs,t.*1e6,f./1e3,'surf','Bat Echolocation (CWT)',...
    'Microseconds','kHz')
DT = 1/Fs;
t = 0:DT:(numel(RawData)*DT)-DT;
figure
helperCWTTimeFreqPlot(cfs,t.*1e6,f./1e3,'surf','Bat Echolocation (CWT)',...
    'Microseconds','kHz')


[cfs,f] = cwt(RawData,'bump',1/DT,'VoicesPerOctave',32);


RawData = LStimWins_mean;
%pwelch(RawData)
%[pxx,f] = pwelch(RawData,10,8,10,Fs);
%plot(f,10*log10(pxx))
%pmtm(RawData,3,length(RawData),Fs)
%xlim([0 7])

subplot(3, 1, 2)
    %Fs = Fs;                    % Sampling frequency
            T = 1/Fs;                     % Sample time
            L = numel(RawData);
            %Y = fft(squeeze(longLF));
            NFFT = 2^nextpow2(L); % Next power of 2 from length of y
            Y = fft(squeeze(RawData),NFFT)/L;
            f = Fs/2*linspace(0,1,NFFT/2+1);
            
            % Plot single-sided amplitude spectrum.
            
            bla = 2*abs(Y(1:NFFT/2+1));
            %plot(f,2*abs(Y(1:NFFT/2+1)))
            plot(f/1000,smooth(bla))
            xlim([0 7])
title('FFT')
            
bla = envelope(LStimWins_mean);
figure; plot(timepoints_ms, smooth(bla));


[cfs,frq] = cwt(LStimWins_mean,Fs, 'bump');
tms = (0:numel(LStimWins_mean)-1)/Fs;
figure
surface(tms,frq,abs(cfs))
axis tight
shading flat
ylim([100 7500])



figure(103);
subplot(3, 1, 3)
%helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
spec_scale = .001;
specgram1(double(RawData)/spec_scale,NFFT,Fs,40,36);
ylim([0 8000])
[yo,fo,to] = specgram1(double(RawData)/spec_scale,NFFT,Fs,40,36);
% titleTxt = [Stim ' STA - Wavelet'];
% title(titleTxt)

STA.yo = yo;
STA.fo = fo;
STA.to = to;


%xlim([0 20])
%set(gca, 'xtick', xticks)
%set(gca, 'xticklabel', xtickabs )

%
saveName = [FigSaveDir NeuronName '-STA-' Stim];
plotpos = [0 0 10 15];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

%% STA
%{

figure(102); clf




subplot(2, 2,3)
specgram1(double(RawData)/spec_scale,NFFT,Fs,40,36);
set(gca, 'xtick', xticks)
set(gca, 'xticklabel', xtickabs )
ylim([0 8000])

%% Frequency
subplot(2, 2,4)
[yo,fo,to] = specgram1(double(RawData)/spec_scale,NFFT,Fs,40,36);

meanf = mean(abs(yo).^2, 2);
plot(meanf, fo./1e3, 'color', [0.5 0.5 0.5])
ylim([0 8]) 

%medianf = median(abs(cfs).^2, 2);
stdf = std(abs(yo').^2, 1)';
semF = stdf/sqrt(883);

posF = meanf + semF;
negF = meanf - semF;

STA.meanf = meanf;
STA.semF = semF;

plot(posF, f./1e3, 'color', [0.5 0.5 0.5])
hold on
plot(negF, f./1e3, 'color', [0.5 0.5 0.5])
plot(meanf, f./1e3, 'k', 'linewidth', 1)
axis tight

sortedMeanF = sort(meanf);
scaleEstimator=sortedMeanF(round(95/100*numel(sortedMeanF)));

STA.scaleEstimatorF = scaleEstimator;

yss = ylim;
line([scaleEstimator scaleEstimator], [yss(1) yss(2)], 'color', 'r', 'linestyle', ':')

[pks,locs,w,p] = findpeaks(meanf, 'MinPeakHeight',scaleEstimator);

STA.FDetections_kHz = f(locs)./1e3;

ylim([.5 8])
xlabel('Power')

%% Time
subplot(2, 2, 1); 

meant = mean(abs(cfs).^2, 1);
%mediant = median(abs(cfs).^2, 1);
stdt = std(abs(cfs).^2, 1);
semt = stdt/sqrt(261);

posT = meant + semt;
negT = meant - semt;

plot(t*1e3, posT, 'color', [0.5 0.5 0.5])
hold on
plot(t*1e3, negT, 'color', [0.5 0.5 0.5])
plot(t*1e3, meant, 'k', 'linewidth', 2)
axis tight

STA.meant = meant;
STA.semt = semt;

%sortedMtest=sort(Mtest);
%scaleEstimator=sortedMtest(round(percentile4ScaleEstimation/100*numel(sortedMtest)));

sortedMeanT = sort(meant);
scaleEstimator=sortedMeanT(round(95/100*numel(sortedMeanT)));

STA.scaleEstimatorT = scaleEstimator;
xss = xlim;
line([xss(1) xss(2)], [scaleEstimator scaleEstimator] , 'color', 'r', 'linestyle', ':')

[pks,locs,w,p] = findpeaks(meant, 'MinPeakHeight',scaleEstimator);

STA.TDetections_ms = 20-t(locs)*1e3;

ylabel('Power')
set(gca, 'xtick', xticks)
set(gca, 'xticklabel', xtickabs )

%%
plotpos = [0 0 15 10];
print_in_A4(0, [saveName 'timeFreq'], '-depsc', 0, plotpos);

save([saveName 'STA_timeFreq.mat'], 'STA');
%}
end

%%

%%

spec_scale = .1;
figure(104); clf;
specgram1(double(RStimWins_mean)/spec_scale,512*2,Fs,40,36);
ylim([0 5000])

%%

%%
Wavdata = LStimWins_mean;
figH = figure(104);clf
clims = [0 .5];
%saveName = [PlotDir obj.Plotting.saveTxt '_SWR_wavelet_mean'];


    thisSegData_wav = Wavdata;
    
                [thisSegData_wav,nshifts] = shiftdim(thisSegData_wav',-1);
                
                dsf = 20;
                Fsd = Fs/dsf;
                hcf = 8000;
                [n_ch,n_tr,N] = size(thisSegData_wav);
                
                [bb,aa] = butter(2,hcf/(Fs/2),'low');
                V_ds = reshape(permute(thisSegData_wav,[3 1 2]),[],n_ch*n_tr);
                V_ds = downsample(filtfilt(bb,aa,V_ds),dsf);
                V_ds = reshape(V_ds,[],n_ch,n_tr);
                V_ds  = V_ds;
                
                %
                [N,n_chs,n_trials] = size(V_ds);
                nfreqs = 60;
                min_freq = 1.5;
                max_freq = 8000;
                Fsd = Fs/dsf;
                Fsd = Fs;
                min_scale = 1/max_freq*Fsd;
                max_scale = 1/min_freq*Fsd;
                wavetype = 'cmor1-1';
                scales = logspace(log10(min_scale),log10(max_scale),nfreqs);
                wfreqs = scal2frq(scales,wavetype,1/Fsd);
                
                use_ch = 1;
                cur_V = squeeze(V_ds(:,use_ch,:));
                V_wave = cwt(cur_V(:),scales,wavetype);
                V_wave = reshape(V_wave,nfreqs,[],n_trials);
                
                tr = 1;
    ax3 = subplot(3,1,3);
                pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
%% Mean PLot


%                 ax1 = subplot(3,1,1);
%                 plot(sD.SWR.timestamps_ms,RawData, 'k');
%                 axis tight
%                 xlim([-300 300])
%                 title( ['SWR-Wavelet: ' obj.Plotting.titleTxt])
%
%                 ax2 = subplot(3,1,2);
%                 plot(sD.SWR.timestamps_ms,Wavdata, 'k');
%                 axis tight
%                 xlim([-300 300])
%
%                 %bla= 22:0.04:22.50;
%                 %set(gca, 'xtick', bla)
%
%                 ax3 = subplot(3,1,3);
tr =1;
figure
  V_wave = cwt(cur_V(:),scales,wavetype);
pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
%set(gca,'yscale','log');
axis tight
ylim([0 800])
%caxis(clims);
caxis(clims);
xlim([0.7 1.3])

xlabel('Time [ms]')
ylabel('Frequency [Hz]')
%%

%}


end
