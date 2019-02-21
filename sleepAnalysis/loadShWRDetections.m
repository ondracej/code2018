function [] = loadShWRDetections()
dbstop if error
close all

%% Add code
addpath(genpath('/home/janie/code/code2018/'))

%% Neuralynx format Data
%% Load Lizard Data

dataDir = '/home/janie/Data/MPI/Lizard14/'; %csc48
csc= 32;
titl = 'Lizard14';

%% Load turtle (Easy) Data

%  dataDir = '/media/janie/Data8TB/AD20/20-49-12_cheetah/'; %csc48
%  csc= 110;
%  titl = 'TurtleAD20';

%% Load turtle (Hard) Data

%dataDir = '/media/janie/Data8TB/AA19/16-00-36_cheetah/'; %csc48
%dataDir = '/home/janie/Data/MPI/SleepData/AA19/01.23.2017/16-00-36_cheetah/';
%csc= 112;
%titl = 'TurtleAA19';

%% Open Ephys Forma Data
%% Load Chicken Data
% dataDir = '/media/janie/Data8TB/chick2_2018-04-30_17-29-04/100_CH1.continuous/'; %csc48
% %csc= 112;
% titl = 'Chicken2';

%% Load and Prepare Neuralynx Data

dataRecordingObj = NLRecording(dataDir);
fs = dataRecordingObj.samplingFrequency;

%obj = sleepAnalysis;
%obj=obj.getFilters(dataRecordingObj.samplingFrequency);

%% Get the data

dets = load('/home/janie/Downloads/ripple_export.mat');
detections_samps = dets.data;
detections_ms = detections_samps/fs;

nDetections = numel(detections_ms);

winLength_ms = 1000;
winLengthPre_ms = 500;

cnt =1;

%for i = 1:nDetections
for i = 1:1000

    [tmpV,t_ms]=dataRecordingObj.getData(csc,detections_ms(i)-winLengthPre_ms,winLength_ms);
    
    dataSegs_V_raw(:, cnt) = squeeze(tmpV);
    data_t_ms(:, cnt) = t_ms;
    disp([num2str(i) '/' num2str(nDetections)])
    
    cnt = cnt+1;
end


meanshWR = mean(dataSegs_V_raw);

figure; plot(dataSegs_V_raw(:,500), 'k');



seg=40000; % 40 s

TOn=0:seg:(dataRecordingObj.recordingDuration_ms-seg);
TWin=seg*ones(1,numel(TOn));
nCycles=numel(TOn);

%dataSegs_V_ds = cell(1, nCycles);
%data_ds_t_ms = cell(1, nCycles);
%dataSegs_LF_ds = cell(1, nCycles);
%dataSegs_HF_ds = cell(1, nCycles);


%INFO.DataType = 'Raw_V_ds';
%INFO.DataType = 'LF_V';
%INFO.DataType = 'HF_V';

dataSegs_V_raw = cell(1, 100);
data_t_ms = cell(1, 100);


INFO.dataDir = dataDir;
INFO.csc = csc;
INFO.fs = dataRecordingObj.samplingFrequency;
%INFO.ds_factor = 128;
INFO.recordingDuration_ms = dataRecordingObj.recordingDuration_ms;
INFO.seg_ms = seg;
INFO.nCycles = nCycles;

save_cnt = 1;
cnt = 1;
for i=1:nCycles
    
    %for i=1:100
    
    [tmpV,t_ms]=dataRecordingObj.getData(csc,TOn(i),TWin(i));
    %[LF, ~]=obj.filt.FL.getFilteredData(tmpV); % Low freq filter
    %[HF, ~]=obj.filt.FH.getFilteredData(tmpV); % high freq filter
    
    %[V_ds,V_ds_t_ms] = obj.filt.F.getFilteredData(tmpV);
    %[LF_ds,~] = obj.filt.F.getFilteredData(LF);
    %[HF_ds,~] = obj.filt.F.getFilteredData(HF);
    
    %              figure(100); clf
    %              subplot(3, 1, 1)
    %              plot(V_ds_t_ms, squeeze(V_ds))
    %              subplot(3, 1, 2)
    %              plot(V_ds_t_ms, squeeze(LF_ds))
    %              subplot(3, 1, 3)
    %              plot(V_ds_t_ms, squeeze(HF_ds))
    
    %dataSegs_V_ds{1, i} = squeeze(V_ds);
    %dataSegs_LF_ds{1, i} = squeeze(LF_ds);
    %dataSegs_HF_ds{1, i} = squeeze(HF_ds);
    
    dataSegs_V_raw(:, cnt) = squeeze(tmpV);
    data_t_ms(:, cnt) = t_ms;
    disp([num2str(i) '/' num2str(nCycles)])
    
    cnt = cnt+1;
    test = mod(i,100);
    
    if test == 0;
        
        %%
        
        bla = sprintf('%02d-', save_cnt);
        
        saveName = [bla titl '.mat'];
        saveDir = ['/home/janie/Data/TUM/forSebastian/' saveName];
        
        %save(saveDir, 'dataSegs_V_ds', 'dataSegs_LF_ds', 'dataSegs_HF_ds','data_ds_t_ms', 'INFO', '-v7.3')
        save(saveDir, 'dataSegs_V_raw', 'data_t_ms', 'INFO', '-v7.3')
        
        save_cnt  = save_cnt +1;
        
        % Reset
        cnt = 1;
        dataSegs_V_raw = cell(1, 100);
        data_t_ms = cell(1, 100);
        
        disp(['Saved:'  saveDir]);
        
        disp('')
    end
    
end

%{

%% Chicken

addpath(genpath('/home/janie/Code/code2018/OpenEphys/'))
addpath(genpath('/home/janie/Code/code2018/analysis-tools-master/'));
addpath(genpath('/home/janie/Code/code2018/NSKToolBox/'));    
dirD = '/';

%fileName = '/home/janie/Data/SleepChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous';

%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-19-16/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-41-19/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-03-12/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %good one
fileName = '/home/janie/Data/TUM/SleepChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous';


saveName = ['chick2_2018-04-30_17-29-04'];

[data, timestamps, info] = load_open_ephys_data(fileName);

Fs = info.header.sampleRate;

data_t_ms = timestamps*1000;
dataSegs_V_raw = data;

INFO.dataDir = fileName;
INFO.fs = Fs;
INFO.recordingDuration_ms = timestamps(end)*1000;

saveDir = ['/home/janie/Data/TUM/forSebastian/' saveName];

save(saveDir, 'dataSegs_V_raw', 'data_t_ms', 'INFO', '-v7.3')
%}

end





