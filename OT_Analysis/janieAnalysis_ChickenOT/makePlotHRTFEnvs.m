function [] = makePlotHRTFEnvs(experiment, recSession, NeuronName)

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
smoothWin_ms = 1;

%%


nRows = size(stimNames, 1);
nCols = size(stimNames, 2);

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

%%
figH = figure(406); clf

cols = redblue(15);

bla = find(sum(cols, 2) == 3);

cols(bla,:) = [];
allNames = [];

kset = [5 7 9 11 13 15 17 19 21 23 25 27 29];
%kset = [9 13 17 21 25];

%cols = {[0 0 0], [0.05 0.05 0.05], [0.1 0.1 0.1], [0.15 0.15 0.15],[0.2 0.2 0.2], [0.25 0.25 0.25],[0.3 0.3 0.3], [0.35 0.35 0.35], [0.4 0.4 0.4]};
%cols = {[0 0 0], [0.2 0.2 0.2],  [0.4 0.4 0.4], [0.6 0.6 0.6], [0.8 0.8 0.8]};

for p = 1:2
cnt = 1;    
    if p == 1
        thisData = AllnormL;
        subplot(1, 2, 1)
        titleTxt = 'Left Channel';
    else
        thisData = AllnormR;
        subplot(1, 2, 2)
        titleTxt = 'Right Channel';
    end
    
    for j = 7
        for k = kset
            
            thisSigName = stimNames{j, k};
            %allNames{cnt} = thisSigName ;
            
            %[thisSigData,Fs] = audioread([SignalDir thisSigName '.wav']); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
            
            %cutSigData = thisSigData(1: StimStartTime_samp,:);
            
            smoothWin_samps = round(smoothWin_ms/1000*Fs);
            
            thisSigData_L = thisData{j,k};
            %thisSigData_R = thisSigData(:, 2);
            
            [yupperL,~] = envelope(thisSigData_L);
            %[yupperR,~] = envelope(thisSigData_R);
            
            smooth_yupperL = smooth(yupperL, smoothWin_samps);
            %smooth_yupperR = smooth(yupperR, smoothWin_samps);
            
            xtimepoints =1:1:size(smooth_yupperL, 1);
            xtimepoints_ms = xtimepoints/Fs*1000;
            
            hold on
            
            meanSub = smooth_yupperL-mean(smooth_yupperL);
            yupperL_meansub = yupperL - mean(yupperL);
            
            %plot(xtimepoints_ms, smooth_yupperL+ cnt*.35, 'color', cols(cnt,:))
            plot(xtimepoints_ms, yupperL_meansub + cnt*.25, 'color', [.7 .7 .7])
            hold on
            plot(xtimepoints_ms, meanSub + cnt*.25, 'color', cols(cnt,:), 'linewidth', 1)
            
            %plot(xtimepoints_ms, yupperL_meansub + cnt*.25, 'color', cols(cnt,:))
            
            %plot(xtimepoints_ms, smooth_yupperL+ cnt*.3, 'color', cols{cnt})
            cnt = cnt +1;
            text(3, meanSub (1)+ cnt*.25, thisSigName)
            
        end
        
        
    end
    xlim([0 100])
    ylim([0 3.5])
    title(titleTxt)
    xlabel ('Time [ms]')
end



%%

saveName = [FigSaveDir '-EnvAnalysis_LR_HRTFs-'];
plotpos = [0 0 25 20];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);





end

