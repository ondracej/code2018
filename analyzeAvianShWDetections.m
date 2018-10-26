function [] = analyzeAvianShWDetections()

hostName = gethostname;
doPlot = 0;
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
        fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one %DV=3513
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous'; %DV=1806 %DV=4042
        
        saveDir = ['/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/'];
        saveName = [saveDir 'ShWDetection_Chick2_17-29-04_'];
        DetectionFileToLoad = '/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/ShWDetection_Chick2_17-29-04_-Detections.mat';
        
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

DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(thisSegData));
%DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(SegData));
DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(thisSegData));


%% 
d = load(DetectionFileToLoad);

tmpPeaks = d.templatePeaks;
disp('');

%peaks = tmpPeaks.absPeakTime_Fs_LF;
peaks = tmpPeaks.asPeakTime_fs;
nPeaks = numel(peaks);

peakWinL = 0.4*Fs;
peakWinR = 0.1*Fs;

for j = 1:nPeaks
    
    roi = peaks(j)-peakWinL:peaks(j)+peakWinR;

    FNotch_roi = DataSeg_FNotch(roi);
    HF_roi = DataSeg_HF(roi);
    roi_s = thisSegData_s(roi);
    
    
    
figure (100); clf;
plot(roi_s, FNotch_roi)
axis tight
line([ thisSegData_s(peaks(j)) thisSegData_s(peaks(j))], [-500 500])

end

    
    


























end


