function [] = saveDataForSebastian()
dbstop if error
close all
clear all
%% Add code
addpath(genpath('/home/janie/code/code2018/'))

%% Neuralynx format Data
%% Load Lizard Data

%dataDir = '/media/janie/Data8TB/lizard_14/12.06.2015/17-10-54_cheetah/'; %csc48
%csc= 32;
%titl = 'Lizard14';

%% Load turtle (Easy) Data

%  dataDir = '/media/janie/Data8TB/AD20/20-49-12_cheetah/'; %csc48
%  csc= 110;
%  titl = 'TurtleAD20';

%% Load turtle (Hard) Data

dataDir = '/media/janie/Data8TB/AA19/16-00-36_cheetah/'; %csc48
csc= 112;
titl = 'TurtleAA19';

%% Open Ephys Forma Data
%% Load Chicken Data
% dataDir = '/media/janie/Data8TB/chick2_2018-04-30_17-29-04/100_CH1.continuous/'; %csc48
% %csc= 112;
% titl = 'Chicken2';

%% Load and Prepare Neuralynx Data

dataRecordingObj = NLRecording(dataDir);
obj = sleepAnalysis;
obj=obj.getFilters(dataRecordingObj.samplingFrequency);

%% Get the data
seg=40000; % 40 s

TOn=0:seg:(dataRecordingObj.recordingDuration_ms-seg);
TWin=seg*ones(1,numel(TOn));
nCycles=numel(TOn);

dataSegs_V_ds = cell(1, nCycles);
data_ds_t_ms = cell(1, nCycles);
dataSegs_LF_ds = cell(1, nCycles);
dataSegs_HF_ds = cell(1, nCycles);

%INFO.DataType = 'Raw_V_ds';
%INFO.DataType = 'LF_V';
%INFO.DataType = 'HF_V';

tic
for i=1:nCycles
    %for i=1:100
    
    [tmpV,~]=dataRecordingObj.getData(csc,TOn(i),TWin(i));
    [LF, ~]=obj.filt.FL.getFilteredData(tmpV); % Low freq filter
    [HF, ~]=obj.filt.FH.getFilteredData(tmpV); % high freq filter
    
    [V_ds,V_ds_t_ms] = obj.filt.F.getFilteredData(tmpV);
    [LF_ds,~] = obj.filt.F.getFilteredData(LF);
    [HF_ds,~] = obj.filt.F.getFilteredData(HF);
    
    %          figure(100); clf
    %          subplot(3, 1, 1)
    %          plot(V_ds_t_ms, squeeze(V_ds))
    %          subplot(3, 1, 2)
    %          plot(V_ds_t_ms, squeeze(LF_ds))
    %          subplot(3, 1, 3)
    %          plot(V_ds_t_ms, squeeze(HF_ds))
    %
    dataSegs_V_ds{1, i} = squeeze(V_ds);
    dataSegs_LF_ds{1, i} = squeeze(LF_ds);
    dataSegs_HF_ds{1, i} = squeeze(HF_ds);
    data_ds_t_ms{1, i} = V_ds_t_ms;
    
end
toc

%%
INFO.dataDir = dataDir;
INFO.csc = csc;
INFO.fs = dataRecordingObj.samplingFrequency;
INFO.ds_factor = 128;
INFO.recordingDuration_ms = dataRecordingObj.recordingDuration_ms;
INFO.seg_ms = seg;
INFO.nCycles = nCycles;

saveName = [titl '.mat'];
saveDir = ['/media/janie/Data8TB/dataForSebastian/' saveName];

save(saveDir, 'dataSegs_V_ds', 'dataSegs_LF_ds', 'dataSegs_HF_ds','data_ds_t_ms', 'INFO', '-v7.3')

end





