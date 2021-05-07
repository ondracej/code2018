function [] = loadingMCSData()
dbstop if error

close all
clear all

fileToLoad = 'D:\JohannaData\20210406\Output\20210406-1256.h5';
data = McsHDF5.McsData(fileToLoad );
[filepath,name,ext] = fileparts(fileToLoad);
plotDir = 'D:\JohannasDataFigs\20210406\';

seg_s = 20;
recordingDuration_s = data.Recording{1,1}.Duration/1e6;
fs = 32000;

TOn=1:seg_s:(recordingDuration_s-seg_s);
nSegs = numel(TOn);

for j = 1:nSegs-1
    
    cfg = [];
    cfg.channel = [1 60]; % channel index 5 to 15 
    cfg.window = [TOn(j) TOn(j)+seg_s]; % time range 42 s to 1093 s
   
    
    partialData = data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
    
    timestamps = partialData.ChannelDataTimeStamps;
    
    time_samp = 1:1:numel(timestamps);
    time_s = time_samp/fs;
    %Top to bottom, left to right
    plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];
    ChanLabelInds = str2double(partialData.Info.Label(:));
    
    offset = 60;
    figure(100); clf
    for k = 1:60
        
        chanInd = find(ChanLabelInds == plottingOrder(k));
        
        hold on
        plot(time_s, partialData.ChannelData(chanInd,:)/1e6+offset, 'k')
        text(time_s(100), offset, num2str(chanInd))
        offset = offset+60;
    end
    xlabel ('Time (s)')
    title([name '--' sprintf('%03d',j)])
    axis tight
    
    ylim([ 0 3628])
    
    saveName = [plotDir name '--' sprintf('%03d',j)];
    figure(100)
    plotpos = [0 0 50 50];
    
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    %%
    
    
    %plot(data.Recording{1},[]);
    %plot(data,[]);
    
    
    %cfg = [];
    %cfg.dataType = 'double';
    %converted_data = data.Recording{1}.AnalogStream{1}.getConvertedData(cfg);
    
    
    
end
