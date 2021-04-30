function [] = calcSpecOfData_chronux()


pathTocode = 'C:\Users\Janie\Documents\GitHub\code2018\';
addpath(genpath(pathTocode)) 

pathToChronux = 'C:\Users\Janie\Documents\code\chronux_2_12\';
addpath(genpath(pathToChronux))

pathToOpenEphys = 'C:\Users\Janie\Documents\GitHub\analysis-tools\';
addpath(genpath(pathToOpenEphys))

figSavePath = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Figs';

%%
EphysDir = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Ephys\';
chanSet = 2;
%chanMap = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5]; % deepes first, acute

extSearch ='*.continuous*';
allOpenEphysFiles=dir(fullfile(EphysDir,extSearch));
nFiles=numel(allOpenEphysFiles);

for s=chanSet
    
    eval(['fileAppend = ''100_CH' num2str(s) '.continuous'';'])
    fileName = [EphysDir fileAppend];    
    [data, timestamps, info] = load_open_ephys_data(fileName);
    
end


%% Filter
fs_orig = info.header.sampleRate;

fObj = filterData(fs_orig);

fobj.filt.FN =filterData(fs_orig);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;


[data_shift,nshifts] = shiftdim(data',-1);
data_FNotch = squeeze(fobj.filt.FN.getFilteredData(data_shift));
  
            %%
timestamps_s = timestamps(1:end) - timestamps(1);
  
fs_new = 1000;

nSamps_ds = fs_orig/fs_new;

%% downsample Data

data_ds = downsample(data_FNotch, nSamps_ds);
timestamsps_ds_s = downsample(timestamps_s, nSamps_ds);


%% Params

movingwin=[0.5 0.05]; % set the moving window dimensions
%movingwin=[10 1]; % set the moving window dimensions
 
params.Fs=fs_new;%: sampling frequency (slightly different interpretation for spike times
params.tapers=[3 5];%: controls the number of tapers
%params.tapers=[3 5];%: controls the number of tapers
params.pad  = 1; %: controls the padding
params.fpass=[0 300]; %: frequency range of interest
params.err=0; %: controls error computation
params.trialave=0; %: controls whether or not to average over trials
    
% params.Fs=1000; % sampling frequency
% params.fpass=[0 100]; % frequency of interest
% params.tapers=[5 9]; % tapers
% params.trialave=1; % average over trials
% params.err=0; % no error computation

%%
%%
%rmlinesc.m data=rmlinesc(data,params,p,plt,f0)
%data_notch = rmlinesc(data_ds, params, 0.05/(size(data_ds,1)), 'y');


%rmlinesmovingwinc.m


%%
roi = 1:5000;
dataSeg = data_ds(roi);

%%
FiltOrder = 2;
%FOI = [1.5 300]; %[HighPass LowPass]
%FOI = [1.5 300]; %[HighPass LowPass]
FOI = [30 40]; %[HighPass LowPass]

%[b_l,a_l] = butter(FiltOrder, FOI(2)/(SampleRate/2), 'low' );

%[b_h,a_h] = butter(FiltOrder, FOI(1)/(fs_new/2), 'high' );

[b_b, a_b] = butter(FiltOrder, FOI/(fs_new/2), 'bandpass' );


%FiltData = filtfilt(b_h,a_h,dataSeg);
FiltData = filtfilt(b_b,a_b,dataSeg);

figure(200); clf
plot(dataSeg);
hold on
plot(FiltData, 'k');

% fObj = filterData(fs_new);
% 
% fobj.filt.FL=filterData(fs_new);
% fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
% fobj.filt.FL.lowPassStopCutoff=40;
% fobj.filt.FL.attenuationInLowpass=20;
% fobj.filt.FL=fobj.filt.FL.designLowPass;
% fobj.filt.FL.padding=true;




%%


%%
[S,t,f]=mtspecgramc(dataSeg,movingwin,params); % compute spectrogram
meanS = mean(S);
 X=10*log10(S);
 X_mean=10*log10(meanS);
figure(100); clf
%subplot(2, 1, 1)
plot(f,X, 'color', [0.5 0.5 0.5]);
hold on
plot(f,X_mean, 'k', 'linewidth', 2);
%subplot(2, 1, 2)
%plot(f,S);

%%


bla = S';  
plot_vector(S,f);

%subplot(221);
plot_matrix(S,t,f); xlabel([]); % plot spectrogram
caxis([8 28]); colorbar;
set(gca,'FontName','Times New Roman','Fontsize', 14);
title({['LFP 1,  W=' num2str(params.tapers(1)/movingwin(1)) 'Hz']; ['moving window = ' num2str(movingwin(1)) 's, step = ' num2str(movingwin(2)) 's']});
ylabel('frequency Hz');



%%