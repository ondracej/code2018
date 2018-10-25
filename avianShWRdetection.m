function []  = avianShWRdetection()
dbstop if error
%close all

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
saveName = [pathstr dirD dataName '-fullData'];
[data, timestamps, info] = load_open_ephys_data(fileName);
Fs = info.header.sampleRate;

fObj = filterData(Fs);

%% Filters

fobj.filt.FL=filterData(Fs);
%fobj.filt.FL.lowPassPassCutoff=4.5;
fobj.filt.FL.lowPassPassCutoff=8;
fobj.filt.FL.lowPassStopCutoff=10;
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
overlapWin = 2*Fs;

nCycles = numel(TOn);

figH100 = figure(100);clf;
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
    minPeakWidth = 0.075*Fs;
    maxPeakWidth = 0.12*Fs;
    minPeakHeight = 300;
    %[peakH,peakTime_DS, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakProminence',50,'WidthReference','halfprom'); %For HF
    %[peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth, 'maxPeakWidth', maxPeakWidth, 'MinPeakProminence',50, 'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
    [peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth, 'MinPeakProminence',300, 'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
    %[peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',40,'WidthReference','halfprom'); %for LF
    
    %%
    
    absPeakTime_s =  SegData_s(peakTime_Fs);
   % relPeakTime_s  = peakTime_Fs;
   
    %%
    figure(100);clf;
    
    subplot(5,1,1)
    plot(SegData_s, Data_SegData); title( ['Raw Voltage']);
    axis tight
    ylim([-1000 1000])
    
    subplot(5, 1, 2)
    plot(SegData_s, DataSeg_FNotch); title( ['Notch Filter']);
    axis tight
    ylim([-1000 1000])
    
    subplot(5, 1, 3)
    plot(SegData_s, DataSeg_LF); title( ['LF']);
    axis tight
    ylim([-1000 1000])
    
    subplot(5, 1, 4)
    plot(SegData_s, DataSeg_rect_HF); title( ['HF Rectified']);
    axis tight
    
    subplot(5, 1, 5)
    plot(SegData_s, DataSeg_HF); title( ['HF Rectified']);
    axis tight
    ylim([-200 200])
    
    disp('')
    
    for q =1:numel(peakTime_Fs)
        
        figure(100);
        
        subplot(5,1, 5)
        hold on;
        plot(SegData_s(peakTime_Fs(q)), DataSeg_HF(peakTime_Fs(q)), 'rv');
        
        subplot(5, 1,4)
        hold on;
        plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'r*');
        
        subplot(5, 1, 1)
        hold on
        plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
        
        subplot(5, 1, 2)
        hold on
        plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
        
        %% Now we check a window around the peak to see if there is really a sharp wave
        
        WinSizeL = 0.15*Fs;
        WinSizeR = 0.15*Fs;
        
        winROI = peakTime_Fs(q)-WinSizeL:peakTime_Fs(q)+WinSizeR;
        
        if winROI(end) > size(SegData_s, 1)
            disp('Win is too big')
            continue
        else
            
            winROI_s = SegData_s(winROI);
        
            LFWin = -DataSeg_LF(winROI);
            %LFWin = -DataSeg_FNotch(winROI); % not a good idea
        
            figure(104);clf
            plot(winROI_s, LFWin)
            
            %minPeakWidth_LF = 0.075*Fs;
            minPeakWidth_LF = 0.050*Fs;
            minPeakHeight_LF = 150;
            minPeakProminence = 195;
            %minPeakProminence = 490;
            [peakH_LF,peakTime_Fs_LF, peakW_LF, peakP_LF]=findpeaks(LFWin,'MinPeakHeight',minPeakHeight_LF, 'MinPeakProminence',minPeakProminence, 'MinPeakWidth', minPeakWidth_LF, 'WidthReference','halfprom'); %For HF
            % prominence is realted to window size
            
            hold on
            plot(winROI_s(peakTime_Fs_LF), LFWin(peakTime_Fs_LF), '*')
            
            
            disp('')
            
            if numel(peakTime_Fs_LF) == 1
                
                templatePeaks.peakH(cnt) = peakH(q);
                templatePeaks.peakTime_Fs(cnt) = peakTime_Fs(q);
                templatePeaks.absPeakTime_s(cnt) = absPeakTime_s(q);
                templatePeaks.peakW(cnt) = peakW(q);
                templatePeaks.peakP(cnt) = peakP(q);
                
                templatePeaks.peakH_LF(cnt) = peakH_LF;
                templatePeaks.peakTime_Fs_LF(cnt) = peakTime_Fs_LF;
                templatePeaks.peakW_LF(cnt) = peakW_LF;
                templatePeaks.peakP_LF(cnt) = peakP_LF;
                
                cnt = cnt+1;
           
            elseif isempty(peakTime_Fs_LF)
                
                figure(100);
                
                subplot(5,1, 5)
                hold on;
                plot(SegData_s(peakTime_Fs(q)), DataSeg_HF(peakTime_Fs(q)), 'bv');
                
                subplot(5, 1,4)
                hold on;
                plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'b*');
                
                subplot(5, 1, 1)
                hold on
                plot(SegData_s(peakTime_Fs(q)), 0, 'b*')
                
                subplot(5, 1, 2)
                hold on
                plot(SegData_s(peakTime_Fs(q)), 0, 'b*')
                
                
                
                continue
            else
                keyboard
            end
        end
        
            
    end
    %pause    
     disp('')
    
end
end

%% Single Data Plot





















