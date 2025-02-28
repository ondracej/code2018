function [] = STA_for_HRTF_Stims(experiment, recSession, NeuronName)
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

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/STA-HRTF/MLD-STA-New/';
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
        
        %figure; plot(thisSigData_L_norm_meanSub); hold on; plot(thisSigData_R_norm_meanSub);
        %%
        [yupperL,~] = envelope(thisSigData_L_norm_meanSub);
        [yupperR,~] = envelope(thisSigData_R_norm_meanSub);
        
        %figure; plot(yupperL); hold on; plot(yupperR);
        
        xtimepoints =1:1:size(yupperL, 1);
        xtimepoints_s = xtimepoints/Fs;
        
        thisSpkResp = SpkResponses{j,k};
        
        nReps = numel(thisSpkResp);
        
        cnt = 1;
        
        for o = 1:nReps
            thisRep = thisSpkResp{1, o};
            validSpksInds = find(thisRep >= StimStartTime_samp + TimeWindow_samp + 1 & thisRep <= PostStimStartTime_samp); % need to add a buffer at the start
            validSpks = thisRep(validSpksInds);
            
            nValidSpikes = numel(validSpks );
            
            relValidSpks = validSpks - StimStartTime_samp; % relative to the onset of the stim
            
            LStimWins = [];
            RStimWins = [];
            
            for q = 1:nValidSpikes
                
                thisSpk = relValidSpks(q);
                
                roi = thisSpk - TimeWindow_samp : thisSpk; % for time window before spike
                %roi = thisSpk - TimeWindow_samp : thisSpk + TimeWindow_samp; % for time window before and after spike
                if roi(1) <= 0 || roi(end) >= numel(thisSigData_L)
                    disp('')
                    continue
                else
                    
                    LStimWins(cnt,:) = thisSigData_L_norm_meanSub(roi);
                    RStimWins(cnt,:) = thisSigData_R_norm_meanSub(roi);
                    
                    LStimWins_Env(cnt,:) = yupperL(roi);
                    RStimWins_Env(cnt,:) = yupperR(roi);
                    
                    cnt = cnt +1;
                    
                    ALL_LStimWins(cnnt,:) = thisSigData_L_norm_meanSub(roi);
                    ALL_RStimWins(cnnt,:) = thisSigData_R_norm_meanSub(roi);
                    
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

    LStimWins_meanEnv = mean(All_LStimWins_Env, 1);
    RStimWins_meanEnv = mean(All_RStimWins_Env, 1);
    
    figure (103); clf
    subplot(3, 2, 1)
    plot(timepoints_ms, LStimWins_mean); axis tight
    ylim([-.05 .05])
    title([NeuronName ': Left ' Stim ' STA'])
    
    %xticks = 0:2:40;
    xticks = 0:2:20;
    set(gca, 'xtick', xticks)
    xlim([-0 20])
    
    %line([20 20], [-.2 .2], 'Color' , 'k')
    %xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0' '2', '4', '6', '8', '-10', '-12', '14', '16', '18', '20',};
    xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0'};
    set(gca, 'xticklabel', xtickabs )
    
    subplot(3, 2, 2)
    plot(timepoints_ms, RStimWins_mean); axis tight
    ylim([-.05 .05])
    title([NeuronName ': Right ' Stim ' STA'])
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xtickabs )
    
    %% Wavelet
    
    %clims = [0 5e-5];
    
    for  z = 1:2
        if z == 1
            %RawData = RStimWins_mean;
            RawData = LStimWins_mean;
            titleTxt = ['Left ' Stim ' STA - Wavelet'];
            envData1 = LStimWins_meanEnv;
            envData2 = RStimWins_meanEnv;
        elseif z== 2
            RawData = RStimWins_mean;
            titleTxt = ['Right ' Stim ' STA - Wavelet'];
            envData1 = RStimWins_meanEnv;
            envData2 = LStimWins_meanEnv;
        end
        
        
        Dt = 1/44100;
        t = 0:Dt:(numel(RawData)*Dt)-Dt;
        
        %[cfs,f] = cwt(RawData,'bump',1/Dt,'VoicesPerOctave',32);
        [cfs,f] = cwt(RawData,'bump',1/Dt,'VoicesPerOctave',48);
        figure(103);
        subplot(3, 2, z+2)
        helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
        ylim([.5 6])
        title(titleTxt)
        
        
        colorbar 'off'
        %colorbar('location', 'northoutside')
        xlim([0 20])
        set(gca, 'xtick', xticks)
        set(gca, 'xticklabel', xtickabs )
        
        
        if z == 1
            css = get(gca, 'clim');
        end
        
        caxis(css);
        
        subplot(3, 2, z+4);
        plot(timepoints_ms, envData1, 'k');
        hold on
        plot(timepoints_ms, envData2, 'color', [.5 .5 .5]);
        axis tight
        ylim([.1 .15])
        
        
        %% Frequency
figure(302)

        subplot(2, 4,5)
        helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
        ylim([.5 6])
        
meanf = mean(abs(cfs).^2, 2);
%medianf = median(abs(cfs).^2, 2);
stdf = std(abs(cfs').^2, 1)';
semF = stdf/sqrt(883);

posF = meanf + semF;
negF = meanf - semF;

STA.meanf = meanf;
STA.semF = semF;
        subplot(2, 4,6)
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

[pks,locs,w,p] = findpeaks(meant, 'MinPeakHeight',scaleEstimator);

STA.TDetections_ms = t(locs)*1e3;

xss = xlim;
line([xss(1) xss(2)], [scaleEstimator scaleEstimator] , 'color', 'r', 'linestyle', ':')

ylabel('Power')
set(gca, 'xtick', xticks)
set(gca, 'xticklabel', xtickabs )


        
        %[pxx,fF,pxxc] = pmtm(RawData,2,length(RawData),Fs,'ConfidenceLevel',0.95);
        
        %{
        plot(fF,10*log10(pxx))
        hold on
        plot(fF,10*log10(pxxc),'-', 'color', [.5 .5 .5])
        
        xlabel('kHz')
        ylabel('dB')
        title('Multitaper PSD Estimate with 95%-Confidence Bounds')
        xlim([0 6000])
        ylim([-150 -60])
        set(gca, 'xtick', 0:1000:6000)
        
        set(gca, 'xticklabel', {'0', '1', '2', '3', '4', '5', '6'})
        %}
        
        %     t = 0:1/fs:2-1/fs;
        %     x = cos(2*pi*100*t)+randn(size(t));
        %     [pxx,f] = pmtm(RawData,3,length(RawData),Fs);
        %     pmtm(RawData,3,length(RawData),Fs)
        %     xlim([0 6])
        %     pmtm(RawData, 2);
        %     pxx = pmtm(RawData, 2);
        %
        
        %     figure(100); clf
        %     spec_scale = 0.001;
        %     specgram1(double(RawData)/spec_scale,512,Fs,40,36);
        %     ylim([0 8000])
        
        
        STA.cfs{z} = cfs;
        STA.f{z} = f;
        
        STA.RawData{z} = RawData;
        
        STA.pxx{z} = pxx;
        STA.fF{z} = fF;
        STA.pxxc{z} = pxxc;
        
        STA.Env_mean{z} = envData1;
        
        
    end
    
    STA.ALL_LStimWins = ALL_LStimWins;
    STA.All_LStimWins_Env = All_LStimWins_Env;
    STA.ALL_RStimWins = ALL_RStimWins;
    STA.All_RStimWins_Env = All_RStimWins_Env;
    
    %%
    saveName = [FigSaveDir NeuronName '-STA-' Stim];
    plotpos = [0 0 20 15];
    
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    %print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    saveName = [FigSaveDir NeuronName '-STA-Data' Stim '.mat'];
    
    save(saveName, 'STA', '-v7.3')
end

%%

%%
%{
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

%dsf = 20;
dsf = 1;
Fsd = Fs/dsf;
hcf = 400;
[n_ch,n_tr,N] = size(thisSegData_wav);

[bb,aa] = butter(2,hcf/(Fs/2),'low');
V_ds = reshape(permute(thisSegData_wav,[3 1 2]),[],n_ch*n_tr);
V_ds = downsample(filtfilt(bb,aa,V_ds),dsf);
V_ds = reshape(V_ds,[],n_ch,n_tr);

%
[N,n_chs,n_trials] = size(V_ds);
nfreqs = 60;
min_freq = 1.5;
max_freq = 800;
Fsd = Fs/dsf;
min_scale = 1/max_freq*Fsd;
max_scale = 1/min_freq*Fsd;
wavetype = 'cmor1-1';
scales = logspace(log10(min_scale),log10(max_scale),nfreqs);
wfreqs = scal2frq(scales,wavetype,1/Fsd);

use_ch = 1;
cur_V = squeeze(V_ds(:,use_ch,:));
V_wave = cwt(cur_V(:),scales,wavetype);
V_wave = reshape(V_wave,nfreqs,[],n_trials);

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

