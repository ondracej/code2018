function [] = analyzeSWRDetections_2021()

%detFileToLoad = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Ephys\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-71-76_Final\20190919\17-51-46\Ephys\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-71-76_Final\20190916\18-05-58\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-71-76_Final\20190917\16-05-11\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-71-76_Final\20190923\18-21-42\Ephys\Detections\__SWR-Detections.mat';

%detFileToLoad = 'G:\SWR\ZF-o3b7\20200116\18-21-31\Ephys\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-o3b7\20200118\19-50-48\Ephys\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-o3b7\20200117\17-56-38\Ephys\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-o3b7\20200125\18-01-36\Ephys\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-o3b7\20200128\19-37-53\Ephys\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-o3b7\20200203\18-41-49\Ephys\Detections\__SWR-Detections.mat';

detFileToLoad = 'H:\HamedsData\w042_w044\w044\chronic_2022-01-01_20-26-41\Ephys\Detections\__SWR-Detections.mat';
isChronic = 1;

dbstop if error

load(detFileToLoad);
disp('')

SessionDir = D.INFO.SessionDir;
plotDir = [SessionDir 'Detections\'];

rippleChans = D.INFO.rippleChans;
SWChan = D.INFO.SWChan;

%%

dataRecordingObj = OERecordingMF(SessionDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

Fs_orig = dataRecordingObj.samplingFrequency;
recordingDur_ms = dataRecordingObj.recordingDuration_ms;
recordingDur_s = recordingDur_ms/1000;

%%

bandPassFilter1 = [1 400];
Ripple = [6 150];

fObj = filterData(Fs_orig);

%BandPass 1
fobj.filt.BP1=filterData(Fs_orig);
fobj.filt.BP1.highPassCutoff=bandPassFilter1(1);
fobj.filt.BP1.lowPassCutoff=bandPassFilter1(2);
fobj.filt.BP1.filterDesign='butter';
fobj.filt.BP1=fobj.filt.BP1.designBandPass;
fobj.filt.BP1.padding=true;

%Ripple
fobj.filt.Rip1=filterData(Fs_orig);
fobj.filt.Rip1.highPassCutoff=Ripple(1);
fobj.filt.Rip1.lowPassCutoff=Ripple(2);
fobj.filt.Rip1.filterDesign='butter';
fobj.filt.Rip1=fobj.filt.Rip1.designBandPass;
fobj.filt.Rip1.padding=true;

% Original SW filter
fobj.filt.SW2=filterData(Fs_orig);
fobj.filt.SW2.lowPassPassCutoff=30;% this captures the LF pretty well for detection
fobj.filt.SW2.lowPassStopCutoff=40;
fobj.filt.SW2.attenuationInLowpass=20;
fobj.filt.SW2=fobj.filt.SW2.designLowPass;
fobj.filt.SW2.padding=true;

fobj.filt.FH2=filterData(Fs_orig);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

fobj.filt.FN =filterData(Fs_orig);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;

%% SW Statistics

nDataChunks = numel(D.AllRippleDetections_abs);
TOn_ms = D.INFO.TOn;
seg_ms = D.INFO.seg_ms;

PreWin_ms = 250;
PostWin_ms = 250;

PreWin_samp = PreWin_ms/1000*Fs_orig;
PostWin_samp = PostWin_ms/1000*Fs_orig;

if isChronic
    nSegsToUse = 1000;
    nDataChunksRand = randperm(nDataChunks);
    
    thisSegSet = nDataChunksRand(1:nSegsToUse);
else
    thisSegSet = 1:nSegsToUse;
end


for j = 1:numel(thisSegSet)
    
    thisInd = thisSegSet(j);
    
    if ~isempty(D.AllSWDetections_rel{thisInd})
        thisSWDet_rel = D.AllSWDetections_rel{thisInd}(:,2); % we use the rel times to load in the data
        
        [rawData,t_ms]=dataRecordingObj.getData(SWChan,TOn_ms(thisInd), seg_ms);
        
        DataSeg_BP = fobj.filt.BP1.getFilteredData(rawData); %raw
        DataSeg_Rip = squeeze(fobj.filt.Rip1.getFilteredData(DataSeg_BP)); % SW
        DataSeg_SW = squeeze(fobj.filt.SW2.getFilteredData(DataSeg_BP)); % SW
        DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(DataSeg_BP)); % HF
        
        
        %% Find the mins of the SWs
        
        cnt_sw = 1;
        allMinInds = [];
        for k = 1:numel(thisSWDet_rel)
            
            [minv blaind] = min(DataSeg_SW(thisSWDet_rel(k)-PreWin_samp:thisSWDet_rel(k)+PostWin_samp));
            
            if minv > -200 % set this threshold to get rid of weird small amplitude SWs
                continue
            end
            allMinInds(cnt_sw) = blaind + thisSWDet_rel(k)-PreWin_samp;
            cnt_sw = cnt_sw+1;
        end
        
        allMinInds = unique(allMinInds); % this gets rid of the double detections
        
        cnt_sw = 1;
        BP_data = [];
        SW_data = [];
        SWHF_data = [];
        Rip_data = [];
        for k = 1:numel(allMinInds)
            BP_data(cnt_sw,:) = DataSeg_BP(allMinInds(k)-PreWin_samp*2:allMinInds(k)+PostWin_samp*2-1);
            SW_data(cnt_sw,:)  = DataSeg_SW(allMinInds(k)-PreWin_samp*2:allMinInds(k)+PostWin_samp*2-1);
            SWHF_data(cnt_sw,:) = DataSeg_HF(allMinInds(k)-PreWin_samp*2:allMinInds(k)+PostWin_samp*2-1);
            Rip_data(cnt_sw,:) = DataSeg_Rip(allMinInds(k)-PreWin_samp*2:allMinInds(k)+PostWin_samp*2-1);
            
            cnt_sw = cnt_sw+1;
            
        end
        
        
        %{
    for o = 1:size(SW_data, 1)
        figure(100); clf
        plot(SW_data (o,:));
        xlim([0 size(SW_data, 2)-1])
        line([15000 15000], [-400 200])
        pause
    end
        %}
        
        allMinInds_REL{j} = allMinInds;
        allMinInds_ABS{j} = allMinInds + TOn_ms(thisInd)/1000*Fs_orig;
        all_BP_data{j} = BP_data;
        all_SW_data{j} = SW_data;
        all_SWHF_data{j} = SWHF_data;
        all_Rip_data{j} = Rip_data;
    end
end



%% Concatenate


nonemptyInds = cellfun(@(x) ~isempty(x), allMinInds_ABS);
allMinInds_ABS = allMinInds_ABS(nonemptyInds); 

allMinInds_ABS_concat_samp = cell2mat(allMinInds_ABS);
allMinInds_ABS_concat_ms = allMinInds_ABS_concat_samp/Fs_orig*1000;

allBP_samps = vertcat(all_BP_data{:});
allSWPeaks_samps = vertcat(all_SW_data{:});
allSWHF_samps = vertcat(all_SWHF_data{:});
allRip_samps = vertcat(all_Rip_data{:});

%%
FD.allMinInds_REL = allMinInds_REL;
FD.allMinInds_ABS = allMinInds_ABS;
FD.allMinInds_ABS_concat_samp = allMinInds_ABS_concat_samp;
FD.allMinInds_ABS_concat_ms = allMinInds_ABS_concat_ms;
FD.allBP_samps = allBP_samps;
FD.allSWPeaks_samps = allSWPeaks_samps;
FD.allSWHF_samps = allSWHF_samps;
FD.allRip_samps = allRip_samps;
FD.Fs_orig = Fs_orig;

%% A - Raw Data

timestamps_samp = 1:1:size(allSWPeaks_samps, 2);
timestamps_ms = timestamps_samp/Fs_orig*1000;

%%
figH = figure (102); clf;
subplot(5, 1, 1)
plotInd = 300; %6

plot(timestamps_ms,allBP_samps(plotInd,:), 'k');
hold on
plot(timestamps_ms,allSWPeaks_samps(plotInd,:), 'r');

xtickLabs = [-500 -400 -300 -200 -100 0 100 200 300 400 500];
set(gca, 'xticklabel', xtickLabs)
xlabel('Time (ms)')
title (['n = ' num2str(size(allSWPeaks_samps, 1)) ' SWs'])

%
subplot(5, 1, 2)
plot(timestamps_ms,allSWHF_samps(plotInd,:), 'k');

%%
binsSize_ms = 2;
binsSize_samps = binsSize_ms/1000*Fs_orig;
HFI = [];
for j = 1:size(allSWHF_samps, 1)
    
    bla = buffer(allSWHF_samps(j,:), binsSize_samps);
    absBla = abs(bla);
    HFI(j,:) = sum(absBla, 1)/binsSize_samps;
end

subplot(5, 1, 3)
cla
imagesc(HFI, [0 30])

%%
meanSW = nanmean(allSWPeaks_samps, 1);
medianSW = nanmedian(allSWPeaks_samps, 1);
stdSW = nanstd(allSWPeaks_samps, 1);
semSW = stdSW/sqrt(size(allSWPeaks_samps,1));

%%

subplot(5, 1, 4)
plot(timestamps_ms,meanSW);
hold on
%jbfill(timestamps_ms,[meanSW+semSW],[meanSW-semSW],[.5,0.5,.5],[.5,0.5,.5],[],.3);
hold on;
plot(timestamps_ms,medianSW, 'k');
%jbfill(timestamps_ms,[medianSW+semSW],[medianSW-semSW],[.5,0.5,.5],[.5,0.5,.5],[],.3);
axis tight
xlim([0 1000])
ylim([-350 150])

line([500 500], [-350 150], 'color', 'k')

%%
subplot(5, 1, 5)

meanHPI = mean(HFI, 1);

plot(meanHPI, 'r');
axis tight
%%

RecSession = D.INFO.RecSession;
underscore = '_';
bla = find(RecSession ==  underscore);
RecSession(bla) = '-';

titleText = [D.INFO.birdName ' | ' RecSession];

annotation(figH,'textbox',...
    [0.05 0.94 0.80 0.05],...
    'String',titleText,...
    'LineStyle','none',...
    'HorizontalAlignment','left',...
    'FitBoxToText','off');
%%
plot_filename = [plotDir 'SWRSummaryPlot'];


plotpos = [0 0 15 15];
print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
print_in_A4(0, plot_filename, '-depsc', 0, plotpos);


%%

DetectionSaveName = [plotDir '__Final_SWR-Detections.mat'];
save(DetectionSaveName, 'FD', '-v7.3');
disp(['Saved:' DetectionSaveName ])



end
