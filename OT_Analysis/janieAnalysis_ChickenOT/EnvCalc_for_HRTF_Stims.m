function [] = EnvCalc_for_HRTF_Stims(experiment, recSession, NeuronName)
dbstop if error
if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'HRTF'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);



%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/EnvAnalysis-HRTF/MLD/';
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
cnnt = 1;

smoothWin_ms = 2;

cnnt = 1;

figure(406); clf

for j = 1:nRows
    for k = 1:nCols
        
        thisSigName = stimNames{j, k};
        
        [thisSigData,Fs] = audioread([SignalDir thisSigName '.wav']); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
        
        cutSigData = thisSigData(1: StimStartTime_samp,:);
        
        smoothWin_samps = round(smoothWin_ms/1000*Fs);
        
        
        thisSigData_L = cutSigData(:, 1);
        thisSigData_R = cutSigData(:, 2);
        
        [yupperL,~] = envelope(thisSigData_L);
        [yupperR,~] = envelope(thisSigData_R);
        
        smooth_yupperL = smooth(yupperL, smoothWin_samps);
        smooth_yupperR = smooth(yupperR, smoothWin_samps);
        
        if k == 9 && j == 7
            
            figure(406)
            subplot(5, 2, 1)
            
            xtimepoints =1:1:size(cutSigData, 1);
            xtimepoints_ms = xtimepoints/Fs*1000;
            
            plot(xtimepoints_ms, yupperL, 'color', [.5 .5 .5]);
            hold on
            plot(xtimepoints_ms, smooth_yupperL, 'k', 'linewidth', 2)
            ylim([0 1])
            title([NeuronName ': Left HRTF Signal Envelope and PSTH | smooth = ' num2str(smoothWin_ms) ' ms'])
            xlabel ('Time [ms]')
            subplot(5, 2, 2)
            plot(xtimepoints_ms, yupperR, 'color', [.5 .5 .5]);
            hold on
            plot(xtimepoints_ms, smooth_yupperR, 'k', 'linewidth', 2)
            ylim([0 1])
            title([NeuronName ': Right HRTF Signal Envelope and PSTH | smooth = ' num2str(smoothWin_ms) ' ms'])
            xlabel ('Time [ms]')
        end
        
        
        %%
        
        thisSpkResp = SpkResponses{j,k};
        
        nReps = numel(thisSpkResp);
        
        
        thisUniqStimFR  = zeros(1,StimStartTime_samp); % we define a vector for integrated FR
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
        
        
        smooth_thisUniqStimFR = smooth(thisUniqStimFR, smoothWin_samps);
        %plot(smooth_thisUniqStimFR)
        
        if k == 9 && j == 7 % -90 and 0 elev
            
            figure(406)
            subplot(5, 2, 1)
            
            plot(xtimepoints_ms, smooth_thisUniqStimFR*5 +.6, 'b', 'linewidth', 1); % +.6 as plot offset
            
            subplot(5, 2, 2)
            plot(xtimepoints_ms, smooth_thisUniqStimFR*5 +.6, 'b', 'linewidth', 1);
            disp('')
        end
        
        
        xcov_L = xcorr(smooth_yupperL, smooth_thisUniqStimFR);
        xcov_R = xcorr(smooth_yupperR, smooth_thisUniqStimFR);
        
        [r_L, p_L] = corrcoef(smooth_yupperL, smooth_thisUniqStimFR);
        [r_R, p_R] = corrcoef(smooth_yupperR, smooth_thisUniqStimFR);
        
        ccL_r(cnnt) = r_L(1 ,2);
        ccL_p(cnnt) = p_L(1 ,2);
        
        ccR_r(cnnt) = r_R(1 ,2);
        ccR_p(cnnt) = p_R(1 ,2);
        
        AllstimNames{cnnt} = thisSigName;
        
        allCorrsL_matrix_r(j,k) = r_L(1 ,2);
        allCorrsL_matrix_p(j,k) = p_L(1 ,2);
        
        allCorrsR_matrix_r(j,k) = r_R(1 ,2);
        allCorrsR_matrix_p(j,k) = p_R(1 ,2);
        
        %{
        timepoints_samp = 1:1:numel(xcov_L);
        timepoints_ms = timepoints_samp/Fs*1000;
        
                    figure(305);  clf
                    plot(timepoints_ms, xcov_L)
                    hold on
                    plot(timepoints_ms, xcov_R)
                    xticks = 0:20:200;
                    
                    set(gca, 'xtick', xticks)
                    xlim([0 200])
                    ylim([0 15])

                    line([100 100], [0 15], 'Color' , 'k')
                    %xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0' '2', '4', '6', '8', '-10', '-12', '14', '16', '18', '20',};
                    xtickabs = {'-100', '-80', '-60', '-40', '-20', '0', '20', '40', '60', '80', '100'};
                    set(gca, 'xticklabel', xtickabs )
        %}
        
        allCorrsL(cnnt, :) = xcov_L;
        allCorrsR(cnnt, :) = xcov_R;
        
        cnnt= cnnt +1;
        
        %         figure(300);
        %         for j = 1:15
        %
        %             hold on
        %             plot(allCorrsL(j,:))
        %         end
        
        
    end
end
disp('')

nSigs_L = find(ccL_p <0.001);
nSigs_R = find(ccR_p <0.001);

ccL_r_sig  = nan(1, numel(ccL_r));
ccL_r_sig(nSigs_L) = ccL_r(nSigs_L);

ccR_r_sig  = nan(1, numel(ccR_r));
ccR_r_sig(nSigs_R) = ccR_r(nSigs_R);

CCL.ccL_r = ccL_r;
CCL.ccL_p = ccL_p;
CCL.allCorrsL_matrix_r = allCorrsL_matrix_r;
CCL.allCorrsL_matrix_p = allCorrsL_matrix_p;

CCL.AllstimNames = AllstimNames;

CCR.ccR_p = ccR_p;
CCR.ccR_r = ccR_r;
CCR.allCorrsR_matrix_r = allCorrsR_matrix_r;
CCR.allCorrsR_matrix_p = allCorrsR_matrix_p;
CCR.AllstimNames = AllstimNames;

%subplot(5, 2, [5 6])
%boxplot([ccL_r_sig ; ccR_r_sig]', 'whisker', 0, 'symbol', 'k.', 'outliersize', 4,  'jitter', 0.3, 'colors', [0 0 0], 'labels', {'Left', 'Right'})
%title('Significant correlation between stimulus envelope and PSTH')
%ylim([-.5 .5])

subplot(5, 2, [5 6])
boxplot([ccL_r_sig ; ccR_r_sig]', 'whisker', 0, 'symbol', 'k.', 'outliersize', 4,  'jitter', 0, 'colors', [0 0 0], 'labels', {'Left', 'Right'})
title('Significant correlation between stimulus envelope and PSTH')

hold on
xes = ones(1, numel(ccL_r_sig));
%plot(xes, ccL_r_sig, 'k.', 'linestyle', 'none')
scatter(xes, ccL_r_sig, 'k.', 'jitter','on', 'jitterAmount', 0.08);
xes = ones(1, numel(ccL_r_sig))*2;
%plot(xes, ccL_r_sig, 'k.', 'linestyle', 'none')
scatter(xes, ccR_r_sig, 'k.', 'jitter','on', 'jitterAmount', 0.08);
ylim([-.6 .6])

%%
xcorr_mean_L = mean(allCorrsL, 1);
xcorr_mean_R = mean(allCorrsR, 1);
timepoints_samp = 1:1:numel(xcov_L);
timepoints_ms = timepoints_samp/Fs*1000;


CCL.allCorrsL = allCorrsL;
CCL.xcorr_mean_L = xcorr_mean_L;
CCR.allCorrsR = allCorrsR;
CCR.xcorr_mean_R = xcorr_mean_R;


subplot(5, 2, 3)
plot(timepoints_ms, xcorr_mean_L, 'k', 'linewidth', 2)
hold on
plot(timepoints_ms, allCorrsL(1, :), 'color', [.5 .5 .5]);

xticks = 0:50:200;
set(gca, 'xtick', xticks)

xlim([0 200])
ylim([0 30])

line([100 100], [0 30], 'Color' , 'k')
%xtickabs = {'-20', '-18', '-16', '-14', '-12', '-10', '-8', '-6', '-4', '-2', '0' '2', '4', '6', '8', '-10', '-12', '14', '16', '18', '20',};
%xtickabs = {'-100', '-80', '-60', '-40', '-20', '0', '20', '40', '60', '80', '100'};
xtickabs = {'-100', '-50', '0', '50','100'};
set(gca, 'xticklabel', xtickabs )
title('Mean cross-correlation: Left stim envelope and PSTH')
xlabel('Lag [ms]')

subplot(5, 2, 4)
plot(timepoints_ms, xcorr_mean_R, 'k', 'linewidth', 2)
hold on
plot(timepoints_ms, allCorrsR(1, :), 'color', [.5 .5 .5]);
set(gca, 'xtick', xticks)

xlim([0 200])
ylim([0 30])

line([100 100], [0 30], 'Color' , 'k')
set(gca, 'xticklabel', xtickabs )
title('Mean cross-correlation: Right stim envelope and PSTH')
xlabel('Lag [ms]')
%% Across Column (Azimuth)

allAz = [-180 -168.75 -157.5 -146.25 -135 -123.75 -112.5 -101.25 -90 -78.75 -67.5 -56.25 -45 -33.75 -22.5 -11.25 0 11.25 22.5 33.75 45 56.25 67.5 78.75 90 101.25 112.5 123.75 135 146.25 157.5 168.75 180];
allEl = [-67.5 -56.25 -45 -33.75 -22.5 -11.25 0 11.25 22.5 33.75 45 56.25 67.5];

allAz_forTicks = [-180 -157.5 -135 -112.5 -90 -67.5 -45 -22.5 0 22.5 45 67.5 90 112.5 135 157.5 180];

for o = 1:33 % Diff n of azimuths
    
    thisAz = allAz(o);
    
    thisAz_L_r = allCorrsL_matrix_r(:,o);
    thisAz_L_p = allCorrsL_matrix_p(:,o);
    
    sigAZ_L_inds = find(thisAz_L_p < 0.001);
    sigAZ_L = thisAz_L_r(sigAZ_L_inds);
    
    xesL = ones(1, numel(sigAZ_L)) * thisAz;
    
    thisAz_R_r = allCorrsR_matrix_r(:,o);
    thisAz_R_p = allCorrsR_matrix_p(:,o);
    
    sigAZ_R_inds = find(thisAz_R_p < 0.001);
    sigAZ_R = thisAz_R_r(sigAZ_R_inds);
    
    xesR = ones(1, numel(sigAZ_R)) * thisAz;
    
    subplot(5, 2, 7); 
    plot(xesL, sigAZ_L, 'k.', 'linestyle', 'none')
    %scatter(xesL, sigAZ_L, 'k.', 'jitter','on', 'jitterAmount', 0.1); %doesnt work
    hold on
    
    subplot(5, 2, 8)
    plot(xesR, sigAZ_R, 'k.', 'linestyle', 'none')
    %scatter(xesR, sigAZ_R, 'k.', 'jitter','on', 'jitterAmount', 0.05);
    hold on
end

subplot(5, 2, 7)
ylim([-.6 .6])
title('Left: Significant correlations across Azimuth')
set(gca, 'xtick', allAz_forTicks)
xlabel('Azimuth')

subplot(5, 2, 8)
ylim([-.6 .6])
title('Right: Significant correlations across Azimuth')
set(gca, 'xtick', allAz_forTicks)
xlabel('Azimuth')



for o = 1:13 % Diff n of azimuths
    
    thisEl = allEl(o);
    
    thisEL_L_r = allCorrsL_matrix_r(o,:);
    thisEl_L_p = allCorrsL_matrix_p(o,:);
    
    sigEl_L_inds = find(thisEl_L_p < 0.001);
    sigEl_L = thisEL_L_r(sigEl_L_inds);
    
    xesL = ones(1, numel(sigEl_L)) * thisEl;
    
    thisEl_R_r = allCorrsR_matrix_r(:,o);
    thisEl_R_p = allCorrsR_matrix_p(:,o);
    
    sigEl_R_inds = find(thisEl_R_p < 0.001);
    sigEl_R = thisEl_R_r(sigEl_R_inds);
    
    xesR = ones(1, numel(sigEl_R)) * thisEl;
    
    subplot(5, 2, 9)
    plot(xesL, sigEl_L, 'k.', 'linestyle', 'none')
    %scatter(xesL, sigEl_L, 'k.', 'jitter','on', 'jitterAmount', 0.05);
    hold on
    
    subplot(5, 2, 10)
    plot(xesR, sigEl_R, 'k.', 'linestyle', 'none')
    %scatter(xesR, sigEl_R, 'k.', 'jitter','on', 'jitterAmount', 0.05);
    hold on
end
disp('')

subplot(5, 2, 9)
ylim([-.6 .6])
xlabel('Elevation')
title('Left: Significant Correlations across Elevation')
set(gca, 'xtick', allEl)

subplot(5, 2, 10)
ylim([-.6 .6])
title('Right: Significant Correlations across Elevation')
xlabel('Elevation')
set(gca, 'xtick', allEl)

saveName = [FigSaveDir NeuronName '-EnvAnalysis-' Stim];
plotpos = [0 0 25 20];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%print_in_A4(0, saveName, '-depsc', 0, plotpos);

save([saveName '-EnvData.mat'], 'CCL', 'CCR', '-v7.3')


%
% subplot(4, 2, 7)
% plot(timepoints_ms, AzMean_L, 'k', 'linewidth', 2)
% hold on
% plot(timepoints_ms, allCorrsR(1, :), 'color', [.5 .5 .5]);
% set(gca, 'xtick', xticks)
%
% xlim([0 200])
% ylim([0 30])
%
% line([100 100], [0 30], 'Color' , 'k')
% set(gca, 'xticklabel', xtickabs )
% title('Mean cross-correlation: Right stim envelope and PSTH')
%
%




%%





end

