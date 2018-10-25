function []  = avianShWRdetection()

hostName = gethostname;

switch hostName
    case 'deadpool'
        addpath(genpath('/home/janie/Code/code2018/'))
        dirD = '/';
        
        %% Penetration 4
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-19-16/100_CH1.continuous'; %DV=1806
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-03-12/100_CH1.continuous'; %DV=2207
        
        
        %% Use these
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous'; %DV=2526, 30 min
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %DV=2998
        fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one %DV=3513
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous'; %DV=1806 %DV=4042
        
        saveDir = ['/home/janie/Dropbox/00_Conferences/SFN_2018/figsForPoster/'];
        
    case 'turtle'
        
        addpath(genpath('/home/janie/code/code2018/'))
        dirD = '/';
        
        %% Use these
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous'; %DV=2526, 30 min
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %DV=2998
        fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one %DV=3513
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous'; %DV=1806 %DV=4042
        
        saveDir = ['/home/janie/Dropbox/00_Conferences/SFN_2018/figsForPoster/'];
        
end

    
%% Loading Data

[pathstr,name,ext] = fileparts(fileName);
bla = find(fileName == dirD);
dataName = fileName(bla(end-1)+1:bla(end)-1);
saveName = [pathstr dirD dataName '-fullData'];
[data, timestamps, info] = load_open_ephys_data(fileName);
Fs = info.header.sampleRate;

fObj = filterData(Fs);

%% Filters

fobj.filt.FL=filterData(Fs);
fobj.filt.FL.lowPassPassCutoff=4.5;
fobj.filt.FL.lowPassStopCutoff=6;
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

seg=20;
TOn=1:seg*Fs:(recordingDuration_s*Fs-seg*Fs);

nCycles = numel(TOn);

figH100 = figure(100);clf;

for i=1:nCycles-1
    
    thisROI = TOn(i):TOn(i+1);
    
    SegData = V_uV_data_full(:,:, thisROI);
    SegData_s = thisSegData_s(thisROI);
    
    DataSeg_FNotch = fobj.filt.FN.getFilteredData(SegData);
    DataSeg_LF = fobj.filt.FL.getFilteredData(SegData);
    DataSeg_HF = fobj.filt.FH2.getFilteredData(SegData);

%%
smoothWin = 0.10*Fs;
DataSeg_LF_neg = -squeeze(DataSeg_LF);
%figure; plot(DataSeg_LF_neg)
DataSeg_rect_HF = squeeze(DataSeg_HF);
DataSeg_rect_HF = smooth(DataSeg_rect_HF.^2, smoothWin);
baseline = mean(DataSeg_rect_HF)*2;

%figure; plot(SegData_s, DataSeg_rect_HF); axis tight

%% Find Peaks

%[peakH,peakTime_DS, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakProminence',50,'WidthReference','halfprom'); %For HF
[peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakHeight',baseline,'MinPeakProminence',50, 'WidthReference','halfprom'); %For HF

%[peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',40,'WidthReference','halfprom'); %for LF
  
  %%
  
  absPeakTime_s =  SegData_s(peakTime_Fs);
  relPeakTime_s  = peakTime_Fs;
        
        allRelPeaks_s = allRelPeaks_ms/1000;
        allRelPeaks_samp = round(allRelPeaks_s*Fs);
        
        %%
        figure(100);clf;
        
        subplot(5,1,1)
        plot(SegData_s, squeeze(SegData)); title( ['Raw Voltage']);
        axis tight
        
        subplot(5, 1, 2)
        plot(SegData_s, squeeze(DataSeg_FNotch)); title( ['Notch Filter']);
        axis tight
        
        subplot(5, 1, 3)
        plot(SegData_s, squeeze(DataSeg_LF)); title( ['LF']);
        axis tight
        
        subplot(5, 1, 4)
        plot(SegData_s, DataSeg_rect_HF); title( ['HF Rectified']);
        axis tight
        
        subplot(5, 1, 5)
        plot(SegData_s, squeeze(DataSeg_HF)); title( ['HF Rectified']);
        axis tight
        
  
end
end
    
%% Single Data Plot





















