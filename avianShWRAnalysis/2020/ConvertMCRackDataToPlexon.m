function [] = ConvertMCRackDataToPlexon(ChannelsToLoad, fileToLoad, SpikeOutputDir)
dbstop if error

%plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];

%%

addpath(genpath('C:\Users\dlc\Documents\GitHub\McsMatlabDataTools'));


data = McsHDF5.McsData(fileToLoad);
[filepath,name,ext] = fileparts(fileToLoad);


%% For getting the correct channel order

cfg = [];
cfg.channel = [1 60]; % channel index 5 to 15
cfg.window = [0 1]; % time range 0 to 1 s

dataTmp= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
%Original
%plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];

ChanLabelInds = str2double(dataTmp.Info.Label(:));

chanInds = [];
chanTxt = [];
for k = 1:numel(ChannelsToLoad)
    chanInds(k) = find(ChanLabelInds == ChannelsToLoad(k));
    chanTxt =  [chanTxt num2str(ChannelsToLoad(k)) '-'];
end

%%
Fs = 32000;
recordingDuration_s = double(data.Recording{1,1}.Duration/1e6);

cfg = [];
cfg.window = [0 recordingDuration_s]; % time

for k = 1:numel(chanInds)
    SpikeData = [];
    
    disp(['Processing chan ' num2str((k)) '/' num2str(numel(chanInds))])
    disp(['Chan: ' num2str(ChannelsToLoad(k))])
    
    thisChan = chanInds(k);
    
    cfg.channel = [thisChan thisChan]; % channel index 5 to 15
    
    chanDataParital= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
    ChanData = chanDataParital.ChannelData/1e6; %loads all data info
    
    timestamps = chanDataParital.ChannelDataTimeStamps;
    
    
    
    SpikeData  = int16(ChanData*(double(intmax('int16')) / max(abs(ChanData)) ));
    
    %  subplot(2, 1, 1)
    %  plot(ChanData(1:10000))
    %  axis tight
    %  subplot(2, 1, 2)
    %  plot(SpikeData(1:10000))
    %  axis tight
    
    DATA(k,:) = SpikeData;
    
end

INFO.Channels = ChannelsToLoad;
INFO.File = fileToLoad;
INFO.FileName = name;

textName = [name '_CH-' chanTxt '_SpikeData.mat'];
saveName = [SpikeOutputDir textName];
save(saveName, 'DATA', 'INFO', '-v7.3')

end
