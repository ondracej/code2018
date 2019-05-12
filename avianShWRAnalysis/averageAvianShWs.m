function [] = averageAvianShWs()
dbstop if error
close all

hostName = gethostname;
switch hostName
    case 'DEADPOOL'
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
        
        saveDir = ['/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/'];
        saveName = [saveDir 'ShWDetection_Chick2_17-29-04_'];
        DetectionFileToLoad = '/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/ScreenedDetectionsInds.mat';
        
    case 'TURTLE'
        
        addpath(genpath('/home/janie/code/code2018/'))
        dirD = '/';
        
        %% Use these
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous'; %DV=2526, 30 min
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %DV=2998
        fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one %DV=3513
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous'; %DV=1806 %DV=4042
        
        saveDir = ['/home/janie/Dropbox/00_Conferences/SFN_2018/figsForPoster/'];
        
        
end


%% Loading Data

[pathstr,name,ext] = fileparts(fileName);
bla = find(fileName == dirD);
dataName = fileName(bla(end-1)+1:bla(end)-1);
%saveName = [pathstr dirD dataName '-fullData'];
[data, timestamps, info] = load_open_ephys_data(fileName);
Fs = info.header.sampleRate;

fObj = filterData(Fs);

%% Filters

% fobj.filt.FL=filterData(Fs);
% %fobj.filt.FL.lowPassPassCutoff=4.5;
% fobj.filt.FL.lowPassPassCutoff=8;
% fobj.filt.FL.lowPassStopCutoff=10;
% fobj.filt.FL.attenuationInLowpass=20;
% fobj.filt.FL=fobj.filt.FL.designLowPass;
% fobj.filt.FL.padding=true;

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

%%
[V_uV_data_full,nshifts] = shiftdim(data',-1);

thisSegData = V_uV_data_full(:,:,:);
thisSegData_s = timestamps(1:end) - timestamps(1);


DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(thisSegData));
DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(thisSegData));

%%
d = load(DetectionFileToLoad);
peakTimes_fs = d.PeakTimes;
nPeaks = numel(peakTimes_fs);

peakWinL = 0.1*Fs;
peakWinR = 0.1*Fs;

FNotch_roi = cell(1, nPeaks);
HF_roi = cell(1, nPeaks);
roi_s = cell(1, nPeaks);

for j = 1:nPeaks
    
    roi = peakTimes_fs(j)-peakWinL:peakTimes_fs(j)+peakWinR;
    FNotch_roi{j} = DataSeg_FNotch(roi);
    HF_roi{j} = DataSeg_HF(roi);
    roi_s{j} = thisSegData_s(roi);
end


roi_s = (1:numel(roi))/Fs;
xticklabs = {'-1.0', '-0.5', '0', '0.5', '1.0'};

allNotch = cell2mat(FNotch_roi);
allNotch_mean = nanmean(allNotch, 2);
allNotch_median = nanmedian(allNotch, 2);
sem = (std(allNotch'))/(sqrt(size(allNotch, 2)));

%%
figH = figure(100); clf
subplot(2, 1, 1)
jbfill(roi_s,[allNotch_mean'+sem],[allNotch_mean'-sem],[.5,0.5,.5],[.5,0.5,.5],[],.3);
hold on
plot(roi_s, allNotch_mean, 'k', 'linewidth', 2);
%jbfill(roi_s,[allNotch_mean'+sem],[allNotch_mean'-sem],[0,0.7,1],[0,0.7,1],[],.3);

axis tight
bla = get(gca, 'xtick');

%set(gca, 'xticklabels', xticklabs);

%%

allHF = cell2mat(HF_roi);
allHF_mean = nanmean(allHF, 2);
allHF_median = nanmedian(allHF, 2);
sem_HF = (std(allHF'))/(sqrt(size(allHF, 2)));

subplot(2, 1, 2)
jbfill(roi_s,[allHF_mean'+sem_HF],[allHF_mean'-sem_HF],[.5,0.5,.5],[.5,0.5,.5],[],.3);
hold on
plot(roi_s, allHF_mean, 'k', 'linewidth', 2);
axis tight
%bla = get(gca, 'xtick');
%set(gca, 'xticklabels', xticklabs);

%%
saveName = [saveDir 'chick2-17-29-04_Average'];

plotpos = [0 0 15 20];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%% Wavelet on Mean

thisSegData_wav = allHF_mean(1:6000);
[thisSegData_wav,nshifts] = shiftdim(thisSegData_wav',-1);


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

V_wave = reshape(V_wave,nfreqs,[],n_trials);

%%
figure;
tr = 1;
pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
%set(gca,'yscale','log');
axis tight
%ylim([0 400])
caxis([0 5]);
%xlim([22.1 22.4])



%%

peakWinL = 0.05*Fs;
peakWinR = 0.03*Fs;

FNotch_roi = cell(1, nPeaks);
HF_roi = cell(1, nPeaks);
roi_s = cell(1, nPeaks);

for j = 1:nPeaks
    
    roi = peakTimes_fs(j)-peakWinL:peakTimes_fs(j)+peakWinR;
    FNotch_roi{j} = DataSeg_FNotch(roi);
    HF_roi{j} = DataSeg_HF(roi);
    roi_s{j} = thisSegData_s(roi);
end

allHF = cell2mat(HF_roi);
allHF_mean = nanmean(allHF, 2);
allHF_median = nanmedian(allHF, 2);
plot(roi_s{1}, allHF_median, 'k', 'linewidth', 2);
%%

params.tapers = [1 2];
params.Fs = Fs;
params.trialave = 0;
params.fpass = [40 800]; % defined above
params.movingWin = [.1*Fs .05*Fs];

  [S,f] = mtspectrumc(allHF_mean, params);
  figure(200); clf;
    plot_vector(S,f, [], [], 'k'); % raw data
axis tight
ylim([-50 -10])


end
