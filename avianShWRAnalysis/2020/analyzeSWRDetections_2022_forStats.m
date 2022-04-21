function [] = analyzeSWRDetections_2022_forStats()


%detFileToLoad = 'H:\HamedsData\w042_w044\w044\chronic_2022-01-01_20-26-41\Detections\__SWR-Detections.mat';
%detFileToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-28_21-51-11\Detections\__SWR-Detections.mat';

%% 71-76
%detFileToLoad = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-71-76_Final\20190919\17-51-46\Detections\__SWR-Detections.mat';
%detFileToLoad = 'G:\SWR\ZF-71-76_Final\20190917\16-05-11\Detections\__SWR-Detections.mat';

%% w027

detFileToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-04_22-02-26\Ephys\Detections\__SWR-Detections.mat';

%%

nonemptyInds = 
artifactDets = find(cellfun(@(x) ~isempty(x), D.allArtifacts_abs));    
artifactDiffs = diff(artifactDets);
dbstop if error

load(detFileToLoad);
disp('')

SessionDir = D.INFO.SessionDir;
plotDir = [SessionDir(1:end-6) '\Detections\'];

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

PreWin_ms = 100;
PostWin_ms = 100;

PreWin_samp = PreWin_ms/1000*Fs_orig;
PostWin_samp = PostWin_ms/1000*Fs_orig;
   
    thisSegSet = 1:nDataChunks;


cnt = 1;
for j = 1:numel(thisSegSet)
    
    thisInd = thisSegSet(j);
    
    if ~isempty(D.AllSWDetections_rel{thisInd})
        thisSWDet_rel = D.AllSWDetections_rel{thisInd}(:,2); % we use the rel times to load in the data
        
        [rawData,~]=dataRecordingObj.getData(SWChan,TOn_ms(thisInd), seg_ms);
        
        DataSeg_BP = fobj.filt.BP1.getFilteredData(rawData); %raw
        DataSeg_Rip = squeeze(fobj.filt.Rip1.getFilteredData(DataSeg_BP)); % SW
        DataSeg_SW = squeeze(fobj.filt.SW2.getFilteredData(DataSeg_BP)); % SW
        DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(DataSeg_BP)); % HF
        
        
        %% Find the mins of the SWs
        
        cnt_sw = 1;
        allMinInds = [];
        for k = 1:numel(thisSWDet_rel)
            
            %[minv blaind] = min(DataSeg_Rip(thisSWDet_rel(k)-PreWin_samp:thisSWDet_rel(k)+PostWin_samp));
            [minv blaind] = min(DataSeg_SW(thisSWDet_rel(k)-PreWin_samp:thisSWDet_rel(k)+PostWin_samp));
            %figure; plot(DataSeg_SW(thisSWDet_rel(k)-PreWin_samp:thisSWDet_rel(k)+PostWin_samp))
            
            allMinInds(cnt_sw) = blaind + thisSWDet_rel(k)-PreWin_samp;
            cnt_sw = cnt_sw+1;
        end
        
        allMinInds = unique(allMinInds); % this gets rid of the double detections
        
            
        BP_data = [];
        SW_data = [];
        SWHF_data = [];
        Rip_data = [];
        
        for k = 1:numel(allMinInds)
            %BP_data(cnt_sw,:) = DataSeg_BP(allMinInds(k)-PreWin_samp:allMinInds(k)+PostWin_samp-1);
            %SW_data(cnt_sw,:)  = DataSeg_SW(allMinInds(k)-PreWin_samp:allMinInds(k)+PostWin_samp-1);
            %SWHF_data(cnt_sw,:) = DataSeg_HF(allMinInds(k)-PreWin_samp:allMinInds(k)+PostWin_samp-1);
            %Rip_data(cnt_sw,:) = DataSeg_Rip(allMinInds(k)-PreWin_samp:allMinInds(k)+PostWin_samp-1);
            
            BP_data = squeeze(DataSeg_BP(allMinInds(k)-PreWin_samp:allMinInds(k)+PostWin_samp-1));
            SW_data = DataSeg_SW(allMinInds(k)-PreWin_samp:allMinInds(k)+PostWin_samp-1);
            SWHF_data = DataSeg_HF(allMinInds(k)-PreWin_samp:allMinInds(k)+PostWin_samp-1);
            Rip_data = DataSeg_Rip(allMinInds(k)-PreWin_samp:allMinInds(k)+PostWin_samp-1);
            
           % thresh = 100;
            minWidth_ms = 10;
            midWidth_samples = round((minWidth_ms/1000)*Fs_orig);
            maxWidth_ms = 80;
            maxWidth_samples = 2000;
            peakDistance_ms = 200;
            peakDistance_sample = round(peakDistance_ms*1000/Fs_orig);
            minProm = 180;
            
            [pks_sw,locs_sw,w_sw,p_sw] = findpeaks(-SW_data, 'MaxPeakWidth', maxWidth_samples, 'MinPeakProminence', minProm, 'Widthreference', 'halfheight');
            
           %{ 
            figure(204); clf
            
            subplot(3, 1, 1)            
            plot(-SW_data)
            hold on
            plot(-BP_data)
            axis tight
            ylim([-400 400])
            title(['Prom = ' num2str(p_sw) '; width = ' num2str(w_sw)])
            subplot(3, 1, 2)
            plot(SWHF_data)
            axis tight
            ylim([-100 100])
            subplot(3, 1, 1)
            hold on
            plot(locs_sw, pks_sw+10, 'kv')
            subplot(3, 1, 3)
            plot(squeeze(DataSeg_BP(allMinInds(k)-PreWin_samp*5:allMinInds(k)+PostWin_samp*5-1)))
            axis tight
            ylim([-400 400])
            %}
          
            %pause
            if numel(locs_sw) > 1
                [maxProm, maxInd] = max(p_sw);
                
                pks_sw = pks_sw(maxInd);
                locs_sw = locs_sw(maxInd);
                w_sw = w_sw(maxInd);
                p_sw = p_sw(maxInd);
            end
            
            w_sw_ms = (w_sw/Fs_orig)*1000;
            
            if ~isempty(pks_sw)
                
                peakH(cnt) = pks_sw;
                peakW_ms(cnt) = w_sw_ms;
                prom(cnt) = p_sw;
                
                DetTime_ABS_samp(cnt) = allMinInds(k) + TOn_ms(thisInd)/1000*Fs_orig;
                DetTime_ABS_s(cnt) = DetTime_ABS_samp(cnt)/Fs_orig;
                
                BP_DataSegs{cnt,:} = BP_data;
                SWHF_DataSegs{cnt,:} = SWHF_data;
                Rip_DataSegs{cnt,:} = Rip_data;
                SW_DataSegs{cnt,:} = SW_data;
                
                
                cnt = cnt+1;
            end
            
            
        end
        
        %{
             timepoints = 1:1:numel(BP_data);
    timepoints_s = timepoints/Fs_orig;
  
            figure(253); clf
            subplot(4, 1, 1)
            plot(timepoints_s, -BP_data)
            subplot(4, 1, 2)
            plot(SW_data)
            subplot(4, 1, 3)
            plot(SWHF_data)
             subplot(4, 1, 4)
            plot(Rip_data)
        %}
        
    end
end

FD.BP_DataSegs = BP_DataSegs;
FD.SWHF_DataSegs = SWHF_DataSegs;
FD.Rip_DataSegs = Rip_DataSegs;
FD.SW_DataSegs = SW_DataSegs;
%% Height Stats

H.mean = mean(peakH);
H.median = median(peakH);
H.std = std(peakH);
H.sem = H.std/sqrt(numel(peakH));
H.iqr = iqr(peakH);

%% Width Stats

W.mean = mean(peakW_ms);
W.median = median(peakW_ms);
W.std = std(peakW_ms);
W.sem = W.std/sqrt(numel(peakW_ms));
W.iqr = iqr(peakW_ms);

%% Times

T.absoluteTime_samp = DetTime_ABS_samp;
T.absoluteTime_s = DetTime_ABS_s;

%% Prominence

P.mean = mean(prom);
P.median = median(prom);
P.std = std(prom);
P.sem = P.std/sqrt(numel(prom));
P.iqr = iqr(prom);

%%

toPlot = [peakW_ms ; peakH ; prom];

figure(130); clf
subplot(5, 3, [1 2 3])
boxplot(toPlot','PlotStyle','compact', 'color', 'k', 'Labels',{'','', ''})
title(['n = ' num2str(numel(peakW_ms))])

subplot(5, 3, 4)
histogram(peakW_ms)
title('Width (ms)')
ylim([0 1500])
subplot(5, 3, 5)
histogram(peakH)
title('Height (uV)')
ylim([0 1500])
subplot(5, 3, 6)
histogram(prom)
title('Prom.')
ylim([0 1500])
    
subplot(5, 3, [7 8 9])
plot(DetTime_ABS_s/3600, smooth(peakH, 60), 'k')
axis tight
ylim([100 400])

subplot(5, 3, [10 11 12])
plot(DetTime_ABS_s/3600, smooth(peakW_ms, 60), 'k')
axis tight
ylim([20 80])
xlabel('Time (Hr)')

subplot(5, 3, [13 14 15])
plot(peakW_ms, peakH, 'k.')
xlabel('Peak width')
ylabel('Peak height')

plot_filename = [plotDir 'SWRStatistics'];


plotpos = [0 0 15 25];
print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
%print_in_A4(0, plot_filename, '-depsc', 0, plotpos);

%% Look at outliers

%{
smallPeaks = find(peakW_ms < 36.5);

for oo = 1:numel(smallPeaks)
    thisSeg_BP = BP_DataSegs{smallPeaks(oo)};
    %thisSeg_BP = BPDataSegs{smallPeaks(oo)};
    
    timepoints = 1:1:numel(thisSeg_BP );
    timepoints_s = timepoints/Fs_orig;
    
    figure(253); clf
    %subplot(4, 1, 1)
    plot(timepoints_s, thisSeg_BP)
    disp('')
    pause
end
%}
    
%% A - Raw Data

 thisSeg_BP = BP_DataSegs{1};
  timepoints = 1:1:numel(thisSeg_BP );
    timepoints_s = timepoints/Fs_orig;
    
timestamps_ms = timepoints_s*1000;

%%
figH = figure (102); clf;
subplot(5, 1, 1)
plotInd = 8000; %6

plot(timestamps_ms,BP_DataSegs{plotInd,:}, 'k');
hold on
plot(timestamps_ms,SW_DataSegs{plotInd,:}, 'r');

xtickLabs = [-200 -100 0 100 200];
set(gca, 'xticklabel', xtickLabs)
xlabel('Time (ms)')
title (['n = ' num2str(size(BP_DataSegs, 1)) ' SWs'])

%
subplot(5, 1, 2)
plot(timestamps_ms,SWHF_DataSegs{plotInd,:}, 'k');
ylim([-40 40])
set(gca, 'xticklabel', xtickLabs)
%%
binsSize_ms = 1;
binsSize_samps = binsSize_ms/1000*Fs_orig;
HFI = [];
cnt = 1;
for j = 5000:7000
%for j = 1:size(SWHF_DataSegs, 1)
    
    bla = buffer(SWHF_DataSegs{j,:}, binsSize_samps);
    absBla = abs(bla);
    HFI(cnt ,:) = sum(absBla, 1)/binsSize_samps;
    cnt = cnt+1;
    
end

subplot(5, 1, 3)
cla
imagesc(HFI, [0 40])
%colorbar('location', 'eastoutside')

%%
%allBP_samps = vertcat(all_BP_data{:});

allSWSegs = horzcat(SW_DataSegs{:});
meanSW = nanmean(allSWSegs, 2);
medianSW = nanmedian(allSWSegs, 2);
%stdSW = nanstd(allSWSegs, 2);
%semSW = stdSW/sqrt(size(allSWSegs,1));

%%

subplot(5, 1, 4)
plot(timestamps_ms,meanSW);
hold on
%jbfill(timestamps_ms,[meanSW+semSW],[meanSW-semSW],[.5,0.5,.5],[.5,0.5,.5],[],.3);
hold on;
plot(timestamps_ms,medianSW, 'k');
%jbfill(timestamps_ms,[medianSW+semSW],[medianSW-semSW],[.5,0.5,.5],[.5,0.5,.5],[],.3);
axis tight
xlim([0 200])
ylim([-300 150])
set(gca, 'xticklabel', xtickLabs)
line([100 100], [-300 150], 'color', 'k')

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
tic
save(DetectionSaveName, 'FD', 'H', 'W', 'T', 'P', '-v7.3');
disp(['Saved:' DetectionSaveName ])
toc


end
