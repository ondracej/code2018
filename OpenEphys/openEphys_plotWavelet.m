function [] = openEphys_plotWavelet()
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
DataSeg_FN = fobj.filt.FN.getFilteredData(thisSegData);

%% Data Segment

%thisROI = 520*Fs:640*Fs;

%thisROI = 715*Fs:835*Fs;
thisROI = 720*Fs:730*Fs;
%thisSegData = DataSeg_FN(:,:, thisROI);
thisSegData = DataSeg_FH2(:,:, thisROI);

%%

dsf = 20;
Fsd = Fs/dsf;
hcf = 400;
[n_ch,n_tr,N] = size(thisSegData);
[bb,aa] = butter(2,hcf/(Fs/2),'low');
V_ds = reshape(permute(thisSegData,[3 1 2]),[],n_ch*n_tr);
V_ds = downsample(filtfilt(bb,aa,V_ds),dsf);
V_ds = reshape(V_ds,[],n_ch,n_tr);

%%
[N,n_chs,n_trials] = size(V_ds);
nfreqs = 60;
min_freq = 1.5;
max_freq = 400;
Fsd = Fs/dsf;
min_scale = 1/max_freq*Fsd;
max_scale = 1/min_freq*Fsd;
wavetype = 'cmor1-1';
scales = logspace(log10(min_scale),log10(max_scale),nfreqs);
wfreqs = scal2frq(scales,wavetype,1/Fsd);

use_ch = 1;
cur_V = squeeze(V_ds(:,use_ch,:));
V_wave = cwt(cur_V(:),scales,wavetype);
%avg_pspec = mean(abs(V_wave),2);

V_wave = reshape(V_wave,nfreqs,[],n_trials);
%avg_specgram = squeeze(mean(abs(V_wave),3));
% avg_specgram = squeeze(mean(abs(V_wave),2));
%%
  %%
f1 = figure(1); clf
tr = 1;

subplot(4,1,1)
plot((1:N)/Fsd,squeeze(V_ds(:,use_ch,tr)), 'k');
axis tight
ylim([-100 100])
%xlim(xr)

subplot(4,1,2)
pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
%set(gca,'yscale','log');
axis tight
ylim([0 400])
caxis([0 100]);

subplot(4,1,3)
pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
set(gca,'yscale','log');
axis tight
ylim([0 150])
caxis([0 2000]);

thisSegData_ms = timestamps(thisROI);
thisSegData_ms = thisSegData_ms-thisSegData_ms(1);
thisSegData_s = thisSegData_ms;


subplot(4, 1, 4); cla
thisSegData_FL = squeeze(DataSeg_FL(:,:, thisROI));
thisSegData_FH2 = squeeze(DataSeg_FH2(:,:, thisROI));
plot(thisSegData_s, thisSegData_FL, 'b')
hold on
plot(thisSegData_s, thisSegData_FH2 +700, 'k')
axis tight
ylim([-1000 1000])

xlabel('Time [s]')
%%

end

