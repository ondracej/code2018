function [] = screenAvianShWDetections()

dbstop if error
close all

hostName = gethostname;
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
        
        %saveDir = ['/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/'];
        %saveName = [saveDir 'ShWDetection_Chick2_17-29-04_'];
        %DetectionFileToLoad = '/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/ShWDetection_Chick2_17-29-04_-Detections.mat';
        
        %% ZF
       
        fileName = '/media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_19-34-00/100_CH7.continuous'; 
       
        saveDir = ['/media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_19-34-00/Analysis/'];
        saveName = [saveDir 'ShWDetection_exp1_2019-04-28_19-34-00_CH7_'];
       
        DetectionFileToLoad = '/media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_19-34-00/ShwDetections/ShWDetection_ZF-59-15_2019-04-28_18-48-02_Ch7_-RippleDetections.mat';
        
        
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

fobj.filt.FN =filterData(Fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;

%%
[V_uV_data_full,nshifts] = shiftdim(data',-1);

thisSegData = V_uV_data_full(:,:,:);
thisSegData_s = timestamps(1:end) - timestamps(1);


DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(thisSegData));
DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(thisSegData));

%%
figH = figure(500);
set(figH, 'KeyPressFcn', {@cb_keypress, figH});

setappdata(figH, 'DataSeg_FNotch', DataSeg_FNotch);
setappdata(figH, 'DataSeg_HF', DataSeg_HF);
setappdata(figH, 'thisSegData_s', thisSegData_s);

%%
d = load(DetectionFileToLoad);
tmpPeaks = d.templatePeaks;

peaks = tmpPeaks.absPeakTime_Fs_LF; % some peaks are duplicate

[C,ia,ic] = unique(peaks);
peaks = peaks(ia);

%bla= unique(nonduplicatePeaks);

nPeaks = numel(peaks);

peakWinL = 0.1*Fs;
peakWinR = 0.1*Fs;

setappdata(figH, 'peaks', peaks);
setappdata(figH, 'nPeaks', nPeaks);

setappdata(figH, 'peakWinL', peakWinL);
setappdata(figH, 'peakWinR', peakWinR);


allPeakProms = tmpPeaks.peakP_LF;
%histogram(allPeakProms, 100)

allPeakWidths = tmpPeaks.peakW;
%histogram(allPeakWidths, 100)

%%

currentPeakInd = 1;
setappdata(figH, 'currentPeakInd', currentPeakInd);

allPeakInds = [];
setappdata(figH, 'allPeakInds', allPeakInds);

plotPeak(figH)


end


%% function

function []  = cb_keypress(src, event, figH)

modifier = event.Modifier;

switch event.Key, % Process Shortcut Keys
    
    case 's'
        allPeakInds = getappdata(figH, 'allPeakInds');
        currentPeakInd = getappdata(figH, 'currentPeakInd');
        
        allPeakInds = [allPeakInds currentPeakInd];
        setappdata(figH, 'allPeakInds', allPeakInds);
        
        figure(figH)
        subplot(1, 3, 1)
        title('Saved')
        
        %% Detect sharp waves
    case 'n'
        
        allPeakInds = getappdata(figH, 'allPeakInds');
        currentPeakInd = getappdata(figH, 'currentPeakInd');
        
        bla = find(allPeakInds == currentPeakInd);
        allPeakInds(bla) = nan;
        setappdata(figH, 'allPeakInds', allPeakInds);
        
        figure(figH)
        subplot(1, 3, 1)
        title('Not Saved')
        
    case 'rightarrow'
        
        nPeaks = getappdata(figH, 'nPeaks');
        
        tmpPeakInd = getappdata(figH, 'currentPeakInd');
        currentPeakInd = tmpPeakInd +1;
        
        if currentPeakInd > nPeaks
            disp('At the last file')
            currentPeakInd = nPeaks;
        end
        
        setappdata(figH, 'currentPeakInd', currentPeakInd);
        
        plotPeak(figH)
        disp('Next')
        
    case 'leftarrow'
        
        tmpPeakInd = getappdata(figH, 'currentPeakInd');
        currentPeakInd = tmpPeakInd-1;
        
        if currentPeakInd < 1
            disp('At the first file')
            currentPeakInd = 1;
        end
        
        setappdata(figH, 'currentPeakInd', currentPeakInd);
        
        plotPeak(figH)
        disp('Previous')
        
    case 'z'
        
        allPeakInds = getappdata(figH, 'allPeakInds');
        peaks = getappdata(figH, 'peaks');
        nonNans = ~isnan(allPeakInds);
        
        nonNansInds= allPeakInds(nonNans);
        
        PeakTimes = peaks(nonNansInds);
        
        saveDir = '/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/';
        saveName = [saveDir  'ScreenedDetectionsInds'];
        save(saveName, 'allPeakInds', 'PeakTimes')
        disp(['Saved:' saveName])
        
end
end


function [] = plotPeak(figH)

currentPeakInd = getappdata(figH, 'currentPeakInd');

DataSeg_FNotch= getappdata(figH, 'DataSeg_FNotch');
DataSeg_HF= getappdata(figH, 'DataSeg_HF');
thisSegData_s= getappdata(figH, 'thisSegData_s');
peaks= getappdata(figH, 'peaks');
%setappdata(figH, 'nPeaks', nPeaks);

peakWinL = getappdata(figH, 'peakWinL');
peakWinR= getappdata(figH, 'peakWinR');

roi = peaks(currentPeakInd)-peakWinL:peaks(currentPeakInd)+peakWinR;

FNotch_roi = DataSeg_FNotch(roi);
HF_roi = DataSeg_HF(roi);
roi_s = thisSegData_s(roi);

figure(figH); clf;

subplot(1, 3, 1)
plot(roi_s, FNotch_roi)
hold on;
plot(roi_s, HF_roi, 'k')
axis tight
line([ thisSegData_s(peaks(currentPeakInd)) thisSegData_s(peaks(currentPeakInd))], [-1000 500])
text(roi_s(10), 200, num2str(currentPeakInd), 'color', 'r')


allPeakInds = getappdata(figH, 'allPeakInds');
currentPeakInd = getappdata(figH, 'currentPeakInd');

if ismember(currentPeakInd,  allPeakInds);
    title('Saved')
else
    title('Not Saved')
end

LongRoi = peaks(currentPeakInd)-10*peakWinL:peaks(currentPeakInd)+10*peakWinR;

FNotch_LongRoi = DataSeg_FNotch(LongRoi);
HF_LongRoi = DataSeg_HF(LongRoi);
roi_LongRoi_s = thisSegData_s(LongRoi);

subplot(1, 3, [2 3])
plot(roi_LongRoi_s, FNotch_LongRoi)
hold on;
plot(roi_LongRoi_s, HF_LongRoi, 'k')
axis tight
line([ thisSegData_s(peaks(currentPeakInd)) thisSegData_s(peaks(currentPeakInd))], [-1000 500])

end




