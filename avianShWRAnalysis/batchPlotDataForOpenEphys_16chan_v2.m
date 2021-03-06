function [] = batchPlotDataForOpenEphys_16chan_v2()
dbstop if error
close all

addpath(genpath('/home/janie/Code/code2018/'))
dirD = '\';

%% Chick 9

%baseDir = '/media/janie/Data64GB/ZF-59-15/';
%baseDir = '/home/janie/Data/chick10/';

%baseDir = '/media/janie/Data64GB/ZF-60-88/';

% FileNames = {
%    'exp1_2019-04-28_18-07-21/';
%    'exp1_2019-04-28_18-48-02/';
%    'exp1_2019-04-28_19-34-00/';
%    'exp1_2019-04-28_20-20-36/';
%    'exp1_2019-04-28_21-05-36/';
%    };


% FileNames  = {
%    'Chick10_2019-04-27_22-20-26/';
%    };


%FileNames  = {
%   'exp1_2019-04-29_20-42-10/';
%   };


baseDir = 'C:\Users\Administrator\Documents\Data\SWR-Project\ZF-72-81\';
chanSet = [9 10 11 13 14 15 16 2 3 6 7]; % can load 4 channels before memory crashes

FileNames  = {
   'eeg-lfp_2019-05-16_19-18-21\';
   'eeg-lfp_2019-05-16_19-54-11\';
   'eeg-lfp_2019-05-16_20-05-43\';
   'eeg-lfp_2019-05-16_20-42-00\';
   'eeg-lfpChronic_2019-05-16_21-14-10\';
   'eeg-lfpChronic_2019-05-16_21-26-59\';
   'eeg-lfpChronic_2019-05-16_23-00-39\'
   'eeg-lfpChronic_2019-05-16_23-09-34\';
   'eeg-lfpChronic_2019-05-16_23-21-04\';
};


nFiles = numel(FileNames);

saveDir = ['C:\Users\Administrator\Documents\Data\SWR-Project\Analysis\ZF-72-81\'];

%nChans =16;
%chanSet = [6 11 3 14 1 16 2 15 5 12 4 13 7 10 8 9];

for o =5:nFiles
    
    fileAppend = '100_CH10.continuous';
    
    fileName = [baseDir FileNames{o} fileAppend];
    [pathstr,name,ext] = fileparts(fileName);
    bla = find(fileName == dirD);
    dataName = fileName(bla(end-1)+1:bla(end)-1);
    %saveName = [pathstr dirD dataName '-fullData'];
    [data, timestamps, info] = load_open_ephys_data(fileName);
    Fs = info.header.sampleRate;
    
    thisSegData_s = timestamps(1:end) - timestamps(1);
    recordingDuration_s = thisSegData_s(end);
    
    seg=40;
    TOn=1:seg*Fs:(recordingDuration_s*Fs-seg*Fs);
    overlapWin = 2*Fs;
    
    nCycles = numel(TOn);
    
    figure(100); clf
    figure(101); clf
    figure(102); clf
    figure(103); clf
    
    csccnt = 1;
    
    for i=1:nCycles-1
    
        offsetLP = 0;
        offsetHP = 0;
        offsetHP_R = 0;
        
        CDC_AllData = [];
        for s = chanSet
            
            %fileAppend = '100_CH10.continuous';
            
            eval(['fileAppend = ''100_CH' num2str(s) '.continuous'';'])
            
            fileName = [baseDir FileNames{o} fileAppend];
            [pathstr,name,ext] = fileparts(fileName);
            bla = find(fileName == dirD);
            dataName = fileName(bla(end-1)+1:bla(end)-1);
            %saveName = [pathstr dirD dataName '-fullData'];
            [data, timestamps, info] = load_open_ephys_data(fileName);
            Fs = info.header.sampleRate;
            
            thisSegData_s = timestamps(1:end) - timestamps(1);
            
            %%
            
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
            %cnt = 1;
            
            [V_uV_data_full,nshifts] = shiftdim(data',-1);
            
            thisSegData = V_uV_data_full(:,:,:);
            
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
            
            CDC_AllData(:,csccnt) = Data_SegData;
            
            csccnt = csccnt +1;
            
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
            
            FigHRaw = figure(100); hold on
            
            %subplot(5,1,1)
            plot(SegData_s, Data_SegData + offsetLP); %title( ['Raw Voltage']);
            axis tight
            %ylim([-300 200])
            title(['Raw Voltage: ' FileNames{o}(1:end-1) ' | ' sprintf('%03d', i)])
            
            %subplot(5, 1, 2)
            %plot(SegData_s, DataSeg_FNotch + offsetLP); title( ['Notch Filter']);
            %axis tight
            %ylim([-300 200])
            
            %%
            FigHLD = figure(101); hold on
            
            %subplot(5, 1, 3)
            plot(SegData_s, DataSeg_LF + offsetLP); title( ['LF']);
            axis tight
            %ylim([-300 200])
            
            %%
            FigHHighRect = figure(102); hold on
            
            %subplot(5, 1, 4)
            plot(SegData_s, DataSeg_rect_HF + offsetHP_R); title( ['HF Rectified']);
            axis tight
            %ylim([50 150])
            %%
            FigHHigh = figure(103); hold on
            %subplot(5, 1, 5)
            plot(SegData_s, DataSeg_HF + offsetHP); title( ['HF']);
            axis tight
            %ylim([-100 100])
            
%             offsetLP  = offsetLP +300;
%             offsetHP  = offsetHP +100;
            
            offsetLP  = offsetLP +100;
            offsetHP  = offsetHP +30;
            offsetHP_R  = offsetHP_R +10;
            
        end
        
        
        %%
        %{
        smoothedCSD = smooth(CSC_AllData,.05*Fs);
        CSDoutput = CSD(smoothedCSD',Fs,0.5E-4);
        
        M = max(max(abs(CSDoutput))); % abosolute maximum CSD, for the colormap scale
        clims = [-M M]; % gives the upper and lower limit for the colormap
        figure(124);clf
        
        im = imagesc(CSDoutput(:,2:end-1)',clims); % CSD as heatmap
        colormap(flipud(jet)); % blue = source; red = sink
        cb = colorbar('SouthOutside');
        set(gca,'Ytick',[1:1:size(data,2)-1]);
        set(gca, 'YTickLabel',[2:1:size(data,2)-1]); % electrode number
        
        %}
        %%
        figure(FigHRaw)
        
        axis tight
        %ylim([-400 3400])
        ylim([-50 1050])
        saveName = [saveDir FileNames{o}(1:end-1) '_Raw_' sprintf('%03d', i)];
        
        plotpos = [0 0 30 15];
        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
        %print_in_A4(0, saveName, '-depsc', 0, plotpos);
        
        figure(FigHRaw ); clf
        %%
        figure(FigHLD)
        axis tight
        %ylim([-400 3400])
        ylim([-50 1050])
        
        saveName = [saveDir FileNames{o}(1:end-1) '_LF_' sprintf('%03d', i)];
        
        plotpos = [0 0 30 15];
        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
        %print_in_A4(0, saveName, '-depsc', 0, plotpos);
        figure(FigHLD); clf
        
        %%
        figure(FigHHighRect)
        axis tight
          %ylim([0 120])
          ylim([0 140])
        saveName = [saveDir FileNames{o}(1:end-1) '_HFR_' sprintf('%03d', i)];
        
        plotpos = [0 0 30 15];
        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
        %print_in_A4(0, saveName, '-depsc', 0, plotpos);
        figure(FigHHighRect); clf
        %%
        figure(FigHHigh)
        axis tight
        ylim([-30 330])
        saveName = [saveDir FileNames{o}(1:end-1) '_HF_' sprintf('%03d', i)];
        
        plotpos = [0 0 30 15];
        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
        %print_in_A4(0, saveName, '-depsc', 0, plotpos);
        figure(FigHHigh); clf
        %%
        saveName = [saveDir FileNames{o}(1:end-1) '_CSD_' sprintf('%03d', i) '.mat'];
        save(saveName, 'CDC_AllData', '-v7.3')
        disp('')
    end
    
end

end

