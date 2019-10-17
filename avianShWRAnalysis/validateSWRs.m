function []  = validateSWRs()
dbstop if error

pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\17-51-46__SWR-Detections';
fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Ephys\106_CH15.continuous';
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


%% Histograms of peak height and width
% Height
maxH = max(sw_peakH);
minH = min(sw_peakH);

binsC = minH:5:maxH;
figure(100);clf
histogram(sw_peakH, binsC, 'FaceColor', 'k', 'EdgeColor', 'k');
meanH = mean(sw_peakH);
medianH = median(sw_peakH);
hold on
plot(medianH, 0, 'rv')
plot(meanH, 0, 'bv')
title('Sharp Wave Height (uV)')

% Wifth
peakW_ms = (sw_peakW/Fs)*1000;

maxH = max(peakW_ms);
minH = min(peakW_ms);

binsC = minH:2:maxH;
figure(102);clf
histogram(peakW_ms, binsC, 'FaceColor', 'k', 'EdgeColor', 'k');
meanW = mean(peakW_ms);
medianW = median(peakW_ms);
hold on
plot(medianW, 0, 'rv')
plot(meanW, 0, 'bv')
title('Sharp Wave Width (ms)')

% Scatterplot
figure(103);clf
plot(sw_peakH, peakW_ms, 'k.');
ylim([0 200])
xlim([0 500])

%% Look over ripples and find which Sharp waves

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


%% Go over all Shs and look for ripples

peakWinL = 0.03*Fs;
peakWinR = 0.03*Fs;

%[V_uV_data_full,nshifts] = shiftdim(data',-1);

%thisSegData = V_uV_data_full(:,:,:);
%thisSegData_s = timestamps(1:end) - timestamps(1);

%DataSeg_BP = fobj.filt.BP.getFilteredData(thisSegData);
%DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
%DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(thisSegData));

allSW = [];
allSWR = [];
cnt = 1;
cnnt = 1;

for j = 1:numel(sw_peakTime_fs)
    
    sw_thisPeak_fs = sw_peakTime_fs(j);
    
    checkL = sw_thisPeak_fs-peakWinL;
    checkR = sw_thisPeak_fs+peakWinL;
    
    %bla = numel(spks(spks >= postSpontWin_4(1) & spks <= postSpontWin_4(end)));
    match = numel(rip_peakTime_fs(rip_peakTime_fs >= checkL & rip_peakTime_fs <= checkR));
    
    if match == 1 % 1 SW, 1 ripple
        
        allSWR(cnt) = sw_thisPeak_fs;
        cnt = cnt+1;
        
    elseif match > 1
        times_fs = rip_peakTime_fs(rip_peakTime_fs >= checkL & rip_peakTime_fs <= checkR);
        diffTimes_ms= (diff(times_fs)/Fs)*1000;
        
        if diffTimes_ms <50 % take the first time
            peakTodelete =times_fs(2);
            bla = find(rip_peakTime_fs ==peakTodelete);
            rip_peakTime_fs(bla) = [];
            
            allSWR(cnt) = sw_thisPeak_fs;
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
        
        allSW (cnnt) = sw_thisPeak_fs;
        cnnt = cnnt+1;
        
    end
    
end


saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\';

saveName = 'vDetections.mat';

save([saveDir saveName], 'allSWR', 'allSW')
    
  
%% Loading Data




%% FInd all detections that are withing 10 ms of eachotehr

TF = find(isoutlier(peakW_ms));


outlierWidths = peakW_ms(TF);

peaks = peakTime_fs;

%%

for j = 1:numel(allSWR)
    
    
    peakWinL = 0.1*Fs;
    peakWinR = 0.1*Fs;
    
    %currentPeakInd = TF(j);
    
    currentPeak = allSWR(j);
    
    %roi = peaks(currentPeakInd)-peakWinL:peaks(currentPeakInd)+peakWinR;
    roi = currentPeak-peakWinL:currentPeak+peakWinR;

    
    FNotch_roi = DataSeg_FNotch(roi);
    HF_roi = DataSeg_HF(roi);
    roi_s = thisSegData_s(roi);
    
    figH = figure(300);
    figure(figH); clf;
    
    subplot(1, 3, 1)
    plot(roi_s, FNotch_roi)
    hold on;
    plot(roi_s, HF_roi, 'k')
    axis tight
    %line([ thisSegData_s(peaks(currentPeakInd)) thisSegData_s(peaks(currentPeakInd))], [-300 100])
    line([ thisSegData_s(peaks(currentPeakInd)) thisSegData_s(peaks(currentPeakInd))], [-300 100])
    text(roi_s(4000), 80, num2str(currentPeakInd), 'color', 'r')
    
    
    %allPeakInds = getappdata(figH, 'allPeakInds');
    %currentPeakInd = getappdata(figH, 'currentPeakInd');
    
    %if ismember(currentPeakInd,  allPeakInds)
    %    title('Saved')
    %else
    %    title('Not Saved')
    %end
    
    LongRoi = peaks(currentPeakInd)-5*peakWinL:peaks(currentPeakInd)+5*peakWinR;
    
    if LongRoi(1) >0
        FNotch_LongRoi = DataSeg_FNotch(LongRoi);
        HF_LongRoi = DataSeg_HF(LongRoi);
        roi_LongRoi_s = thisSegData_s(LongRoi);
        
        subplot(1, 3, [2 3])
        plot(roi_LongRoi_s, FNotch_LongRoi)
        hold on;
        plot(roi_LongRoi_s, HF_LongRoi, 'k')
        axis tight
        line([ thisSegData_s(peaks(currentPeakInd)) thisSegData_s(peaks(currentPeakInd))], [-300 100])
    else
        subplot(1, 3, [2 3])
    end

    pause
end





end



