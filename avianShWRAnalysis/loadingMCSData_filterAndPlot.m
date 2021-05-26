function [] = loadingMCSData_filterAndPlot()
dbstop if error

close all
clear all

fileToLoad = 'E:\JohannaData\20210329\Output\20210329-1406.h5';
data = McsHDF5.McsData(fileToLoad );
[filepath,name,ext] = fileparts(fileToLoad);
plotDir = 'E:\JohannasDataFigs\SWRs-202103-29\NewPlots\';

seg_s = 20;
recordingDuration_s = data.Recording{1,1}.Duration/1e6;
Fs = 32000;

TOn=1:seg_s:(double(recordingDuration_s)-seg_s);
nSegs = numel(TOn);

%%
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


for j = 1:nSegs-1
    
    cfg = [];
    cfg.channel = [1 60]; % channel index 5 to 15 
    cfg.window = [TOn(j) TOn(j)+seg_s]; % time range 42 s to 1093 s
   
    
    partialData = data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
    
    timestamps = partialData.ChannelDataTimeStamps;
    
    time_samp = 1:1:numel(timestamps);
    time_s = time_samp/Fs+TOn(j)-1;
    
    
    %Top to bottom, left to right
%    plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];
    plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];
    
    ChanLabelInds = str2double(partialData.Info.Label(:));
    
    offset = 60;
    offset2 = 60;
    figure(100); clf
    figure(101); clf
    for k = 1:numel(plottingOrder)
        
        chanInd = find(ChanLabelInds == plottingOrder(k));
        
        thisData = partialData.ChannelData(chanInd,:)/1e6;
        
       
        [data_shift,nshifts] = shiftdim(thisData',-2);
        data_FL = squeeze(fobj.filt.FL.getFilteredData(data_shift));
        data_FH = squeeze(fobj.filt.FH2.getFilteredData(data_shift));

        
        figure(100)
        hold on
        plot(time_s, data_FL+offset, 'k')
        text(time_s(100), mean(data_FL)+offset, num2str(chanInd))
        offset = offset+60;
        
        figure(101)
        hold on
        plot(time_s, data_FH+offset2, 'k')
        text(time_s(100), mean(data_FH)+offset2, num2str(chanInd))
        offset2 = offset2+60;
        
    end
    figure(100)
    xlabel ('Time (s)')
    title([name '--FL--' sprintf('%03d',j)])
    axis tight
    
    ylim([ 0 3628])
    
    saveName = [plotDir name '--FL--' sprintf('%03d',j)];
    figure(100)
    plotpos = [0 0 50 50];
    
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
   % print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    %%
    figure(101)
    xlabel ('Time (s)')
    title([name '--FH--' sprintf('%03d',j)])
    axis tight
    
    ylim([ 0 3628])
    
    saveName = [plotDir name '--FH--' sprintf('%03d',j)];
    figure(101)
    plotpos = [0 0 50 50];
    
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    %print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    
    %%
    
    
    %plot(data.Recording{1},[]);
    %plot(data,[]);
    
    
    %cfg = [];
    %cfg.dataType = 'double';
    %converted_data = data.Recording{1}.AnalogStream{1}.getConvertedData(cfg);
    
    
    
end
