function [] = STA_for_WN_Stims_Envs(experiment, recSession, NeuronName)
dbstop if error

%NeuronName = 'N-12';
%Stim = 'WN';

%experiment = 1; %efc
%recSession = 12; %sFigSaveNamec

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);
%%
ALL_LStimWins = [];
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'WhiteNoise'));


audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/STA-WN/RasterSTA/';
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
       
          [yupperL,~] = envelope(thisSigData_L);
            %[yupperR,~] = envelope(thisSigData_R);
            
           % smooth_yupperL = smooth(yupperL, smoothWin_samps);
            
            
        %thisSigData_R = thisSigData(:, 2);
        
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
                
                roi = thisSpk - TimeWindow_samp : thisSpk;  % for time window before spike
                %roi = thisSpk - TimeWindow_samp : thisSpk + TimeWindow_samp; % for time window before and after spike
                if roi(1) <= 0 || roi(end) >= numel(yupperL)
                    disp('')
                    continue
                else
                    LStimWins(cnt,:) = yupperL(roi);
                    %RStimWins(cnt,:) = thisSigData_R(roi);
                    
                    cnt = cnt +1;
                    
                    ALL_LStimWins(cnnt,:) = yupperL(roi);
                    %ALL_RStimWins(cnnt,:) = thisSigData_R(roi);
                    
                    cnnt = cnnt +1;
                end
            end
            
        end
        allWins_L{j, k} = LStimWins;
        %allWins_R{j, k} = RStimWins;
        
    end
    
    
    
end
disp('')

%% Raw data
if ~isempty(ALL_LStimWins)
    
    smoothWin_ms = 1;
    smoothWin_samp = smoothWin_ms/1000*Fs;
    
LStimWins_mean = mean(ALL_LStimWins);
stdLStim = std(ALL_LStimWins, 1);
semLStim = stdLStim / (sqrt(size(ALL_LStimWins, 1)));
semLStimSmooth = smooth(semLStim, smoothWin_samp);

LStimWins_mean_smooth = smooth(LStimWins_mean, smoothWin_samp);

%RStimWins_mean = mean(ALL_RStimWins);
timepoints_samp = 1:1:numel(LStimWins_mean);
timepoints_ms = timepoints_samp/Fs*1000;

figure (103); clf
subplot(2, 2, 2)
hold on
plot(timepoints_ms, LStimWins_mean_smooth+semLStimSmooth, 'color', [0.5 0.5 0.5]); 
plot(timepoints_ms, LStimWins_mean_smooth-semLStimSmooth, 'color', [0.5 0.5 0.5]); 
plot(timepoints_ms, LStimWins_mean_smooth, 'k');
axis tight

title([NeuronName ': ' Stim ' Mean STA -Env'])

xticks = 0:2:20;
set(gca, 'xtick', xticks)
xlim([0 20])
ylim([.15 .3])

%xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0' '2', '4', '6', '8', '-10', '-12', '14', '16', '18', '20',};
xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0'};
set(gca, 'xticklabel', xtickabs )
% 
% subplot(2, 1, 2)
% LStimWins_mean_smooth_diff = diff(LStimWins_mean_smooth);
% plot(timepoints_ms(1:numel(LStimWins_mean_smooth_diff)), LStimWins_mean_smooth_diff); axis tight

%%
saveName = [FigSaveDir NeuronName '-STA-Env' Stim];
plotpos = [0 0 15 10];

print_in_A4(0, [saveName 'timeFreq'], '-depsc', 0, plotpos);

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
