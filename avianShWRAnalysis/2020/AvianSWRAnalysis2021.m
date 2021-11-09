%% SWR Analysis - Feb 2021


%% File Loading
  %filename = '/media/janie/4TB/ZF-59-15/20190428/18-07-21/Ephys/100_CH12.continuous';
  

  %% AddPaths
  
  switch gethostname
      
      case 'TURTLE'
          
          addpath(genpath('/home/janie/Documents/code/Spike-Ripple-Detector-Method-master'));
          addpath(genpath('/home/janie/Documents/code/analysis-tools-master'));
          %addpath(genpath('/home/janie/Documents/code/NET-master'));
          addpath(genpath('/home/janie/Documents/code/NeuralElectrophysilogyTools'));
          
      case 'CSIGA'
          
          addpath(genpath('/home/janie/Documents/code/Spike-Ripple-Detector-Method-master'));
          addpath(genpath('/home/janie/Documents/code/analysis-tools-master'));
          %addpath(genpath('/home/janie/Documents/code/NET-master'));
          addpath(genpath('/home/janie/Documents/code/NeuralElectrophysilogyTools'));
          
      case 'NEUROPIXELS'
         addpath(genpath('C:\Users\Neuropix\Documents\GitHub\code2018'))
          addpath(genpath('C:\Users\Neuropix\Documents\GitHub\NeuralElectrophysilogyTools'));
          addpath(genpath('C:\Users\Neuropix\Documents\GitHub\analysis-tools'))
          
      otherwise
          addpath(genpath('C:\Users\Janie\Documents\GitHub\NeuralElectrophysilogyTools'))
          addpath(genpath('C:\Users\Janie\Documents\GitHub\analysis-tools'))
          %addpath(genpath('C:\Users\Janie\Documents\GitHub\Spike-Ripple-Detector-Method-master'))
          
          
  end



%% Time Series Viewer works in matlab 2014b and also 2018a

dataDir = 'G:\SWR\ZF-o3b11\20210223\14-11-12';
% 10 9 3 13 12 6 16 15 7 8 4 14 11 5 1 2

% Hameds Data
% EEG1: 12, 13, 20, 21, 
% LFP1: 10, 15, 16, 17, 18, 23, 24 
%BestChan: 24

% EEG2: 43, 44, 45, 52, 53
% LFP2: 41, 42, 47, 48, 49, 50, 55, 56
%BestChan: 56
%addpath(genpath('C:\Users\Janie\Documents\GitHub\NeuralElectrophysilogyTools')) 

dataRecordingObj = OERecordingMF(dataDir);

%dataRecordingObj = binaryRecording(dataDir);

dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels

%% DB Matrix
 
params.chanToUse =  '150_CH24_2.continuous';
params.SessionDir = 'G:\Hamed\chronic_2021-07-23_22-43-29\';
params.BirdName = 'test';
params.DateTime = '2021-07-23_22-43-29';
params.plotDir = 'G:\Hamed\Plots\';
plotDBRatioMatrix_standalone(params)


%%
chanMap = [10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2];
chanMap = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2]; %acute

% 10 12 7 11 9 3 6 16 5 15 13 8 4 14 1 2

% Keep Only Channels

% 10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2 % tetrode shanks, by columns,medial to lateral
% 10 9 3 13 12 6 16 15 7 8 4 14 11 5 1 2 % by rows, top to bottom

%chanMap = [7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9]; %chronic
%LFP scale = 500
%Spike scale = 150
%timeWin = 20000
 MLong=obj.currentDataObj.getData(ch,startTimes(i),movLongWin);
%% Load Single Channel

%addpath(genpath('C:\Users\Janie\Documents\GitHub\analysis-tools')) 

%filename = 'E:\TUM\SWR-Project\Janie-72-01\-ML_2021-02-25_14-52-03\176_CH8.continuous';

%filename = 'E:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Ephys\106_CH10.continuous';

filename = 'G:\SWR\ZF-o3b11\20210223\16-34-06\170_CH5.continuous';

[data, timestamps, info] = load_open_ephys_data(filename);
thisSegData_s = timestamps(1:end) - timestamps(1);
Fs = info.header.sampleRate;


%%
[V_uV_data_full,nshifts] = shiftdim(data',-1);

thisSegData = V_uV_data_full(:,:,:);

recordingDuration_s = thisSegData_s(end);


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

%% Create a .dat file
 
dataDir = 'G:\SWR\ZF-72-01\20210225\16-15-23\Ephys\';
chanMap = [10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2]; % tetrode shanks, by columns, medial to lateral

convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys

   
   %% Ripple Detection?
   
   
   
%[res,diagnostics] = spike_ripple_detector(EEG,t);  %Call the function, and return the candidate spike-ripple events.
%[expert_classify] = spike_ripple_visualizer(EEG,t,res,diagnostics)	% Visualize and classify the candidate spike-ripple events.
   

%ROI = .1*3600*Fs:.3*3600*Fs;
ROI = 1*Fs:30*Fs;
dataSnippet = data(ROI);
dataSnippetT_s = thisSegData_s(ROI);

dataSnippet = data;
dataSnippetT_s = thisSegData_s;


dataToUse = dataSnippet;
timeToUse = dataSnippetT_s;

%dataToUse = data;
%timeToUse = thisSegData_s;




%% Other ripple detection
t_separation = 0.015;
percentile = 0.90;

   [res0,diagnostics] = spike_ripple_detector(dataToUse,timeToUse ,percentile, t_separation); %.85
   [expert_classify] = spike_ripple_visualizer(dataToUse,timeToUse, res0, diagnostics);
   
   %%
   figure (100); clf
   subplot(3, 1, 1) ; plot(data(1:40*Fs));
   subplot(3, 1, 2); plot(dfilt(1:40*Fs))
   subplot(3, 1, 3); plot(amp(1:40*Fs))
   ylim([0 100])
   hold on
   line([0 40*Fs], [threshold threshold], 'color', 'r')
   