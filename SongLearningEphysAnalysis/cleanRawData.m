
function [] = cleanRawData()

dataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w025\DATA_EPHYS\chronic_2021-08-09_21-51-42\';



dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels

%%

chanNames = dir(fullfile(dataDir, '*.continuous'));

index = strfind({chanNames.name}, ['CH']);
idx = find(~cellfun(@isempty,index));
chanNames =  chanNames(idx);
nChans = numel(chanNames);


chanSet = [10 15 16 17 18 23 24];

dot = '.';
match = [];
for h = 1:nChans
thisName = chanNames(h).name;
bla = find(thisName == dot);
chN = str2num(thisName(bla-2:bla-1));
match(h) = sum(ismember(chanSet, chN));
end


chanNamesSet = [];
cnt = 1;
for j = 1:nChans
    if match(j) ==1
        chanNamesSet{cnt} = chanNames(j).name;
        cnt = cnt+1;
    else
    end
end




tOn_clean = 25;
tOff_clean = tOn_clean+60;

nChans = numel(chanNamesSet);

%% 
figure(103); clf
AllDataBin_train = [];
allMeans = []; allCleanMeans = [];
for oo = 1:nChans
        
        thisChan = chanNamesSet{oo};
        filename = [dataDir thisChan];
        [dataBin, ~, ~] = load_open_ephys_data_chunked(filename,tOn_clean, tOff_clean);
        
        dataBin_clean = dataBin - mean(dataBin);
        allMeans(oo) = mean(dataBin);
        allCleanMeans(oo) = mean(dataBin_clean);
        
        AllDataBin_train(oo,:) = dataBin_clean;
     
end


%[clean_data, artifact_times] = asr_artifact_removal(raw_data, Dthresh, SDthresh)
[clean_data, artifact_times] = asr_artifact_removal(AllDataBin, 30, 15);

   figure (103); clf
    subplot(2, 1, 1)
    plot(clean_data(3,:))
    hold on
    plot(artifact_times, 200, 'k*');
    %ylim([-300 600])
    subplot(2, 1, 2)
    plot(AllDataBin(3,:))
    hold on
    plot(artifact_times, 200, 'k*');
    %ylim([-300 600])
    
    

%% Now do training
X = AllDataBin_train;
srate = 30000;
cutoff = 10; % default  = 5

state = asr_calibrate(X,srate, cutoff);
%state = asr_calibrate(X,srate,cutoff,blocksize,B,A,window_len,window_overlap,max_dropout_fraction,min_clean_fraction,maxmem)

%% Now process all the data

%% Load one channel to get the max data duration

thisChan = chanNamesSet{1};
filename = [dataDir thisChan];
[data, timestamps, info] = load_open_ephys_data(filename);

fs = info.header.sampleRate;
dataSamps = numel(timestamps);
dataDur_s = dataSamps/fs;

timeWin_s = 30; %seconds
tOn = 1:timeWin_s:dataDur_s;
nBins = numel(tOn);

for j = 1:nBins
    thisTime = tOn(j);

    dataBin = []; AllDataBin = [];
    for oo = 1:nChans
        
        thisChan = chanNamesSet{oo};
        filename = [dataDir thisChan];
        [dataBin, ~, ~] = load_open_ephys_data_chunked(filename, thisTime, thisTime+timeWin_s);
        
        dataBin_clean = dataBin - mean(dataBin);
        
        AllDataBin(oo,:) = dataBin_clean;
        
    end
    
    
    
    [outdata,outstate] = asr_process(AllDataBin,fs,state);
     %[outdata,outstate] = asr_process(data,srate,state,windowlen,lookahead,stepsize,maxdims,maxmem,usegpu)
    
    figure (103); clf
    subplot(2, 1, 1)
    plot(outdata(1,:))
    ylim([-300 600])
    subplot(2, 1, 2)
    plot(AllDataBin(1,:))
    ylim([-300 600])
    
    plot(dataBin');
    
    Dthresh = 800;
    SDthresh = 200;
    
    [clean_data, artifact_times] = asr_artifact_removal(raw_data, Dthresh, SDthresh)
    
    
    
    dataBin = dataBin';
    
    goodCh = [1 2 3 5 6 7 8 9 10 11 12];  % example
    
    CAR = mean(dataBin, 2);
    data_CAR = dataBin - CAR;
    
    figure; plot(dataBin)
    figure; plot(data_CAR)
    [data_OBJ, dataInfo] = load_ephys_data(data_OBJ, chanPath);
    
    
    
    [data, timestamps, info] = load_open_ephys_data_chunked(filename,1, 10);
    
    
    
    
    
    
    pathToData = [data_OBJ.PATH.EphysPath data_OBJ.EPHYS.EphysRecName{j}];
    dataRecordingObj = OERecordingMF(pathToData);
    dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject
    
    timeSeriesViewer(dataRecordingObj); % loads all the channels
    
    
    
end

end