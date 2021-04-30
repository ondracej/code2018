
close all
clear all

data = McsHDF5.McsData('C:\Users\Janie\Documents\Data\PaulaData\20210329\Output\20210329-1307.h5');

cfg = [];
cfg.channel = [34 35]; % channel index 5 to 15
cfg.window = [1 20]; % time range 42 s to 1093 s
partialData = data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
%plot(partialData,[]); % plot the analog stream segment

fs = 32000;
time_samp = 1:1:numel(partialData.ChannelData(1,:));
time_s = time_samp/fs;


% 34, 35

subplot(2, 1, 1);
plot(time_s(1:10*fs), smooth(partialData.ChannelData(1,1:10*fs)/1e6))
axis tight

subplot(2, 1, 2);
plot(time_s(1:10*fs), smooth(partialData.ChannelData(2,1:10*fs)/1e6))
axis tight

chan54 = partialData.ChannelData(1,:);
chan61 = partialData.ChannelData(2,:);
fs = 32000;



ylim([-20 10])


cfg = [];
cfg.dataType = 'double';
converted_data = data.Recording{1}.AnalogStream{1}.getConvertedData(cfg);

figure(100); clf; 
plot(converted_data(34,:))

%%

allData = data.Recording{1,1}.AnalogStream{1,1}.ChannelData;

fs = 32000;
time_samp = 1:1:size(allData, 2);
time_s = time_samp/fs;


for j = 1:60
figure(100); clf
    plot(time_s(1:10*fs), smooth(allData(j,1:10*fs)/1e6))
    j
    pause
    
end

tOn = 1:10:time_s(end);


%%
chanSet = [31 33 34 35];
offset = 0;
for k = 1:numel(tOn)-1
figure(101); clf    
for j = 1:numel(chanSet)
    thisChan = chanSet(j);
    
    roi = tOn(k)*fs:tOn(k+1)*fs;
    subplot(4, 1, j)
    plot(time_s(roi), allData(thisChan, roi)/1e6, 'k')
    axis tight
    ylim([-40 20])
  
end
 pause 
end

plotDir = 'C:\Users\Janie\Dropbox\00_Grants\0_2020_erc\Latex\b2\Figures\Data\';
figure(100)
saveName = [plotDir 'SliceTraces1'];
plotpos = [0 0 8 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);
