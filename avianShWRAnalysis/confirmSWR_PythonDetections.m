function [D_OBJ] = confirmSWR_PythonDetections(D_OBJ)
SWR_Python_Dir = [D_OBJ.Session.SessionDir 'SWR-Python' D_OBJ.DIR.dirD];

textSearch = '*export_ripples*'; % text search for ripple detection file
SWR_DetectionsDir = dir(fullfile(SWR_Python_Dir,textSearch));

textSearch = '*_py_*'; % text search for data .mat file
SWR_DataDir = dir(fullfile(SWR_Python_Dir,textSearch));

rD = load([SWR_Python_Dir SWR_DetectionsDir.name]);
rippleDetections = double(rD.data); % ins samples of the original data file
rippleDetectionsx50 = rippleDetections*50; % we do this cuz the resolution of the python code is 50
nRippleDetections = numel(rippleDetectionsx50);

disp('Loading data...')
sD = load([SWR_Python_Dir SWR_DataDir.name]);

swrData =  sD.dataSegs_V_raw;
Fs =  sD.INFO.fs;


%% Defining Filters
fObj = filterData(Fs);
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


%% Filtering Data

[V_uV_data_full,nshifts] = shiftdim(swrData',-1);

thisSegData = V_uV_data_full(:,:,:);
thisSegData_s = sD.data_t_s;

%thisSegData_s = timestamps(1:end) - timestamps(1);

DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(thisSegData));
DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(thisSegData));

%% making Gui

figH = figure(500);
set(figH, 'KeyPressFcn', {@cb_keypress, figH, D_OBJ});

setappdata(figH, 'DataSeg_FNotch', DataSeg_FNotch);
setappdata(figH, 'DataSeg_HF', DataSeg_HF);
setappdata(figH, 'thisSegData_s', thisSegData_s);
%%


peakWinL = 0.1*Fs;
peakWinR = 0.1*Fs;

setappdata(figH, 'peaks', rippleDetectionsx50);
setappdata(figH, 'nPeaks', nRippleDetections);

setappdata(figH, 'peakWinL', peakWinL);
setappdata(figH, 'peakWinR', peakWinR);


currentPeakInd = 1;
setappdata(figH, 'currentPeakInd', currentPeakInd);

allPeakInds = [];
setappdata(figH, 'allPeakInds', allPeakInds);

obj.figH = figH;

plotPeak(figH);

end

%% Functions

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

if ismember(currentPeakInd,  allPeakInds)
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


function []  = cb_keypress(src, event, figH, D_OBJ)

modifier = event.Modifier;

switch event.Key % Process Shortcut Keys
    
    %% Save Sharp Wave
    case 's'
        allPeakInds = getappdata(figH, 'allPeakInds');
        currentPeakInd = getappdata(figH, 'currentPeakInd');
        
        allPeakInds = [allPeakInds currentPeakInd];
        setappdata(figH, 'allPeakInds', allPeakInds);
        
        figure(figH)
        subplot(1, 3, 1)
        title('Saved')
        
        %% Reject Sharp Wave
    case 'n'
        
        allPeakInds = getappdata(figH, 'allPeakInds');
        currentPeakInd = getappdata(figH, 'currentPeakInd');
        
        bla = find(allPeakInds == currentPeakInd);
        allPeakInds(bla) = nan;
        setappdata(figH, 'allPeakInds', allPeakInds);
        
        figure(figH)
        subplot(1, 3, 1)
        title('Not Saved')
        
        %% Go to next Sharp wave
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
        
        %% Go to previous sharp Wave
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
        
        %% Final Save of all Sharp Waves
    case 'z'
        
        allPeakInds = getappdata(figH, 'allPeakInds');
        peaks = getappdata(figH, 'peaks');
        nonNans = ~isnan(allPeakInds);
        
        nonNansInds= allPeakInds(nonNans);
        
        PeakTimes = peaks(nonNansInds);
        
        SWR_Python_Dir = [D_OBJ.Session.SessionDir 'SWR-Python' D_OBJ.DIR.dirD];
        saveName = [SWR_Python_Dir  'ScreenedDetectionsInds'];
        save(saveName, 'allPeakInds', 'PeakTimes')
        disp(['Saved:' saveName])
        
end
end

