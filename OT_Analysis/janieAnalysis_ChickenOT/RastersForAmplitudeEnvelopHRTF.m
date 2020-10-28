function [] = RastersForAmplitudeEnvelopHRTF(experiment, recSession, NeuronName, oo)

if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);
dbstop if error

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'HRTF'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/';
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

smoothWin_ms = 2;

thisSigName = stimNames{7, 9};

[thisSigData,Fs] = audioread([SignalDir thisSigName '.wav']); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
smoothWin_samps = round(smoothWin_ms/1000*Fs);

% cutSigData = thisSigData(1: StimStartTime_samp,:);

[yupper,~] = envelope(thisSigData(:, 1));
smooth_yupper = smooth(yupper, smoothWin_samps);
%%
plotHeight = 0.05;

cols = {[0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0 0 0], [.7 .3 .7], [.7 .5 .7], [0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0 0 0], [.7 .3 .7],};

if oo == 1
    axes('position',[0.05 plotHeight 0.9 0.05]);
else
    
    %axes('position',[0.05 (oo*plotHeight)+plot_buffer 0.9 0.05]);
    axes('position',[0.05 (oo*plotHeight) 0.9 0.05]);
end

allSpksMatrix = C_OBJ.S_SPKS.SORT.allSpksMatrix;
epochLength_samps = C_OBJ.S_SPKS.INFO.epochLength_samps;
thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR

%% Concat all responses


conCatAll = [];
cnt =1;
for j = 1:13
    for k = 1:17
        
        nTheseReps = numel(allSpksMatrix{j, k});
        for o = 1: nTheseReps
            %    for k = 1: 15
            conCatAll{cnt} = allSpksMatrix{j,k}{1,o};
            allnames{cnt} = stimNames{j,k};
            cnt = cnt +1;
        end
        
    end
end

nAllReps = numel(conCatAll);
%%

plotOrder = randperm(nAllReps);

for q = 1 : 150
    
     s = plotOrder(q);
    
    these_spks_on_chan = conCatAll{s};
    
    ys = ones(1, numel(these_spks_on_chan))*q;
    hold on
    plot(these_spks_on_chan, ys, '.', 'color', cols{oo}, 'linestyle', 'none')
    
    nbr_spks = size(these_spks_on_chan, 2);
    
    % add a 1 to the FR vector for every spike
    %         for ind = 1 : nbr_spks
    %
    %             if these_spks_on_chan(ind) == 0
    %                 continue
    %             else
    %
    %                 thisUniqStimFR(these_spks_on_chan(ind)) = thisUniqStimFR(these_spks_on_chan(ind)) +1;
    %                 allSpksFR(these_spks_on_chan(ind)) = allSpksFR(these_spks_on_chan(ind)) +1;
    %             end
    %         end
end

axis tight
xlim([0 epochLength_samps])
% ylabel(['Reps = ' num2str(nAllReps)])
set(gca, 'xtick', []);
set(gca, 'ytick', []);

%
%
%     titleTextUnderscore = [obj.RS_INFO.ResultDirName{obj.O_STIMS.audSelInd} ' | SpkCluster ' num2str(obj.SPKS.clustOfInterest)];
%     titleText = titleTextUnderscore;
%     underscore = '_';
%
%     bla = find(titleTextUnderscore  == underscore);
%
%     for p = 1: numel(bla)
%         titleText(bla(p)) = '-';
%     end
%
%     title(titleText)
%     %% Firing Rate
%
%     subplot(4, 1, 4)
%     smoothiWin = round(obj.Fs*.005);% 5 ms
%     FRsmoothed = smooth(thisUniqStimFR, smoothiWin)/nAllReps;
%     timepoints = 1:1:numel(FRsmoothed);
%     timepoints_ms = timepoints/obj.Fs*1000;
%
%     area([stimStart_samp/obj.Fs*1000  stimStop_samp/obj.Fs*1000], [0.005 0.005], 'FaceColor', gray, 'EdgeColor', gray)
%     hold on
%     plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)
%
%     axis tight
%     ylim([0 0.002])
%     xlabel('Time [ms]')
%     ylabel('FR [Hz]')
%
if oo == 17
    axes('position',[0.05 .9 0.9 0.1]);
    
    maxTime = .3*Fs;
    postTime = maxTime - numel(smooth_yupper) - .1*Fs;
    pre = zeros(1, .1*Fs);
    post = zeros(1, postTime);
    HRTFStim = [pre smooth_yupper' post];
    
    timepoints_samp = 1:1:numel(HRTFStim);
    timepoints_ms = timepoints_samp/ Fs*1000;
    plot(timepoints_ms, HRTFStim, 'k')
    axis tight
    xlim([0 300])
    
    
    
    saveName = [FigSaveDir 'HRTF-AllRasters_HRTFAmp'];
    
    plotpos = [0 0 15 20];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    disp('')
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    
    axes('position',[0.05 .9 0.9 0.1]);
    
    
    Dt = 1/44100;
    t = 0:Dt:(numel(HRTFStim)*Dt)-Dt;
    
    %[cfs,f] = cwt(RawData,'bump',1/Dt,'VoicesPerOctave',32);
    [cfs,f] = cwt(HRTFStim,'bump',1/Dt,'VoicesPerOctave',48);
    helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',[Stim ' STA'],'Time [ms]','Frequency [kHz]')
    axis tight
    ylim([.5 5])
    
    clims = [0 1e-4];
    caxis(clims);
    colorbar 'off'
    xlim([0 300])
    
    
    
    saveName = [FigSaveDir 'HRTF-AllRasters_HRTFSpect'];
    
    plotpos = [0 0 15 20];
    print_in_A4(0, saveName, '-djpeg', 1, plotpos);
    disp('')
    print_in_A4(0, saveName, '-depsc', 1, plotpos);
    
end

end

