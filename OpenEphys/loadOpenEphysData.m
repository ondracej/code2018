function [] = loadOpenEphysData()
dbstop if error
close all

addpath(genpath('/home/janie/Code/analysis-tools-master/'));
addpath(genpath('/home/janie/Code/MPI/NSKToolBox/'));    
dirD = '/';

%fileName = '/home/janie/Data/SleepChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous';

%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-19-16/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-41-19/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-03-12/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %good one
fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous';


[pathstr,name,ext] = fileparts(fileName);


bla = find(fileName == dirD);

dataName = fileName(bla(end-1)+1:bla(end)-1);

saveName = [pathstr dirD dataName '-fullData'];

[data, timestamps, info] = load_open_ephys_data(fileName);

Fs = info.header.sampleRate;

fObj = filterData(Fs);
%fObj = designNotch(Fs);
%% Filters

fobj.filt.FL=filterData(Fs);
fobj.filt.FL.lowPassPassCutoff=4.5;
fobj.filt.FL.lowPassStopCutoff=6;
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
                    
%% Single plot

[V_uV_data_full,nshifts] = shiftdim(data',-1);

thisSegData = V_uV_data_full(:,:,:);

DataSeg_FN = fobj.filt.FN.getFilteredData(thisSegData);
DataSeg_FL = fobj.filt.FL.getFilteredData(thisSegData);
DataSeg_FH2 = fobj.filt.FH2.getFilteredData(thisSegData);

thisSegData_ms = timestamps(1:end) - timestamps(1);


fig2 = figure(105);clf

plot(thisSegData_ms, squeeze(DataSeg_FN), 'k');
hold on
plot(thisSegData_ms, squeeze(DataSeg_FL)+2000, 'r');

plot(thisSegData_ms, squeeze(DataSeg_FH2)*10-2000, 'b');
axis tight
ylim([-4000 5000])
disp('')

xlabel('Time [s]')
title(dataName)

plotpos = [0 0 25 15];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);

disp('Printing Plot')

%% Getting data in corect format

sizeData_samps = size(data, 1);
sizeData_time_s = timestamps(end) - timestamps(1);

%bla = sizeData_time/3600;
%bla = sizeData_time/60;

%A = rand(1,100);
%[BB,nshifts] = shiftdim(A,-1);

[V_uV_data_full,nshifts] = shiftdim(data',-1);
  
  %% Chunking data
  
  seg_s = 20;
  seg_samps = seg_s*Fs;
  tOn = 1:seg_samps :sizeData_samps-seg_samps;
  
  
  for j = 1:numel(tOn)
      thisSegData = V_uV_data_full(:,:, tOn(j):(tOn(j)+seg_samps));
      thisSegData_ms = timestamps((tOn(j):tOn(j)+seg_samps)) - timestamps(tOn(j));
      
      %% Filter Data
      
      DataSeg_FN = fobj.filt.FN.getFilteredData(thisSegData);
      DataSeg_FL = fobj.filt.FL.getFilteredData(thisSegData);
      DataSeg_FH2 = fobj.filt.FH2.getFilteredData(thisSegData);
      
      bla = squeeze(thisSegData);
      %%
      fig1 = figure(100);clf
      
      %%
      
      plot(thisSegData_ms, squeeze(DataSeg_FN), 'k');
      hold on
      plot(thisSegData_ms, squeeze(DataSeg_FL)+2000, 'r');
      
      plot(thisSegData_ms, squeeze(DataSeg_FH2)-2000, 'b');
      axis tight
      ylim([-3000 3000])
      disp('')
      
      plotpos = [0 0 25 15];
      print_in_A4(0, [saveName '-' num2str(j)], '-djpeg', 0, plotpos);


  end
  
  
  
  disp('')


%%





for q = 1:numel(tOn)
    
    thisTitleTxt = [num2str(tOn(q)/1000) '-' num2str(tOn(q)/1000 +seg/1000) 's'];
    
    allVs = [];
    chanOrders = [];
    allFJLowBandpass = [];
    allFHP = [];
    
    for j = 1:numel(allCSCs)
        
        %thisChan = allCSCs(j);
        thisChan = 97;
        
        [v_samp,t]=dataRecordingObj.getData(thisChan,tOn(q),seg);
    end
end


cheetahFiles = '/home/janie/Data/MPI/SleepData/AA19/01.23.2017/16-00-36_cheetah/';

 dataRecordingObj = NLRecording([cheetahFiles]);
 endTime=dataRecordingObj.recordingDuration_ms;
 fs=dataRecordingObj.samplingFrequency(1);
 
 obj = sleepAnalysis;
 obj=obj.getFilters(32000);
 
 
 seg = 20000;
 tOn = 0:seg:endTime-seg;
 thisChan = 97;
 
 [v_samp,t]=dataRecordingObj.getData(thisChan,tOn(1),seg);
 
 FJLowBandpass=obj.filt.FJLB.getFilteredData(v_samp);
 FHP=obj.filt.FH.getFilteredData(v_samp);
 
 allVs(:,j) = double(v_samp(:));


roi = [1:1000000];


figure(100); clf
plot(timestamps(roi), data(roi))



end