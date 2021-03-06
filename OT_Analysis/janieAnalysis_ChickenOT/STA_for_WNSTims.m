function [] = STA_for_WNSTims()
dbstop if error

NeuronName = 'N-03';
Stim = 'HRTF';

experiment = 1; %efc
recSession = 3; %sFigSaveNamec

audSelInd = 1; % SpikesThis is the index, spikesnot the stim number!!!

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/Figs/';

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

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

SignalDir = '/media/dlc/Data8TB/TUM/OT/Signals/';

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


TimeWindow_ms = 20;
TimeWindow_samp =TimeWindow_ms /1000*SamplingRate;
%%

stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
SpkResponses = C_OBJ.S_SPKS.SORT.allSpksMatrix;

nRows = size(stimNames, 1);
nCols = size(stimNames, 2);
cnnt = 1;
for j = 1:nRows
    for k = 1:nCols
        
        thisSigName = stimNames{j, k};
        
        [thisSigData,Fs] = audioread([SignalDir thisSigName '.wav']);
        
        thisSigData_L = thisSigData(:, 1);
        thisSigData_R = thisSigData(:, 2);
        
        xtimepoints =1:1:size(thisSigData, 1);
        xtimepoints_s = xtimepoints/Fs;
        
        %figure; plot(xtimepoints_s, thisSigData); axis tight
        
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
                
                roi = thisSpk - TimeWindow_samp : thisSpk-1;
                LStimWins(cnt,:) = thisSigData_L(roi);
                RStimWins(cnt,:) = thisSigData_R(roi);
                
                cnt = cnt +1;
                
                ALL_LStimWins(cnnt,:) = thisSigData_L(roi);
                ALL_RStimWins(cnnt,:) = thisSigData_R(roi);
                
                cnnt = cnnt +1;
            end
            
        end
        allWins_L{j, k} = LStimWins;
        allWins_R{j, k} = RStimWins;
        
    end
    
    
    
end
disp('')

%% Raw data

LStimWins_mean = mean(ALL_LStimWins);
RStimWins_mean = mean(ALL_RStimWins);
timepoints_samp = 1:1:numel(LStimWins_mean);
timepoints_ms = timepoints_samp/Fs*1000;

figure (103); clf
subplot(2, 2, 1)
plot(timepoints_ms, LStimWins_mean); axis tight
ylim([-.2 .2])
title([NeuronName ': Left ' Stim ' STA'])

xticks = 0:2:20;
set(gca, 'xtick', xticks)
xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0'};
set(gca, 'xticklabel', xtickabs )

subplot(2, 2, 2)
plot(timepoints_ms, RStimWins_mean); axis tight
ylim([-.2 .2])
title([NeuronName ': Right ' Stim ' STA'])
set(gca, 'xtick', xticks)
set(gca, 'xticklabel', xtickabs )

%% Wavelet

clims = [0 5e-5];

for  z = 1:2
    if z == 1
        %RawData = RStimWins_mean;
        RawData = LStimWins_mean;
        titleTxt = ['Left ' Stim ' STA - Wavelet'];
    elseif z== 2
        RawData = RStimWins_mean;
        titleTxt = ['Right ' Stim ' STA - Wavelet'];
    end
    
    Dt = 1/44100;
    t = 0:Dt:(numel(RawData)*Dt)-Dt;
    
    %[cfs,f] = cwt(RawData,'bump',1/Dt,'VoicesPerOctave',32);
    [cfs,f] = cwt(RawData,'bump',1/Dt,'VoicesPerOctave',48);
    figure(103);
    subplot(2, 2, z+2)
    helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
    ylim([.5 5])
    title(titleTxt)
    
    colorbar 'off'
    xlim([0 20])
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xtickabs )
    caxis(clims);
    
end

%%
saveName = [FigSaveDir NeuronName '-STA-' Stim];
plotpos = [0 0 20 15];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%print_in_A4(0, saveName, '-depsc', 0, plotpos);


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
