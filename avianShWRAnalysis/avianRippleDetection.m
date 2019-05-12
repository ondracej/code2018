function []  = avianRippleDetection()
dbstop if error
close all

hostName = gethostname;
doPlot = 1;
switch hostName
    case 'DEADPOOL'
        addpath(genpath('/home/janie/Code/code2018/'))
        dirD = '/';
        
        %% Penetration 4
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-19-16/100_CH1.continuous'; %DV=1806
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-03-12/100_CH1.continuous'; %DV=2207
        
        
        %% Use these
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous'; %DV=2526, 30 min
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %DV=2998
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one %DV=3513
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous'; %DV=1806 %DV=4042
        
        %% ZF
        
        %fileName = '/media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_18-07-21/100_CH7.continuous'; %DV=1806 %DV=4042
        %fileName = '/media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_18-48-02/100_CH8.continuous'; %DV=1806 %DV=4042
        fileName = '//media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_19-34-00/100_CH3.continuous'; %DV=1806 %DV=4042
        
        saveDir = ['/media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_19-34-00/ShwDetections/'];
        %saveName = [saveDir 'ShWDetection_Chick2_17-29-04_'];
        %saveName = [saveDir 'ShWDetection_Chick2_17-05-32_'];
        %saveName = [saveDir 'ShWDetection_Chick2_17-56-36_'];
        %saveName = [saveDir 'ShWDetection_Chick2_16-30-56_'];
        
        saveName = [saveDir 'ShWDetection_ZF-59-15_2019-04-28_18-48-02_Ch7_'];
        
    case 'TURTLE'
        
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
fobj.filt.FH2.highPassCutoff=80;
fobj.filt.FH2.lowPassCutoff=400;
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
    interPeakDistance = 0.3*Fs;
    minPeakWidth = 0.05*Fs;
    minPeakHeight = 20;
    minPeakProminence = 20;
    
    [peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth, 'MinPeakProminence',minPeakProminence, 'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
    
    %%
    
    absPeakTime_s =  SegData_s(peakTime_Fs);
    asPeakTime_fs = peakTime_Fs+thisROI(1)-1;
    % relPeakTime_s  = peakTime_Fs;
    
    %%
    if doPlot
        figure(100);clf;
        
        subplot(3,1,1)
        plot(SegData_s, DataSeg_FNotch, 'k'); title( ['Raw']);
        axis tight
        ylim([-300 300])
        
        subplot(3, 1, 2)
        plot(SegData_s, DataSeg_HF, 'k'); title( ['Ripple']);
        axis tight
        ylim([-80 80])
        
        subplot(3, 1, 3)
        plot(SegData_s, smooth(DataSeg_rect_HF, .05*Fs), 'k'); title( ['Ripple Rectified']);
        axis tight
        ylim([0 100])
    end
    
    %         subplot(5,1,1)
    %         plot(SegData_s, Data_SegData); title( ['Raw Voltage']);
    %         axis tight
    %         ylim([-1000 1000])
    %
    %         subplot(5, 1, 2)
    %         plot(SegData_s, DataSeg_FNotch); title( ['Notch Filter']);
    %         axis tight
    %         ylim([-1000 1000])
    %
    %         subplot(5, 1, 3)
    %         plot(SegData_s, DataSeg_LF); title( ['LF']);
    %         axis tight
    %         ylim([-1000 1000])
    %
    %         subplot(5, 1, 4)
    %         plot(SegData_s, DataSeg_rect_HF); title( ['HF Rectified']);
    %         axis tight
    %         ylim([0 1200])
    %
    %         subplot(5, 1, 5)
    %         plot(SegData_s, DataSeg_HF); title( ['HF Rectified']);
    %         axis tight
    %         ylim([-200 200])
    
    
    disp('')
    
    for q =1:numel(peakTime_Fs)
        
        if doPlot
            figure(100);
            
            subplot(3, 1, 1)
            hold on
            plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
            
            subplot(3,1, 2)
            hold on;
            plot(SegData_s(peakTime_Fs(q)), 50, 'rv');
            
            subplot(3, 1, 3)
            hold on;
            plot(SegData_s(peakTime_Fs(q)), 50, 'rv');
        end
        
        %% Now we check a window around the peak to see if there is really a sharp wave
        
        templatePeaks.peakH(cnt) = peakH(q);
        templatePeaks.asPeakTime_fs(cnt) = asPeakTime_fs(q);
        templatePeaks.absPeakTime_s(cnt) = absPeakTime_s(q);
        templatePeaks.peakW(cnt) = peakW(q);
        templatePeaks.peakP(cnt) = peakP(q);
        
        cnt = cnt+1;
    end
    
    plotpos = [0 0 25 15];
    figure(100);
    print_in_A4(0, [saveName '-Ripple-' sprintf('%03d', i)], '-djpeg', 0, plotpos);
    %print_in_A4(0, [saveName '-Ripple-' num2str(i)], '-depsc', 0, plotpos);
    
    
end

disp('')

DetectionSaveName = [saveName '-RippleDetections'];
save(DetectionSaveName, 'templatePeaks');

disp(['Saved:' DetectionSaveName ])

end















