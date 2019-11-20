function [] = screenAvianShWDetections_V2()



pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Analysis\19-34-00__SWR-Detections';
fileName = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Ephys\100_CH3.continuous';
dirD = '\';
s = load(pathToSWRDetections);

Ripple = s.Ripple;
SW = s.SW;

%% SWs

peakH_1 = SW.peakSW_H;
peakTime_fs_1 = SW.absPeakTime_SW_fs; % first detection
peakW_fs_1 = SW.peakSW_W; % at half prominence

% Use the verified 2nd detections
peakTime_fs_2 = SW.absPeakTime_Fs_LF; % second detection
peakH_2 = SW.peakH_SWcheck; % second detection
peakW_2 = SW.peakW_SWcheck; % at half width

[C,UInds,ic] = unique(peakTime_fs_2); % since we have an overlap, we have to get rid of all the double detections

peakW = peakW_2(UInds);
peakH = peakH_2(UInds);
peakTime_fs = peakTime_fs_2(UInds);

%% Loading Data

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
[V_uV_data_full,nshifts] = shiftdim(data',-1);

thisSegData = V_uV_data_full(:,:,:);
thisSegData_s = timestamps(1:end) - timestamps(1);

DataSeg_BP = fobj.filt.BP.getFilteredData(thisSegData);
DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(thisSegData));

%%
figH = figure(500);
set(figH, 'KeyPressFcn', {@cb_keypress, figH});

setappdata(figH, 'DataSeg_FNotch', DataSeg_FNotch);
setappdata(figH, 'DataSeg_HF', DataSeg_HF);
setappdata(figH, 'thisSegData_s', thisSegData_s);

%%
peaks = peakTime_fs;
nPeaks = numel(peaks);

peakWinL = 0.1*Fs;
peakWinR = 0.1*Fs;

setappdata(figH, 'peaks', peaks);
setappdata(figH, 'nPeaks', nPeaks);

setappdata(figH, 'peakWinL', peakWinL);
setappdata(figH, 'peakWinR', peakWinR);

%%

currentPeakInd = 1;
setappdata(figH, 'currentPeakInd', currentPeakInd);

allPeakInds = [];
setappdata(figH, 'allPeakInds', allPeakInds);

disp('Plotting...')
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
line([ thisSegData_s(peaks(currentPeakInd)) thisSegData_s(peaks(currentPeakInd))], [-300 100])
text(roi_s(4000), 80, num2str(currentPeakInd), 'color', 'r')


allPeakInds = getappdata(figH, 'allPeakInds');
currentPeakInd = getappdata(figH, 'currentPeakInd');

if ismember(currentPeakInd,  allPeakInds)
    title('Saved')
else
    title('Not Saved')
end

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


end




