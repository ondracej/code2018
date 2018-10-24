function [] = makeFiguesForSFNPoster()


addpath(genpath('/home/janie/Code/code2018/'))
dirD = '/';

%% Penetration 4
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-19-16/100_CH1.continuous'; %DV=1806
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-03-12/100_CH1.continuous'; %DV=2207 


%% Use these
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous'; %DV=2526, 30 min
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %DV=2998
fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one %DV=3513
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous'; %DV=1806 %DV=4042

%% Loading Data

[pathstr,name,ext] = fileparts(fileName);
bla = find(fileName == dirD);
dataName = fileName(bla(end-1)+1:bla(end)-1);
saveName = [pathstr dirD dataName '-fullData'];
[data, timestamps, info] = load_open_ephys_data(fileName);
Fs = info.header.sampleRate;

fObj = filterData(Fs);

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
                    
%% Single Data Plot

[V_uV_data_full,nshifts] = shiftdim(data',-1);

thisSegData = V_uV_data_full(:,:,:);
thisSegData_ms = timestamps(1:end) - timestamps(1);

%figure
%plot(thisSegData_ms, squeeze(thisSegData));

%%
%chick2-16-30-56_30s
%thisROI = 1540*Fs:1570*Fs;
%thisROI = 1736*Fs:1766*Fs;

%chick2-17-05-32_30s
%thisROI = 580*Fs:610*Fs;
%thisROI = 590*Fs:620*Fs;

%chick2-17-29-04_30s
%thisROI = 715*Fs:745*Fs;
%thisROI = 605*Fs:635*Fs;
thisROI = 607*Fs:637*Fs;

%17-56-36
%thisROI = 290*Fs:320*Fs;

%
SegData = thisSegData(:,:, thisROI);
SegData_ms = thisSegData_ms(thisROI);

DataSeg_FN = fobj.filt.FN.getFilteredData(SegData);
DataSeg_FL = fobj.filt.FL.getFilteredData(SegData);
DataSeg_FH2 = fobj.filt.FH2.getFilteredData(SegData);

%
fig2 = figure(105);clf
subplot(3, 1, 1)
plot(SegData_ms, squeeze(DataSeg_FN), 'k');
axis tight
ylim([-1000 1000])
subplot(3, 1, 2)
plot(SegData_ms, squeeze(DataSeg_FL), 'k');
axis tight
ylim([-1000 1000])
subplot(3, 1, 3)
plot(SegData_ms, squeeze(DataSeg_FH2), 'k');
axis tight
ylim([-150 150])
xlabel ('Time [s]')
%%

saveDir = ['/home/janie/Dropbox/00_Conferences/SFN_2018/figsForPoster/'];
saveName = [saveDir 'chick2-16-30-56_30s'];
%saveName = [saveDir 'chick2-17-29-04_30s'];
%saveName = [saveDir 'chick2-17-56-36_30s'];
%saveName = [saveDir 'chick2-17-05-32_30s'];

plotpos = [0 0 25 20];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%% Wavelet

thisROI = 607*Fs:637*Fs;
thisSegData_V = thisSegData(:,:, thisROI);
thisSegData_wav = fobj.filt.FN.getFilteredData(thisSegData_V);

dsf = 20;
Fsd = Fs/dsf;
hcf = 400;
[n_ch,n_tr,N] = size(thisSegData_wav);
[bb,aa] = butter(2,hcf/(Fs/2),'low');
V_ds = reshape(permute(thisSegData_wav,[3 1 2]),[],n_ch*n_tr);
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



f1 = figure(1); clf
tr = 1;

subplot(2,1,1)
plot((1:N)/Fsd,squeeze(V_ds(:,use_ch,tr)), 'k');
axis tight
ylim([-1000 400])
xlim([10 25])
%xlim(xr)


%bla= 22:0.04:22.50;
%set(gca, 'xtick', bla)

subplot(2,1,2)
pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
%set(gca,'yscale','log');
axis tight
ylim([0 400])
caxis([0 200]);
xlim([10 25])

xlabel('Time [s]')
ylabel('Frequency [Hz]')
%%


saveDir = ['/home/janie/Dropbox/00_Conferences/SFN_2018/figsForPoster/'];
saveName = [saveDir 'chick2-17-29-04_wavelet_long_bottomtest'];

plotpos = [0 0 25 20];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%print_in_A4(0, saveName, '-depsc', 1, plotpos);
print_in_A4(0, saveName, '-depsc', 3, plotpos);



  %%
f1 = figure(1); clf
tr = 1;

subplot(2,1,1)
plot((1:N)/Fsd,squeeze(V_ds(:,use_ch,tr)), 'k');
axis tight
ylim([-1000 200])
xlim([22.0 22.54])
%xlim(xr)


%bla= 22:0.04:22.50;
%set(gca, 'xtick', bla)

subplot(2,1,2)
pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
%set(gca,'yscale','log');
axis tight
ylim([0 400])
caxis([0 200]);
xlim([22.0 22.5])

xlabel('Time [s]')
ylabel('Frequency [Hz]')
% subplot(3,1,3)
% pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
% %set(gca,'yscale','log');
% axis tight
% ylim([100 400])
% caxis([0 100]);
% xlim([22.0 22.5])


%subplot(3,1,3)
%pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
%set(gca,'yscale','log');
%axis tight
%ylim([0 150])
%xlim([21.5 22.5])
%xlim([22.0 22.5])

%%
saveDir = ['/home/janie/Dropbox/00_Conferences/SFN_2018/figsForPoster/'];
saveName = [saveDir 'chick2-17-29-04_wavelet'];

plotpos = [0 0 15 20];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


end
