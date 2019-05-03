function [] = batchPlotDataForOpenEphys()
dbstop if error

addpath(genpath('/home/janie/Code/code2018/'))
dirD = '/';

%% Chick 9
baseDir = '/home/janie/BlackBox-Work/Work/TUM/Data/Chicken_ShWRs/ChickeSleepData/';

FileNames = {
    'Chick9_2019-03-28_11-42-04/';
    'Chick9_2019-03-28_18-39-42/';
    'Chick9_2019-03-28_12-33-32/';
    'Chick9_2019-03-28_13-05-51/';
    'Chick9_2019-03-28_13-26-20/';
    'Chick9_2019-03-28_13-57-43/';
    'Chick9_2019-03-28_14-41-42/';
    'Chick9_2019-03-28_14-43-07/';
    'Chick9_2019-03-28_15-20-50/';
    'Chick9_2019-03-28_15-57-47/';
    'Chick9_2019-03-28_16-27-28/';
    'Chick9_2019-03-28_16-44-32/';
    'Chick9_2019-03-28_17-25-40/';
    'Chick9_2019-03-28_17-57-40/';
    'Chick9_2019-03-28_18-37-24/';
    'Chick9_2019-03-28_18-39-42/';
    'Chick9_2019-03-28_19-10-15/';
    'Chick9_2019-03-28_19-30-47/';
    'Chick9_2019-03-28_19-41-23/';
    'Chick9_2019-03-28_19-43-07/';
    'Chick9_2019-03-28_20-14-20/';
    'Chick9_2019-03-28_20-47-41/';
    'Chick9_2019-03-28_21-19-01/';
    'Chick9_2019-03-28_21-50-29/';
    };

nFiles = numel(FileNames);

fileAppend = '100_CH10.continuous';

saveDir = ['/home/janie/BlackBox-Work/Work/TUM/Data/Chicken_ShWRs/ChickeSleepData/Analysis/'];

for o =1:nFiles
    
    fileName = [baseDir FileNames{o} fileAppend];
    [pathstr,name,ext] = fileparts(fileName);
    bla = find(fileName == dirD);
    dataName = fileName(bla(end-1)+1:bla(end)-1);
    %saveName = [pathstr dirD dataName '-fullData'];
    [data, timestamps, info] = load_open_ephys_data(fileName);
    Fs = info.header.sampleRate;
    
    fObj = filterData(Fs);
    
    %% Filters
    
    fobj.filt.FL=filterData(Fs);
    %fobj.filt.FL.lowPassPassCutoff=4.5;
    %fobj.filt.FL.lowPassPassCutoff=20;
    %fobj.filt.FL.lowPassStopCutoff=30;
    fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
    fobj.filt.FL.lowPassStopCutoff=40;
    fobj.filt.FL.attenuationInLowpass=20;
    fobj.filt.FL=fobj.filt.FL.designLowPass;
    fobj.filt.FL.padding=true;
    
    fobj.filt.FH2=filterData(Fs);
    fobj.filt.FH2.highPassCutoff=100;
    fobj.filt.FH2.lowPassCutoff=2000;
    fobj.filt.FH2.filterDesign='butter';
    fobj.filt.FH2=fobj.filt.FH2.designBandPass;
    fobj.filt.FH2.padding=true;
    
    fobj.filt.FN =filterData(Fs);
    fobj.filt.FN.filterDesign='cheby1';
    fobj.filt.FN.padding=true;
    fobj.filt.FN=fobj.filt.FN.designNotch;
    
    %%
    
    [V_uV_data_full,nshifts] = shiftdim(data',-1);
    
    thisSegData = V_uV_data_full(:,:,:);
    thisSegData_s = timestamps(1:end) - timestamps(1);
    recordingDuration_s = thisSegData_s(end);
    
    seg=40;
    TOn=1:seg*Fs:(recordingDuration_s*Fs-seg*Fs);
    overlapWin = 2*Fs;
    
    nCycles = numel(TOn);
    
    cnt = 1;
    
    for i=1:nCycles-1
        
        if i ==1
            thisROI = TOn(i):TOn(i+1);
        else
            thisROI = TOn(i)-overlapWin:TOn(i+1);
        end
        
        SegData = V_uV_data_full(:,:, thisROI);
        SegData_s = thisSegData_s(thisROI);
        
        DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(SegData));
        DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(SegData));
        DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(SegData));
        Data_SegData = squeeze(SegData);
        %%
        smoothWin = 0.10*Fs;
        DataSeg_LF_neg = -DataSeg_LF;
        %figure; plot(DataSeg_LF_neg)
        DataSeg_rect_HF = smooth(DataSeg_HF.^2, smoothWin);
        %baseline = mean(DataSeg_rect_HF)*2;
        
        %figure; plot(SegData_s, DataSeg_rect_HF); axis tight
        
        %% Find Peaks
        %  interPeakDistance = 0.3*Fs;
        %  minPeakWidth = 0.075*Fs;
        %  minPeakHeight = 300;
        %  minPeakProminence = 300;
        
        %  [peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth, 'MinPeakProminence',minPeakProminence, 'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
        
        
        %  absPeakTime_s =  SegData_s(peakTime_Fs);
        %  asPeakTime_fs = peakTime_Fs+thisROI(1)-1;
        % relPeakTime_s  = peakTime_Fs;
        
        %%
        
        figure(100);clf;
        
        subplot(5,1,1)
        plot(SegData_s, Data_SegData); %title( ['Raw Voltage']);
        axis tight
        ylim([-3000 3000])
        title(['Raw Voltage: ' FileNames{o}(1:end-1) ' | ' sprintf('%03d', i)])
        
        subplot(5, 1, 2)
        plot(SegData_s, DataSeg_FNotch); title( ['Notch Filter']);
        axis tight
        ylim([-3000 3000])
        
        subplot(5, 1, 3)
        plot(SegData_s, DataSeg_LF); title( ['LF']);
        axis tight
        ylim([-3000 3000])
        
        subplot(5, 1, 4)
        plot(SegData_s, DataSeg_rect_HF); title( ['HF Rectified']);
        axis tight
        ylim([0 2000])
        
        subplot(5, 1, 5)
        plot(SegData_s, DataSeg_HF); title( ['HF Rectified']);
        axis tight
        ylim([-300 300])
        
        
        saveName = [saveDir FileNames{o}(1:end-1) '_' sprintf('%03d', i)];
        
        
        %saveName = [saveDir 'Chick2_16-30-56_rippleWidthHist'];
        %saveName = [saveDir 'Chick2_17-05-32_rippleWidthHist'];
        %saveName = [saveDir 'Chick2_17-29-04_rippleWidthHist'];
        %saveName = [saveDir 'Chick2_17-56-36_rippleWidthHist'];
        
        plotpos = [0 0 30 15];
        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
        %print_in_A4(0, saveName, '-depsc', 0, plotpos);
    end
    
end

end
