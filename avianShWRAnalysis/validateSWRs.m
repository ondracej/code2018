function []  = validateSWRs()
dbstop if error
%% Acute








%% Chronic
% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190917\09-00-29\Analysis\09-00-29__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190917\09-00-29\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190917\09-00-29\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190917\09-00-29\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Analysis\18-04-28__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Analysis\18-21-42__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Analysis\18-37-00__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Analysis\18-05-58__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Analysis\';

pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\17-51-46__SWR-Detections.mat';
fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Ephys\106_CH15.continuous';
plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Plots\';
saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Analysis\16-05-11__SWR-Detections.mat';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Analysis\';

dirD = '\';


s = load(pathToSWRDetections);

Ripple = s.Ripple;
SW = s.SW;


[pathstr,name,ext] = fileparts(fileName);
bla = find(fileName == dirD);
dataName = fileName(bla(end-1)+1:bla(end)-1);
%saveName = [pathstr dirD dataName '-fullData'];
[data, timestamps, info] = load_open_ephys_data(fileName);
Fs = info.header.sampleRate;
disp('Fininshed loading...')
fObj = filterData(Fs);
thisSegData_s = timestamps(1:end) - timestamps(1);

%timeRangeOn = round(1.9*3600*Fs);
%timeRangeOff = round(2.5*3600*Fs);

%dataRange = data(timeRangeOn:timeRangeOff);
%dataSeg_S = thisSegData_s(timeRangeOn:timeRangeOff);
%figure; plot(dataSeg_S, dataRange)
%axis tight

%% Filters

% fobj.filt.FL=filterData(Fs);
% %fobj.filt.FL.lowPassPassCutoff=4.5;
% fobj.filt.FL.lowPassPassCutoff=8;
% fobj.filt.FL.lowPassStopCutoff=10;
% fobj.filt.FL.attenuationInLowpass=20;
% fobj.filt.FL=fobj.filt.FL.designLowPass;
% fobj.filt.FL.padding=true;

fobj.filt.FH2=filterData(Fs);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

fobj.filt.BP=filterData(Fs);
fobj.filt.BP.highPassCutoff=1;
fobj.filt.BP.lowPassCutoff=2000;
fobj.filt.BP.filterDesign='butter';
fobj.filt.BP=fobj.filt.BP.designBandPass;
fobj.filt.BP.padding=true;

fobj.filt.FN =filterData(Fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;

%%

%% SWs

sw_peakH_1 = SW.peakSW_H;
sw_peakTime_fs_1 = SW.absPeakTime_SW_fs; % first detection
sw_peakW_fs_1 = SW.peakSW_W; % at half prominence

% Use the verified 2nd detections
sw_peakTime_fs_2 = SW.absPeakTime_Fs_LF; % second detection
sw_peakH_2 = SW.peakH_SWcheck; % second detection
sw_peakW_2 = SW.peakW_SWcheck; % at half width

[C,UInds,ic] = unique(sw_peakTime_fs_2); % since we have an overlap, we have to get rid of all the double detections

sw_peakW = sw_peakW_2(UInds);
sw_peakH = sw_peakH_2(UInds);
sw_peakTime_fs = sw_peakTime_fs_2(UInds);

Fs = 30000;

%% Ripples

Rip_peakH_1 = Ripple.peakH;
Rip_peakTime_fs_1 = Ripple.asPeakTime_fs; % first detection
Rip_peakW_fs_1 = Ripple.peakW; % at half prominence

% Use the verified 2nd detections
rip_peakH_2 = Ripple.peakH_ripcheck; % second detection
rip_peakTime_fs_2 = Ripple.absPeakTime_Fs_LF; % second detection
rip_peakW_2 = Ripple.peakW_ripcheck; % at half width

[C,UInds,ic] = unique(rip_peakTime_fs_2); % since we have an overlap, we have to get rid of all the double detections

rip_peakW = rip_peakW_2(UInds);
rip_peakH = rip_peakH_2(UInds);
rip_peakTime_fs = rip_peakTime_fs_2(UInds);

%% Get rid of 10 ms overlaps ripples
FsWin = 10/1000 *Fs;

peakDiffs = diff(rip_peakTime_fs);
smallDiffs = find(peakDiffs <= FsWin);

rip_peakW_nDD  = rip_peakW;
rip_peakH_nDD  = rip_peakH;
rip_peakfs_nDD  = rip_peakTime_fs;

rip_peakW_nDD(smallDiffs+1) = [];
rip_peakH_nDD(smallDiffs+1) = [];
rip_peakfs_nDD(smallDiffs+1) = [];

%% Get rid of very large ripple peaks and small 


outliers_h_ind = find(rip_peakH_nDD >1500);

rip_peakH_nDD(outliers_h_ind) = [];
rip_peakW_nDD(outliers_h_ind) = [];
rip_peakfs_nDD(outliers_h_ind) = [];

outliers_h_ind = find(rip_peakH_nDD <115);

rip_peakH_nDD(outliers_h_ind) = [];
rip_peakW_nDD(outliers_h_ind) = [];
rip_peakfs_nDD(outliers_h_ind) = [];


%%


figure(102);clf

subplot(3, 1, 1); plot(rip_peakfs_nDD/Fs/3600, rip_peakH_nDD, 'k.'); axis tight; title('Ripple height')
subplot(3, 1, 2); plot(rip_peakfs_nDD/Fs/3600, rip_peakW_nDD/Fs*1000, 'k.'); axis tight; title('Ripple width')
subplot(3, 1, 3); plot(rip_peakH_nDD, rip_peakW_nDD/Fs*1000, 'k.'); axis tight; title('Ripple height vs width') 

%% Find all peaks that are within 10 ms of eachother;
FsWin = 10/1000 *Fs;

peakDiffs = diff(sw_peakTime_fs);
smallDiffs = find(peakDiffs <= FsWin);
    
    
    sw_peakW_nDD  = sw_peakW;
    sw_peakH_nDD  = sw_peakH;
    sw_peakfs_nDD  = sw_peakTime_fs;
    
    sw_peakW_nDD(smallDiffs+1) = [];
    sw_peakH_nDD(smallDiffs+1) = [];
    sw_peakfs_nDD(smallDiffs+1) = [];
    
   %% test for normal distribution

  
   
%% Find height and width outliers

outliers_h_ind = find(sw_peakH_nDD >430);

sw_peakH_nDD(outliers_h_ind) = [];
sw_peakW_nDD(outliers_h_ind) = [];
sw_peakfs_nDD(outliers_h_ind) = [];


outliers_h_ind = find(sw_peakH_nDD <85);

sw_peakH_nDD(outliers_h_ind) = [];
sw_peakW_nDD(outliers_h_ind) = [];
sw_peakfs_nDD(outliers_h_ind) = [];


%% Also look for SHWs smaller than 80 uV

outliers_w_ind = find(sw_peakW_nDD >= 0.120*Fs);
sw_peakH_nDD(outliers_w_ind) = [];
sw_peakW_nDD(outliers_w_ind) = [];
sw_peakfs_nDD(outliers_w_ind) = [];

%% Outliers
outliers_H_m = find(isoutlier(sw_peakH_nDD, 'median', 'ThresholdFactor', 6));
outliers_H_fs = sw_peakfs_nDD(outliers_H_m);
outliers_H_vals = sw_peakH_nDD(outliers_H_m);
outliers_H_Wvals = sw_peakW_nDD(outliers_H_m);

figure; plot(outliers_H_Wvals, outliers_H_vals, 'k*');

outliers_W_m = find(isoutlier(sw_peakW_nDD, 'median', 'ThresholdFactor', 5));
outliers_W_fs = sw_peakfs_nDD(outliers_W_m);
outliers_W_vals = sw_peakW_nDD(outliers_W_m);
outliers_W_Hvals = sw_peakH_nDD(outliers_W_m);

figure; plot(outliers_W_vals, outliers_W_Hvals, 'k*');

medianH = median(sw_peakH);
medianW_ms = median(sw_peakW/Fs)*1000;
stdH = std(sw_peakH)*6;
stdW = std((sw_peakW/Fs)*1000)*6;

%%

finalPeakTimes_fs = sw_peakfs_nDD;
finalPeakH = sw_peakH_nDD;
finalPeakW_fs = sw_peakW_nDD;

rip_peakTime_fs = rip_peakfs_nDD;


%% Go over all Shs and look for ripples

peakWinL = 0.03*Fs;
peakWinR = 0.03*Fs;

allSW_fs = []; allSWR_H = []; allSWR_W_fs = [];
allSWR_fs = []; allSW_H = []; allSW_W_fs = [];
allSWR_rips_fs = []; allSWR_rips_H = []; allSWR_rips_W = [];
cnt = 1;
cnnt = 1;

for j = 1:numel(finalPeakTimes_fs)
    
    sw_thisPeak_fs = finalPeakTimes_fs(j);
    
    checkL = sw_thisPeak_fs-peakWinL;
    checkR = sw_thisPeak_fs+peakWinR;
    
    match = numel(rip_peakTime_fs(rip_peakTime_fs >= checkL & rip_peakTime_fs <= checkR));
    if match == 1
        thisRipple_fs = rip_peakTime_fs(rip_peakTime_fs >= checkL & rip_peakTime_fs <= checkR);
        rippleInd = find(rip_peakTime_fs == thisRipple_fs(1));
    end
    if match == 1 % 1 SW, 1 ripple
        
        allSWR_fs(cnt) = sw_thisPeak_fs;
        allSWR_H(cnt) = finalPeakH(j);
        allSWR_W_fs(cnt) = finalPeakW_fs(j);
        
        allSWR_rips_fs(cnt) = thisRipple_fs;
        allSWR_rips_H(cnt) = rip_peakH_nDD(rippleInd);
        allSWR_rips_W(cnt) = rip_peakW_nDD(rippleInd);
        cnt = cnt+1;
        
    elseif match > 1
        times_fs = rip_peakTime_fs(rip_peakTime_fs >= checkL & rip_peakTime_fs <= checkR);
        diffTimes_ms= (diff(times_fs)/Fs)*1000;
        
        if diffTimes_ms <50 % take the first time
            peakTodelete =times_fs(2);
            bla = find(rip_peakTime_fs ==peakTodelete);
            rip_peakTime_fs(bla) = [];

            allSWR_fs(cnt) = sw_thisPeak_fs;
            allSWR_H(cnt) = finalPeakH(j);
            allSWR_W_fs(cnt) = finalPeakW_fs(j);
            
            allSWR_rips_fs(cnt) = thisRipple_fs;
            allSWR_rips_H(cnt) = rip_peakH_nDD(rippleInd);
            allSWR_rips_W(cnt) = rip_peakW_nDD(rippleInd);
            cnt = cnt+1;
            
        else
            
            disp('')
            
        end
        
        %{
        %roi = times_fs(1)-.1*Fs: times_fs(2)+.1*Fs;
        roi = sw_thisPeak_fs(1)-.1*Fs: sw_thisPeak_fs(1)+.1*Fs;
        
        thisData = data(roi);
        [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
        DataSeg_BP = fobj.filt.BP.getFilteredData(V_uV_data_full);
        DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
        DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(V_uV_data_full));

        figure(403); clf
        plot(DataSeg_HF);
        hold on
        %plot(times_fs-roi(1), 0, 'rv')
        plot(sw_thisPeak_fs-roi(1), 0, 'rv')
        plot(DataSeg_FNotch);
        axis tight
       
        %}
        disp('')
    elseif match == 0
        
        allSW_fs(cnnt) = sw_thisPeak_fs;
        allSW_H(cnnt) = finalPeakH(j);
        allSW_W_fs(cnnt) = finalPeakW_fs(j);
        cnnt = cnnt+1;
        
    end
    
end


allSWR.allSWR_fs = allSWR_fs;
allSWR.allSWR_H = allSWR_H;
allSWR.allSWR_W_fs = allSWR_W_fs;

allSWR_rips.allSWR_rips_fs = allSWR_rips_fs;
allSWR_rips.allSWR_rips_H = allSWR_rips_H;
allSWR_rips.allSWR_rips_W = allSWR_rips_W;

allSW.allSW_fs = allSW_fs;
allSW.allSW_H = allSW_H;
allSW.allSW_W_fs = allSW_W_fs;

saveName = 'vDetections.mat';
save([saveDir saveName], 'allSWR', 'allSWR_rips', 'allSW')
    
%% Plot of SWR over time

figure(103);clf

subplot(7, 1, [2 3] ); plot(allSWR_fs/Fs/3600, allSWR_H, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('SWR amplitude (uV)')
ylim([80 450])
subplot(7, 1, [5 6]); plot(allSWR_fs/Fs/3600, allSWR_W_fs/Fs*1000, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('SWR width (ms)')
ylim([1 150])

%subplot(13, 1, [8 9] ); plot(allSWR_rips_fs/Fs/3600, allSWR_rips_H, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('Ripple amplitude (uV)')
%subplot(13, 1, [11 12]); plot(allSWR_rips_fs/Fs/3600, allSWR_rips_W/Fs*1000, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('SWR width (ms)')

% Histograms
% Height
%{
maxH = max(allSWR_H);
minH = min(allSWR_H);

binsC_H = minH:5:maxH;

subplot(13, 1, [5 6])
histogram(allSWR_H, binsC_H, 'FaceColor', 'k', 'EdgeColor', 'k');
meanH = mean(allSWR_H);
medianH = median(allSWR_H);
hold on
plot(medianH, 0, 'rv')
plot(meanH, 0, 'bv')
title('SWR amplitude(uV)')

subplot(7, 5, [15 20]); 
[cx,cy]=hist(allSWR_H,binsC_H);
bla = cumsum(cx) ./ sum(cx);
hold on
plot(cy, (bla), 'linewidth', 2)
clear('cx','cy');

% Width
peakW_ms = (allSWR_W_fs/Fs)*1000;

maxH = max(peakW_ms);
minH = min(peakW_ms);

binsC_W = minH:2:maxH;
subplot(7, 5, [24 29]); 
histogram(peakW_ms, binsC_W, 'FaceColor', 'k', 'EdgeColor', 'k');
meanW = mean(peakW_ms);
medianW = median(peakW_ms);
hold on
plot(medianW, 0, 'rv')
plot(meanW, 0, 'bv')
title('SWR width (ms)')

subplot(7, 5, [25 30]); 
[cx,cy]=hist(peakW_ms,binsC_W);
bla = cumsum(cx) ./ sum(cx);
hold on
plot(cy, (bla), 'linewidth', 2)
clear('cx','cy');
%}

%% Plots of means over time

binSize_s = 1*60;
binSize_Fs = binSize_s*Fs;

TOns = 1:binSize_Fs:numel(data);
for j = 1:numel(TOns)-1
    theseV_inds =  find(allSWR_fs >= TOns(j) & allSWR_fs < TOns(j)+binSize_Fs);    
    theseV_vals = allSWR_H(theseV_inds);
    theseW_vals = allSWR_W_fs(theseV_inds);
    ShWMeanAmp(j) = mean(theseV_vals);
    ShWMeanWidth(j) = mean(theseW_vals)/Fs*1000;
    nWRs(j) = numel(theseV_inds);
    rate(j) = nWRs(j)/60;
    
end

SWR_rate = nWRs/binSize_s;
   rate(j) = nWRs(j)/60;
smoothWin = 5;
subplot(7, 1, [1] );
plot(smooth(ShWMeanAmp, smoothWin));
%plot(ShWMeanAmp);
axis tight

subplot(7, 1, [4] );
plot(smooth(ShWMeanWidth, smoothWin));
axis tight

subplot(7, 1, [7] );
plot(smooth(rate));
axis tight



%% plotting lines for the awake vs sleep

TimeROi_awake_fs = [1 2*3600*Fs];
%TimeROi_sleep_s = [6*3600 7*3600];
TimeROi_sleep_s = [6*3600 8*3600];
TimeROi_sleep_fs = TimeROi_sleep_s*Fs;

subplot(7, 1, [2 3] ); 
hold on
yss = ylim;
line([TimeROi_awake_fs(1)/Fs/3600 TimeROi_awake_fs(1)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_awake_fs(2)/Fs/3600 TimeROi_awake_fs(2)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_sleep_fs(2)/Fs/3600 TimeROi_sleep_fs(2)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_sleep_fs(1)/Fs/3600 TimeROi_sleep_fs(1)/Fs/3600], [yss(1) yss(2)], 'color', 'r')

subplot(7, 1, [5 6]);
yss = ylim;
line([TimeROi_awake_fs(1)/Fs/3600 TimeROi_awake_fs(1)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_awake_fs(2)/Fs/3600 TimeROi_awake_fs(2)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_sleep_fs(2)/Fs/3600 TimeROi_sleep_fs(2)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_sleep_fs(1)/Fs/3600 TimeROi_sleep_fs(1)/Fs/3600], [yss(1) yss(2)], 'color', 'r')

%% Print plot

saveName = [plotDir  'SWRAmplWidthScatterTimePLots'];
plotpos = [0 0 40 20];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%% Collecting awake vs Sleep data
  theseV_awake_inds =  find(allSWR_fs >= TimeROi_awake_fs(1) & allSWR_fs < TimeROi_awake_fs(2)); 
  theseV_sleep_inds =  find(allSWR_fs >= TimeROi_sleep_fs(1) & allSWR_fs < TimeROi_sleep_fs(2));

  awakeVs = allSWR_H(theseV_awake_inds);
 awakeWs = allSWR_W_fs(theseV_awake_inds);

 sleepVs = allSWR_H(theseV_sleep_inds);
 sleepWs = allSWR_W_fs(theseV_sleep_inds);
 
  

%% Scatter Hist plots all data

 
 
n5_sTo8_s = 15+8*60+2*60;

nightOn = n5_sTo8_s*Fs;
nightOff = nightOn+12*3600*Fs;

theseDark_inds =  find(allSWR_fs >= nightOn & allSWR_fs < nightOff); 
theseDark_Fs =  allSWR_fs(theseDark_inds);
theseDark_H =  allSWR_H(theseDark_inds);
allSWRDark_W_ms =  allSWR_W_fs(theseDark_inds)/Fs*1000;

%%
figure(310);clf; 

selInds = randperm(numel(theseDark_Fs));
sel = selInds(1:5000);
% subplot(2, 1, 1)
% plot(allSWR_H, allSWR_W_fs/Fs*1000, 'k.'); axis tight; xlabel('SWR amplitude (uV)');ylabel('SWR width (ms)')
% ylim([0 150])
% xlim([80 450])
%
%%
h = scatterhist(theseDark_H(sel),allSWRDark_W_ms(sel),'Kernel','on', 'Location','SouthEast',...
    'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'color', 'k');

hold on;
boxplot(h(2),theseDark_H(sel),'orientation','horizontal',...
    'label',{''},'color','k', 'plotstyle', 'compact', 'Whisker', 10);

boxplot(h(3),allSWRDark_W_ms(sel),'orientation','horizontal',...
    'label', {''},'color','k', 'plotstyle', 'compact', 'Whisker', 10);
view(h(3),[270,90]);  % Rotate the Y plot
axis(h(1),'auto');  % Sync axes
hold off;


medianDarkH = median(theseDark_H);
medianDarkH_sem = (std(theseDark_H))/(sqrt(numel(theseDark_H)));

medianDarkW = median(allSWRDark_W_ms);
medianDarkW_sem = (std(allSWRDark_W_ms))/(sqrt(numel(allSWRDark_W_ms)));



medianDarkH = median(theseDark_H(sel));
medianDarkH_sem = (std(theseDark_H(sel)))/(sqrt(numel(theseDark_H(sel))));

medianDarkW = median(allSWRDark_W_ms(sel));
medianDarkW_sem = (std(allSWRDark_W_ms(sel)))/(sqrt(numel(allSWRDark_W_ms(sel))));



saveName = [plotDir  'SWRDark_AmplWidthScatterPlots_hist'];

plotpos = [0 0 12 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

  [h, p] = lillietest(theseDark_H);
   [h, p] = lillietest(allSWRDark_W_ms);
   
   %%
   [h, p] = lillietest(log(theseDark_H));
   [h, p] = lillietest(log(allSWRDark_W_ms));
   [h, p] = lillietest(log(awakeWs));
   [h, p] = lillietest(log(sleepWs));
   
%% Scatter Hist plots awake sleep data

figure(311);clf; 

group1 = ones(1, numel(awakeVs))*1;
group2 = ones(1, numel(sleepVs))*2;

sleepWs_ms = sleepWs/Fs*1000;

[pp, hh] = ranksum(theseDark_H(sel), sleepVs);
    [pp, hh] = ranksum(allSWRDark_W_ms(sel), sleepWs_ms);
    

medianAwakeH = median(awakeVs);
medianAwakeH_sem = (std(awakeVs))/(sqrt(numel(awakeVs)));

medianAwakeW = median(awakeWs/Fs*1000);
medianAwakeW_sem = (std(awakeWs/Fs*1000))/(sqrt(numel(awakeWs/Fs*1000)));


medianSleepH = median(sleepVs);
medianSleepH_sem = (std(sleepVs))/(sqrt(numel(sleepVs)));

medianSleepW = median(sleepWs/Fs*1000);
medianSleepW_sem = (std(sleepWs/Fs*1000))/(sqrt(numel(sleepWs/Fs*1000)));

%%



groups = [group1 group2];
xes = [awakeVs sleepVs];
yes = [awakeWs/Fs*1000 sleepWs/Fs*1000];
h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
    'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'color', [clr(2,:); clr(1,:)]);


hold on;
%clr = get(h(1),'colororder');
boxplot(h(2),xes,groups,'orientation','horizontal',...
    'label',{'',''},'color',[clr(2,:); clr(1,:)], 'plotstyle', 'compact', 'Whisker', 10);
boxplot(h(3),yes,groups,'orientation','horizontal',...
    'label', {'',''},'color',[clr(2,:); clr(1,:)], 'plotstyle', 'compact', 'Whisker', 10);
%set(h(2:3),'XTickLabel','');
view(h(3),[270,90]);  % Rotate the Y plot
axis(h(1),'auto');  % Sync axes
hold off;



saveName = [plotDir  'SWRAmplWidthScatterPlots_AwakeSleep_hist'];

plotpos = [0 0 12 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

%% Statistics

 [h, p] = kstest(awakeVs);
   [h, p] = kstest(sleepVs);
   [h, p] = kstest(awakeWs);
   [h, p] = kstest(sleepWs);
   
   [h, p] = lillietest(awakeVs);
   [h, p] = lillietest(sleepVs);
   [h, p] = lillietest(awakeWs);
   [h, p] = lillietest(sleepWs);
   
   %%
   [h, p] = lillietest(log(awakeVs));
   [h, p] = lillietest(log(sleepVs));
   [h, p] = lillietest(log(awakeWs));
   [h, p] = lillietest(log(sleepWs));
   
   
  [h, p] = ttest2(awakeVs, sleepVs);
    [pp, hh] = ranksum(awakeVs, sleepVs);
    [pp, hh] = ranksum(awakeWs, sleepWs);
    
    
    
  
  subplot(6, 5, [9 14]); 
     boxplot(awakeVs, 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.3, 'colors', [0 0 0], 'labels', 'Awake Amplitude')
  ylim([80 450])  
  title(['n=' num2str(numel(awakeVs))])
  subplot(6, 5, [10 15]); 
     boxplot(sleepVs, 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.3, 'colors', [0 0 0], 'labels', 'sleep Amplitude')
  title(['n=' num2str(numel(sleepVs))])
     ylim([80 450])
  
  
    [h, p] = ttest2(awakeWs, sleepWs);
    [pp, hh] = ranksum(awakeWs, sleepWs);
  
    subplot(6, 5, [24 29]); 
     boxplot(awakeWs, 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.3, 'colors', [0 0 0], 'labels', 'Awake Width')
 % ylim([80 450])  
  title(['n=' num2str(numel(awakeVs))])
  subplot(6, 5, [25 30]); 
     boxplot(sleepWs, 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.3, 'colors', [0 0 0], 'labels', 'sleep Width')
  title(['n=' num2str(numel(sleepVs))])
   %  ylim([80 450])


  %%
%   plot(awakeVs, awakeWs/Fs*1000, 'r.');
%   hold on
%   plot(-sleepVs, sleepWs/Fs*1000, 'b.');
%   hold on
%   
  
  
%% Histograms
% Height
  figure(310);clf; 

maxH = max(awakeVs);
minH = min(awakeVs);

binsC_H = minH:5:maxH;

subplot(2, 2, [1]); 
histogram(awakeVs, binsC_H, 'FaceColor', 'k', 'EdgeColor', 'k');
meanH = mean(awakeVs);
medianH = median(awakeVs);
hold on
plot(medianH, 0, 'rv')
plot(meanH, 0, 'bv')
title('SWR amplitude(uV)')

subplot(2, 2, [3]); 
histogram(sleepVs, binsC_H, 'FaceColor', 'k', 'EdgeColor', 'k');
meanH = mean(sleepVs);
medianH = median(sleepVs);
hold on
plot(medianH, 0, 'rv')
plot(meanH, 0, 'bv')


[cx,cy]=hist(allSWR_H,binsC_H);
bla = cumsum(cx) ./ sum(cx);
hold on
plot(cy, (bla), 'linewidth', 2)
clear('cx','cy');

% Width
peakW_ms = (allSWR_W_fs/Fs)*1000;

maxH = max(peakW_ms);
minH = min(peakW_ms);

binsC_W = minH:2:maxH;
subplot(7, 5, [24 29]); 
histogram(peakW_ms, binsC_W, 'FaceColor', 'k', 'EdgeColor', 'k');
meanW = mean(peakW_ms);
medianW = median(peakW_ms);
hold on
plot(medianW, 0, 'rv')
plot(meanW, 0, 'bv')
title('SWR width (ms)')

subplot(7, 5, [25 30]); 
[cx,cy]=hist(peakW_ms,binsC_W);
bla = cumsum(cx) ./ sum(cx);
hold on
plot(cy, (bla), 'linewidth', 2)
clear('cx','cy');


%% Checcking outliers

outlierToCheck_fs = outliers_W_fs;
valsToUse = outliers_W_vals/Fs*1000;

for j = 1:numel(outlierToCheck_fs)
    
    
    peakWinL = 0.1*Fs;
    peakWinR = 0.1*Fs;
    
    %currentPeakInd = TF(j);
    
    currentPeak = outlierToCheck_fs(j);
    
    %roi = peaks(currentPeakInd)-peakWinL:peaks(currentPeakInd)+peakWinR;
    roi = currentPeak-peakWinL:currentPeak+peakWinR;
    roi_s = thisSegData_s(roi);
    thisData = data(roi);
    [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
    DataSeg_BP = fobj.filt.BP.getFilteredData(V_uV_data_full);
    DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
    DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(V_uV_data_full));
    
    
    figH = figure(300);
    figure(figH); clf;
    
    subplot(1, 3, 1)
    plot(roi_s, DataSeg_FNotch)
    hold on;
    plot(roi_s, DataSeg_HF, 'k')
    
    %line([ thisSegData_s(peaks(currentPeakInd)) thisSegData_s(peaks(currentPeakInd))], [-300 100])
    line([ thisSegData_s(currentPeak) thisSegData_s(currentPeak)], [-500 500], 'color', 'r')
    %text(roi_s(4000), 80, num2str(currentPeakInd), 'color', 'r')
    axis tight
    
    %allPeakInds = getappdata(figH, 'allPeakInds');
    %currentPeakInd = getappdata(figH, 'currentPeakInd');
    
    %if ismember(currentPeakInd,  allPeakInds)
    %    title('Saved')
    %else
    %    title('Not Saved')
    %end
    
    LongRoi =currentPeak-10*peakWinL:currentPeak+10*peakWinR;
    
    roi_s = thisSegData_s(LongRoi);
    thisData = data(LongRoi);
    [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
    DataSeg_BP = fobj.filt.BP.getFilteredData(V_uV_data_full);
    DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
    DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(V_uV_data_full));
    
    
    if LongRoi(1) >0
        %         FNotch_LongRoi = DataSeg_FNotch(LongRoi);
        %         HF_LongRoi = DataSeg_HF(LongRoi);
        %         roi_LongRoi_s = thisSegData_s(LongRoi);
        
        subplot(1, 3, [2 3])
        plot(roi_s, DataSeg_FNotch)
        hold on;
        plot(roi_s, DataSeg_HF, 'k')
        
        line([ thisSegData_s(currentPeak) thisSegData_s(currentPeak)], [-500 500], 'color', 'r')
        axis tight
        title(['Val = ' num2str(valsToUse(j))])
    else
        subplot(1, 3, [2 3])
    end
    
    pause
end



end



